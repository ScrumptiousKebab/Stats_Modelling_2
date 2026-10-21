# ============================================================
# Week 4: Binomial Regression
# Mao Mao
# Research question:
# Is previous injury history associated with current-season injury?
# ============================================================

# 1. Read the player data
players <- read.csv("league_players.csv")

# 2. Check the data
dim(players)
names(players)
str(players)

# 3. Check the binary outcome
table(players$injured)
prop.table(table(players$injured))

# 4. Fit the binomial logistic regression model
model1 <- glm(
  injured ~ prev_injuries,
  data = players,
  family = binomial(link = "logit")
)

# 5. View the model results
summary(model1)

# 6. Convert the coefficient into an odds ratio
exp(coef(model1))

# 7. Calculate 95% confidence intervals for odds ratios
exp(confint(model1))



# Fit an adjusted binomial logistic regression model
model2 <- glm(
  injured ~ prev_injuries + age + minutes_played +
    training_load + bmi + position,
  data = players,
  family = binomial(link = "logit")
)

# Display the model results
summary(model2)

# Convert coefficients to odds ratios
exp(coef(model2))

# Calculate 95% confidence intervals for odds ratios
exp(confint(model2))

# Compare the two models using AIC
AIC(model1, model2)

# Likelihood ratio test: does model2 improve on model1?
anova(model1, model2, test = "Chisq")

# Basic diagnostic plots for Model 2
par(mfrow = c(2, 2))
plot(model2)
par(mfrow = c(1, 1))

# Save predicted probabilities
players$predicted_probability <- predict(
  model2,
  type = "response"
)

head(players[
  c("injured", "prev_injuries", "predicted_probability")
])

write.csv(
  players,
  "players_with_predictions.csv",
  row.names = FALSE
)
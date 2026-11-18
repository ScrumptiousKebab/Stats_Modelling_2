# MTH6134 - Week 5 Diagnostics on Binomial Regression

data_dir <- NULL
for (candidate in c(".", "..")) {
  if (file.exists(file.path(candidate, "data", "league_players.csv"))) {
    data_dir <- file.path(candidate, "data")
    break
  }
}
if (is.null(data_dir)) {
  local_dir <- "C:/School/Stat modelling/Data"
  if (file.exists(file.path(local_dir, "league_players.csv"))) {
    data_dir <- local_dir
  }
}
if (is.null(data_dir)) {
  stop("Cannot find league_players.csv. Edit local_dir above to point at your data folder.")
}

players <- read.csv(file.path(data_dir, "league_players.csv"))

model1 <- glm(injured ~ prev_injuries, data = players,
              family = binomial(link = "logit"))

model2 <- glm(injured ~ prev_injuries + age + minutes_played +
                training_load + bmi + position,
              data = players, family = binomial(link = "logit"))

# ---- A. Deviance residuals ----
dev_resid <- residuals(model2, type = "deviance")
summary(dev_resid)

# ---- B. Standardised deviance residuals ----

std_dev_resid <- rstandard(model2, type = "deviance")
flagged <- which(abs(std_dev_resid) > 2)
cat("Flagged (|r'| > 2):", length(flagged), "of", nrow(players), "\n")
data.frame(players[flagged, c("injured", "prev_injuries", "age")],
           fitted = round(fitted(model2)[flagged], 3),
           std_dev_resid = round(std_dev_resid[flagged], 3))

# ---- C. Residuals vs fitted ----
plot(fitted(model2), std_dev_resid,
     xlab = "Fitted probabilities", ylab = "Standardised deviance residuals",
     main = "Std. Deviance Residuals vs Fitted (model2)")
abline(h = 0, lty = 2)
abline(h = c(-2, 2), lty = 2, col = "red")

# ---- D. QQ-plot ----
qqnorm(std_dev_resid, main = "Normal Q-Q Plot of Standardised Deviance Residuals")
qqline(std_dev_resid)

# ---- E. Pearson residuals ----
pearson_resid <- residuals(model2, type = "pearson")
plot(fitted(model2), pearson_resid,
     xlab = "Fitted probabilities", ylab = "Pearson residuals",
     main = "Pearson Residuals vs Fitted")
abline(h = 0, lty = 2)

# ---- F. Leverage ----
hat_vals <- hatvalues(model2)
cat("mean(hatvalues):", round(mean(hat_vals), 4),
    " p/n:", round(length(coef(model2)) / nrow(players), 4), "\n")
head(sort(hat_vals, decreasing = TRUE), 10)

# ---- G. Cook's distance ----
cooks_d <- cooks.distance(model2)
plot(cooks_d, type = "h", xlab = "Player index", ylab = "Cook's distance",
     main = "Cook's distance (model2)")
abline(h = 4 / nrow(players), lty = 2, col = "red")
influential <- which(cooks_d > 4 / nrow(players))
cat("Flagged by 4/n rule of thumb:", length(influential), "of", nrow(players), "\n")

# ---- Goodness of fit (read the caution below before trusting the p-values) ----
cat("Residual deviance:", model2$deviance, "on", model2$df.residual, "df\n")
cat("Deviance GOF p-value:", 1 - pchisq(model2$deviance, model2$df.residual), "\n")
pearson_stat <- sum(pearson_resid^2)
cat("Pearson GOF p-value:", 1 - pchisq(pearson_stat, model2$df.residual), "\n")


# ---- Model comparison (unaffected by the GOF caveat above) ----
AIC(model1, model2)
anova(model1, model2, test = "Chisq")

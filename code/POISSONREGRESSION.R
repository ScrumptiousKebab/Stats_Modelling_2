# 1. MATCH DATA: Poisson Regression on Goals Scored
ashford_matches <- read.csv("ashford_matches.csv")

# Fit Poisson models (R handles 'home_away' as a factor automatically)
goals_log <- glm(goals_scored ~ home_away + opponent_rank, family = poisson, data = ashford_matches)
goals_sqrt <- glm(goals_scored ~ home_away + opponent_rank, family = poisson(link = "sqrt"), data = ashford_matches)

# Goodness of Fit Test
print(paste("Goodness of Fit p-value (Matches):", 1 - pchisq(goals_log$deviance, goals_log$df.residual)))

# Parsimonious Model Selection
drop1(goals_log, test = "Chisq")



# 2. PLAYER DATA: Poisson Regression on Previous Injuries

league_players <- read.csv("league_players.csv")

# Fit model (R handles 'position' as a factor automatically)
injuries_glm <- glm(prev_injuries ~ age + training_load + position, family = poisson, data = league_players)

# Parsimonious Model Selection
drop1(injuries_glm, test = "Chisq")



# 3. DIAGNOSTIC PLOTS

# Automatically generate the 4 standard diagnostic plots
par(mfrow=c(2,2))
plot(injuries_glm) 
par(mfrow=c(1,1))
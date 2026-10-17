# MTH6134 - Week 3: Introduction to GLMs
# Mikael Garayev
# I have used the league data rather than the small examples from the lab.
# Run this in RStudio. I save my output so it can also be viewed on GitHub.

# 1. Find the data files
# They should be in the data folder. This works if RStudio is opened
# in the main project folder or in the code folder.
project_dir <- "."
if (!file.exists(file.path(project_dir, "data", "league_players.csv"))) {
  project_dir <- ".."
}
if (!file.exists(file.path(project_dir, "data", "league_players.csv")) ||
    !file.exists(file.path(project_dir, "data", "ashford_matches.csv"))) {
  stop("Cannot find the CSV files. Open Stats_Modelling_2.Rproj and run the script again.")
}

out_dir <- file.path(project_dir, "outputs", "week3")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
players <- read.csv(file.path(project_dir, "data", "league_players.csv"))
matches <- read.csv(file.path(project_dir, "data", "ashford_matches.csv"))

# 2. Check what is in the data
# injured is 0 or 1, so its mean is the proportion of players injured.
injury_rates <- aggregate(injured ~ position, data = players, FUN = mean)
mean_goals <- mean(matches$goals_scored)
variance_goals <- var(matches$goals_scored)

# 3. Pick suitable response variables for different GLMs
# These are only possible models - I am not deciding our final group models.
model_choices <- data.frame(
  response = c("bmi", "injured", "goals_scored"),
  type = c("continuous", "binary", "count"),
  family = c("Gaussian", "Binomial", "Poisson"),
  link = c("identity", "logit", "log"),
  possible_predictor = c("age", "prev_injuries", "opponent_rank")
)

# 4. Try a Poisson GLM on the match data
# This is similar to Q3 of the practical, but with actual match data.
# A higher opponent_rank means a lower-placed opponent.
goal_model <- glm(goals_scored ~ opponent_rank,
                  family = poisson(link = "log"), data = matches)
rank_beta <- unname(coef(goal_model)["opponent_rank"])
rate_ratio <- exp(rank_beta)
rank_se <- summary(goal_model)$coefficients["opponent_rank", "Std. Error"]
rank_ci <- rank_beta + c(-1, 1) * qnorm(0.975) * rank_se

# 5. Try IWLS manually, following the formula from Q3
# The lab starts with mu = y, but some matches have 0 goals,
# and log(0) would not work. I start with the overall mean instead.
y <- matches$goals_scored
X <- model.matrix(~ opponent_rank, data = matches)
beta <- c(log(mean(y)), 0)
iwls_steps <- data.frame(iteration = integer(), intercept = double(),
                         opponent_rank = double())
for (i in 1:50) {
  eta <- as.vector(X %*% beta)
  mu <- exp(eta)
  z <- eta + (y - mu) / mu
  W <- diag(as.vector(mu))
  beta_new <- as.vector(solve(t(X) %*% W %*% X,
                              t(X) %*% W %*% z))
  iwls_steps <- rbind(iwls_steps,
                      data.frame(iteration = i, intercept = beta_new[1],
                                 opponent_rank = beta_new[2]))
  change <- max(abs(beta_new - beta))
  beta <- beta_new
  if (change < 1e-8) break
}

# 6. Print the results and save the same text in outputs/week3/results.txt
# I can see these in the Console and my group can read the text file on GitHub.
results <- capture.output({
  cat("WEEK 3 - MIKAEL: INTRODUCTION TO GLMS\n\n")
  cat("1. DATA CHECKS\n")
  cat("Players:", nrow(players), "  Matches:", nrow(matches), "\n")
  cat("Missing player values:", sum(is.na(players)), "\n")
  cat("Missing match values:", sum(is.na(matches)), "\n\n")
  cat("First few player rows:\n")
  print(head(players))
  cat("\nFirst few match rows:\n")
  print(head(matches))
  cat("\nInjured players (0 = no, 1 = yes):\n")
  print(table(players$injured))
  cat("\nGoals scored per match:\n")
  print(table(matches$goals_scored))
  cat("\nMean goals:", round(mean_goals, 3), "\n")
  cat("Variance of goals:", round(variance_goals, 3), "\n")
  cat("\nInjury proportion by position:\n")
  print(injury_rates)
  cat("\nAverage goals at home and away:\n")
  print(aggregate(goals_scored ~ home_away, matches, mean))
  cat("\n2. POSSIBLE GLM FAMILIES\n")
  print(model_choices, row.names = FALSE)
  cat("\n3. POISSON MODEL: goals_scored ~ opponent_rank\n")
  print(summary(goal_model))
  cat("\nExp(rank coefficient):", round(rate_ratio, 3), "\n")
  cat("Approx. 95% CI for rank coefficient:", round(rank_ci, 3), "\n")
  cat("\n4. IWLS STEPS\n")
  print(iwls_steps, row.names = FALSE)
  cat("\nFinal IWLS coefficients:\n")
  print(round(beta, 5))
  cat("From glm():\n")
  print(round(as.vector(coef(goal_model)), 5))
  cat("Largest difference:", max(abs(beta - coef(goal_model))), "\n")
})
cat(paste(results, collapse = "\n"), "\n")
writeLines(results, file.path(out_dir, "results.txt"))

# 7. Make the graphs and save them as PNGs for GitHub
png(file.path(out_dir, "goals_scored.png"), width = 800, height = 500)
barplot(table(matches$goals_scored),
        main = "Ashford goals scored per match",
        xlab = "Goals scored", ylab = "Number of matches")
dev.off()

png(file.path(out_dir, "injury_by_position.png"), width = 800, height = 500)
barplot(injury_rates$injured, names.arg = injury_rates$position,
        main = "Proportion injured by playing position",
        xlab = "Position", ylab = "Proportion injured", ylim = c(0, 0.35))
dev.off()

rank_values <- seq(min(matches$opponent_rank), max(matches$opponent_rank))
predicted_goals <- predict(goal_model,
                           newdata = data.frame(opponent_rank = rank_values),
                           type = "response")
png(file.path(out_dir, "goals_vs_opponent_rank.png"), width = 800, height = 500)
plot(matches$opponent_rank, matches$goals_scored,
     xlab = "Opponent rank (1 = best)", ylab = "Goals scored",
     main = "Goals scored against opponent rank", pch = 19)
lines(rank_values, predicted_goals, lwd = 2)
dev.off()

# This one also appears in the RStudio Plots pane.
plot(matches$opponent_rank, matches$goals_scored,
     xlab = "Opponent rank (1 = best)", ylab = "Goals scored",
     main = "Goals scored against opponent rank", pch = 19)
lines(rank_values, predicted_goals, lwd = 2)

# 8. Save a short Markdown results page that GitHub can display
# The links below are relative to outputs/week3/results.md.
md <- c(
  "# Week 3 - Mikael: Introduction to GLMs", "",
  "I looked through both datasets to decide which responses could be modelled using a GLM.", "This is exploratory work, not our final group model.", "",
  "## Data checks", "",
  "| Check | Result |", "|---|---:|",
  sprintf("| Players | %d |", nrow(players)),
  sprintf("| Ashford matches | %d |", nrow(matches)),
  sprintf("| Missing values | %d |", sum(is.na(players)) + sum(is.na(matches))),
  sprintf("| Players injured | %d |", sum(players$injured)),
  sprintf("| Matches with zero goals | %d |", sum(y == 0)),
  sprintf("| Mean goals scored | %.3f |", mean_goals),
  sprintf("| Variance of goals scored | %.3f |", variance_goals), "",
  "## Response variables I considered", "",
  "| Response | Type | Possible GLM | Possible predictor |", "|---|---|---|---|",
  "| bmi | Continuous | Gaussian, identity link | age |",
  "| injured | Binary (0/1) | Binomial, logit link | prev_injuries |",
  "| goals_scored | Count | Poisson, log link | opponent_rank |", "",
  "## My Poisson example", "",
  "I fitted `goals_scored ~ opponent_rank` with a log link.",
  sprintf("The opponent rank coefficient was **%.4f** (approximate 95%% CI %.4f to %.4f).", rank_beta, rank_ci[1], rank_ci[2]),
  sprintf("For a rank increase of 1, the fitted expected goals are multiplied by **%.3f**, about **%.1f%% higher**.", rate_ratio, 100*(rate_ratio-1)),
  "A higher rank number means the opponent finished lower in the league. This is an association, not a causal effect.", "",
  "I also worked through IWLS using the formula in Question 3. I started from the average goal count",
  "because the data include zero-goal matches, which would cause a problem with `log(0)`.",
  sprintf("The largest difference between the final IWLS and `glm()` coefficients was **%.2g**.", max(abs(beta - coef(goal_model)))), "",
  "## Plots", "",
  "### Goals scored per match", "![Goals scored per match](goals_scored.png)", "",
  "### Injury proportion by position", "![Injury proportion by position](injury_by_position.png)", "",
  "### Goals against opponent rank", "![Goals against opponent rank](goals_vs_opponent_rank.png)", "",
  "## Things to check later", "",
  "One match has eight goals, so that match might affect the fitted line.",
  "The goals variance is also higher than the mean, which is worth checking when we do diagnostics.",
  "I have not chosen a final model here.", "",
  "[Full Console results](results.txt) | [R script](../../code/week3_Mikael.R) | [My notes](../../notes/week3_Mikael_notes.md)"
)
writeLines(md, file.path(out_dir, "results.md"))
cat("\nFinished. I saved the text, results page and 3 graphs in outputs/week3/.\n")

#reading in data
players_data <- read.csv("league_players.csv")
matches_data <- read.csv("ashford_matches.csv")

#getting names and type of variable from data
names(players_data)
str(players_data)
names(matches_data)
str(matches_data)
#double checking how many rows of data
nrow(players_data)
nrow(matches_data)
#summaries of data
summary(players_data)
summary(matches_data)

#checking distributions for players
hist(players_data$age, main = "Distribution of age", xlab = "Age")

hist(players_data$minutes_played, main = "Distribution of minutes played",xlab = "Minutes played")

hist(players_data$bmi, main = "Distribution of BMI",xlab = "BMI")

barplot(table(players_data$position),main = "Players by position",xlab = "Position",ylab = "Number of players")

#checking distributions for matches
barplot(table(matches_data$goals_scored), main = "Goals scored per match",xlab = "Goals scored",ylab = "Number of matches")
barplot(table(matches_data$goals_conceded),main = "Goals conceded per match",xlab = "Goals conceded",ylab = "Number of matches")
boxplot(goals_scored ~ home_away, data = matches_data,xlab = "Venue",ylab = "Goals scored")
plot(matches_data$opponent_rank, matches_data$goals_scored,xlab = "Opponent rank",ylab = "Goals scored")

#linear model test (tests relationship between BMI and age)
players_fit <- lm(bmi ~ age, data = players_data)
summary(players_fit)
plot(players_data$age, players_data$bmi,xlab = "Age",ylab = "BMI")
abline(players_fit, col = "red", lwd = 2)

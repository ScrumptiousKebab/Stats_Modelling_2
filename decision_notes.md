
# Decision Notes

## Week 3 - Introduction to GLMs
**Mikael Garayev | 17 October 2026**

### Initial exploration

I started by looking through both datasets to understand the variables and which ones might be suitable for different GLMs.

I considered three possible response variables:

- **BMI:** Gaussian model, since BMI is continuous.
- **Injured:** Binomial model, since it is either 0 or 1.
- **Goals scored:** Poisson model, since it is count data.

### Model choice

I decided to focus on goals scored against opponent rank because this was closest to Question 3 of the Week 3 practical.

I used a **Poisson GLM** with goals scored as the response and opponent rank as the explanatory variable.

For the IWLS calculation, I noticed that some matches had zero goals. Using the starting values from the practical would involve taking `log(0)`, so I used the overall mean number of goals instead.

### Observations

A few things I noticed:

- The variance of goals scored was higher than the mean, which could suggest overdispersion.
- One match had 8 goals, which might be worth checking during diagnostics.
- Opponent rank appeared to have a positive relationship with goals scored.

### Next steps

I kept all observations for now rather than removing any matches. The model still needs further diagnostic checks to see how well it fits the data.

These are just initial findings from Week 3, not a final model selection for the group project.



## Week 4 - Binomial Regression
**Mao Mao | 22 October 2026**

### Initial exploration

I started by reviewing the player dataset to identify a suitable binary response variable for binomial regression.

I focused on the injured variable, where 1 indicates that a player experienced an injury during the current season and 0 indicates otherwise.

The dataset contained 620 players, including 115 players who were injured during the season. There were no missing values in the dataset.

### Model choice

I decided to use binomial logistic regression because the response variable injured is binary.

I first fitted a model using prev_injuries as the explanatory variable to investigate whether previous injury history was associated with current-season injury status.

I then fitted an adjusted model including age, minutes_played, training_load, bmi and position to examine whether the association remained after accounting for these additional variables.

### Observations

A few things I noticed:

- The observed proportion of injured players increased with the number of previous injuries.
- In the initial model, prev_injuries had a positive estimated coefficient.
- The association between prev_injuries and current-season injury status remained statistically significant in the adjusted model.
- Age and training load were also positively associated with current-season injury status in the adjusted model.
- The AIC was lower for the adjusted model than for the initial model, suggesting an improvement in model fit.

These findings indicate statistical associations rather than causal relationships.

### Next steps

I will check the model output and diagnostic plots to assess whether the fitted models are reasonable.

I will also save the R code and relevant outputs in the shared workspace, including the model summaries, odds ratios, confidence intervals and model comparison results.

Finally, I will document any further modelling decisions and discuss the findings with the group before the final report is completed.

These are my current findings from Week 4 and should not be treated as the group's final model selection.

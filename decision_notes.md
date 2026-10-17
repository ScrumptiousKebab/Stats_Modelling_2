
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


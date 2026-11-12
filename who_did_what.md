
# Who Did What


## Lefteris Panayiotis - Week 2: Normal Linear Regression
For Week 2, I worked on exploring the datasets and the relationships between variables within the datasets, and applied a linear model to two of the variables.

- Looked through both datasets and checked/classified the variables.
- Produced summary statistics for both of the datasets
- Produced plots looking at the distributions of each variable individually, and then where applicable looked at distributions of two linked variables .
- Fitted a linear model exploring the relationship between BMI & age.
- Interpreted the results of the linear model through both plots and summary statistics to draw a conclusion regarding the validity of a linear model between these two variables

**Files:**  


## Mikael Garayev - Week 3: Introduction to GLMs

For Week 3, I worked on exploring the datasets and applying the GLM methods from the practical.

- Looked through both datasets and checked the variables, summary statistics and missing values.
- Identified possible response variables for Gaussian, binomial and Poisson GLMs.
- Fitted a Poisson GLM using goals scored and opponent rank.
- Worked through the IWLS calculation from Question 3 and compared it with R's `glm()` function.
- Produced graphs and saved the results so they could be viewed on GitHub.

**Files:** `code/week3_Mikael.R` and `outputs/week3/`


## Mao Mao - Week 4: Binomial Regression

For Week 4, I worked on fitting and interpreting binomial logistic regression models using the player dataset.

- Checked the player dataset and examined the binary response variable injured.
- Explored the relationship between previous injuries and current-season injury status.
- Fitted a binomial logistic regression model using prev_injuries as the explanatory variable.
- Fitted an adjusted model including age, minutes played, training load, BMI and playing position.
- Interpreted the estimated coefficients, odds ratios, confidence intervals and p-values.
- Compared the models using AIC and a likelihood ratio test.
- Started documenting the findings and identifying further model diagnostic checks.

**Files** `code/week4_Mao.R` and `outputs/week4`


## Shajesh Jeyashanker - Week 6: Poisson Regression

For Week 6, I worked on identifying count outcomes in the datasets and fitting Poisson regression models to them.

- Reviewed both datasets and selected goals_scored and prev_injuries as appropriate count response variables.
- Fitted Poisson GLMs for both variables, including testing a square-root link function alongside the default log link.   
- Performed parsimonious model selection using the difference in deviances test.   
- Conducted goodness-of-fit tests by comparing residual deviances to a Chi-square distribution to check for potential overdispersion.   
- Produced the standard diagnostic plots (residuals vs fitted, QQ-plots, Cook's distances, and leverage) to assess model fit.   
- Implemented relative file paths in the R script to ensure the code runs seamlessly across the group's shared workspace.


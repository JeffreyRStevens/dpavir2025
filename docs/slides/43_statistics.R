
# Evaluations!!!! (won't look until after grades are in)
# shinyapps.io


#### To run all of this code, you'll need to have the following packages installed. To install, just uncomment the next lines. ****Please do NOT try to install these during class! Several of these packages take a long time to install (e.g., afex, BayesFactor)!****
# install.packages(c("afex", "BayesFactor", "car", "effectsize", "lme4", "performance"))

#### I am not responsible for the misuse of null hypothesis significance testing!!!!
#### Also, I may not do things correctly here. Sometimes, I am just trying to illustrate principles and may not use proper statistical techniques.

#### Sometimes you can use a formula: y ~ x + z, data = df
#### Sometimes you have to use separate vectors: df$x, df$y (if data are long format, you may have to make them wide or create two vectors)

#### Resources
#### PsyTeachR (https://psyteachr.github.io/analysis-v2/, https://psyteachr.github.io/stat-models-v1/)
#### Cookbook for R (http://www.cookbook-r.com/Statistical_analysis/)
#### A Language, not a Letter: Learning Statistics in R (https://ademos.people.uic.edu/index.html)


library(tidyverse)

# Viewing data ------------------------------------------------------------

set.seed(2023) # this just means we'll always get the same random numbers
# Create data frame for non-human animal data
my_data <- data.frame(subject = rep(1:18, each = 3),  # create subject column
                      gender = factor(rep(c("Female", "Male", "Nonbinary"), each = 18)), # create gender column
                      age = factor(rep(c("Old", "Young"), each = 9)),  # create age column
                      time = factor(rep(c(1:3), times = 9)),  # create time column
                      response = rnorm(54),  # create response column
                      rt = round(rpois(54, lambda = 100) * 10 + 1000, 1),  # create response time column
                      binary = sample(x = c(0, 1), size = 54, replace = TRUE)  # create binary response column
)

# Print the first six rows of data
View(my_data)

# Make data set for just time 1
my_data1 <- my_data |>
  filter(time == 1)

# Create wide version for between-subjects analyses
my_data_between <- my_data1 |>
  select(age, response) |>
  arrange(age) |>
  mutate(id = rep(1:9, 2)) |>
  pivot_wider(names_from = age, values_from = response) |>
  select(-id)
head(my_data_between)

my_data_paired <- my_data |>
  filter(time != 3) |>
  pivot_wider(id_cols = subject, names_from = time, names_prefix = "time_", values_from = response)
head(my_data_paired)


# Confidence intervals ----------------------------------------------------

## Between-subjects confidence intervals from {papaja}
library(papaja)
ci(my_data$response)

# Incorporate into tidyverse
(gender_differences <- my_data |> # create tibble of means per gender
    group_by(gender) |> # for each level of gender column
    summarize(resp_means = mean(response), # calculate mean response
              resp_cis = ci(response) # calculate between-subjects confidence intervals
    ))

## Within-subjects confidence intervals
# Use wsci() from {papaja} to just get the CIs
wsci(data = my_data, id = "subject", factors = "time", dv = "response")
# Wrap it in summary() to include the means and generate the lower and upper limits
summary(wsci(data = my_data, id = "subject", factors = "time", dv = "response"))


# Correlations ------------------------------------------------------------
# Correlation matrix
cor(x = my_data[, c("response", "rt")])

# Correlation coefficient
cor(x = my_data$response, y = my_data$rt)

# Correlation hypothesis test
cor.test(my_data$response, my_data$rt)  # works with columns
cor.test(~ response + rt, data = my_data)  # or formula


# Comparing one or two groups (t-test, etc.) -------------------------------------------

## Non-parametric
# One-sample Wilcoxon signed rank test
wilcox.test(my_data$response, mu = 0)

# Two-sample, independent Wilcoxon rank sum test
wilcox.test(my_data_between$Old, my_data_between$Young)  # works with columns
wilcox.test(response ~ age, data = my_data1)  # and with formulas

# Paired Wilcoxon signed rank test
wilcox.test(my_data_paired$time_1, my_data_paired$time_2, paired = TRUE)  # works with columns
wilcox.test(response ~ time, data = filter(my_data, time != 3), paired = TRUE)  # and with formulas


## Parametric (t-tests)
# One-sample t-test
t.test(my_data$response, mu = 0)

# Two-sample, independent t-test
## Welch's t-test with variance *not* assumed to be equal (default)
t.test(my_data_between$Young, my_data_between$Old)  # works with columns
t.test(response ~ age, data = my_data1)  # and with formulas
## Student's t-test with variance assumed equal
t.test(response ~ age, data = my_data1, var.equal = TRUE)

# Paired t-test
t.test(my_data_paired$time_1, my_data_paired$time_2, paired = TRUE)  # works with columns
t.test(response ~ time, data = filter(my_data, time != 3), paired = TRUE)  # and with formulas


# Comparing more than two groups (ANOVA) ----------------------------------

## Non-parametric (Kruskal-Wallis test)
kruskal.test(response ~ time, data = my_data)

## Factorial ANOVA
aov(response ~ gender, data = my_data)
summary(aov(response ~ gender, data = my_data))  # need to use summary to see ANOVA table
summary(aov(response ~ gender + age, data = my_data))  # use + for multiple main effects (only)
summary(aov(response ~ gender:age, data = my_data))  # use : for interaction (only)
summary(aov(response ~ gender + age + gender:age, data = my_data))  # string them all together
aov_test <- aov(response ~ gender * age, data = my_data)  # use * for both main effects and interaction
summary(aov_test)

## Post-hoc comparisons (see {multcomp} package for more options)
TukeyHSD(aov_test)

## Repeated measures ANOVA
summary(aov(response ~ time + Error(subject), data = my_data))  # make subject within-subject factor (random effect)
summary(aov(response ~ age * time + Error(subject), data = my_data))

library(afex)  # try {afex} for powerful ANOVA and linear modeling functions
aov_ez(id = "subject", dv = "response", data = my_data, between = "age", within = "time")  # by default, this uses type III sums of squares, like SPSS
aov_ez(id = "subject", dv = "response", data = my_data, between = "age", within = "time", type = 2)  # but can set sums of squares, like II, which is what R uses by default


# Linear models -------------------------------------------------------
library(lme4)

my_data |>
  ggplot(aes(x = rt, y = response)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

my_data |>
  ggplot(aes(x = rt, y = response)) +
  geom_point() +
  geom_abline(slope = -0.0008709, intercept = 1.9269) +
  geom_smooth(method = "lm", se = FALSE) +
  xlim(0, 2300)

## Linear models
(lm_linear1 <- lm(response ~ rt, data = my_data))
summary(lm_linear1)  # like aov, use summary to see regression table
lm_linear2 <- lm(response ~ age + rt, data = my_data)  # uses same formula syntax as aov
summary(lm_linear2)
lm_linear3 <- lm(response ~ age * rt, data = my_data)
summary(lm_linear3)
lm_linear0 <- lm(response ~ 1, data = my_data)  # use 1 for null model
summary(lm_linear0)


## Linear mixed models
lmer_linear <- lmer(response ~ age * time + (1 | subject), data = my_data)  # add random effects
summary(lmer_linear)
anova(lmer(response ~ age * time + (1 | subject), data = my_data))

## Generalized linear models
glm_poisson <- glm(rt ~ gender, data = my_data, family = poisson)  # change family for generalized linear model
summary(glm_poisson)
?family
summary(glm(binary ~ age, data = my_data, family = binomial))  # logistic regression

## Generalized linear mixed models
summary(glmer(binary ~ age * time + (1 | subject), data = my_data, family = binomial))  # add random effects

# So lm, lmer, glm, glmer for linear/generalized linear models with our without random effects


# Assumption checks -------------------------------------------------------

## Residuals
# Plot data
ggplot(my_data, aes(x = rt, y = response)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Fit model
fit1 <- lm(response ~ rt, my_data)

## Normality of ***RESIDUALS***
plot(fit1)  # plotting a model cycles through a number of key plots
plot(density(residuals(fit1)))  # plot distribution of residuals
ggplot(fit1, aes(sample = rstandard(fit1))) +   # plot qqplot
  geom_qq() +
  stat_qq_line()

## Homogeneity of variance
boxplot(residuals(lm_linear1) ~ my_data$age) # view distributions
library(car)
leveneTest(residuals(lm_linear1) ~ my_data$age) # check assumption of equal variances with Levene's test

## Check them all with performance::check_model()
library(performance)
check_model(fit1)


# Effect sizes ------------------------------------------------------------

## Cohen's d
library(effectsize)
cohens_d(response ~ age, data = my_data1)

# Other effect sizes
summary(aov_test)
eta_squared(aov_test)

summary(lm_linear3)
standardize_parameters(lm_linear3)

# Convert between statistics and effect sizes
d_to_r(d = cohens_d(response ~ age, data = my_data1))
F_to_d(f = 1.578, df = 1, df_error = 44)

# https://easystats.github.io/easystats/



# Bayes factors -----------------------------------------------------------
library(BayesFactor)

# Correlation
correlationBF(my_data$response, my_data$rt)

# One-sample t-test
ttestBF(my_data$response, mu = 0)

# Two-sample, independent t-test
ttestBF(formula = response ~ age, data = my_data1)

# Two-sample, paired t-test
ttestBF(my_data_paired$time_1, my_data_paired$time_2, paired = TRUE)

# ANOVA
anovaBF(response ~ age, data = my_data)

# Repeated measures ANOVA
anovaBF(response ~ age * time, data = my_data, whichRandom = "subject")

# Regression
regressionBF(response ~ rt, data = my_data)

# Linear models
lmBF(response ~ rt, data = my_data)
lmBF(response ~ age * time, data = my_data, whichRandom = "subject")



# You did it!!!!! You are now an R wizard!

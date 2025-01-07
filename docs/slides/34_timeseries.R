# Plotting x-y data: time series

# Plot continuous variables over time or other sequential variables

library(tidyverse)

# Time series -------------------------------------------------------------

## Single series -----
# Get data used in FDV
preprint_data <- read_tsv("https://raw.githubusercontent.com/OmnesRes/prepub/master/analyses/preprint_data.txt") |>
  rename(source = `...1`) |>
  select(!`...146`)

# Create long version to plot and convert to date
preprint_long <- preprint_data |>
  pivot_longer(!source, names_to = "date", values_to = "submissions") |>
  mutate(date = lubridate::ym(date))

# Subset bioRxiv data
biorxiv_data <- preprint_long |>
  filter(source == "bioRxiv" & submissions > 0)

# Plot time series points
biorxiv_data |>
  ggplot(aes(x = date, y = submissions)) +
  geom_point()

# Plot time series line with geom_line()
biorxiv_data |>
  ggplot(aes(x = date, y = submissions)) +
  geom_line()

# Fill in area under line with geom_area()
biorxiv_data |>
  ggplot(aes(x = date, y = submissions)) +
  geom_line() +
  geom_area(fill = "steelblue")


## Multiple series -----

# Create data with three preprints
three_preprints <- preprint_long |>
  filter(source %in% c("bioRxiv", "arXiv q-bio", "PeerJ Preprints") & date > "2014-10-31" & date < "2017-02-01")

## How would we create separate lines for the three sources?
three_preprints |>
  ggplot(aes(x = date, y = submissions, group = source)) +
  geom_line()

# Oh, but they need different colors because the lines cross
three_preprints |>
  ggplot(aes(x = date, y = submissions, color = source)) +
  geom_line()

# Let's try to fill in the area under the lines
three_preprints |>
  ggplot(aes(x = date, y = submissions, color = source, fill = source)) +
  geom_line() +
  geom_area(position = "identity", alpha = 0.25)

# That works, but it's probably not a great idea

# Multiple series with crossed factors
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") %>%
  select(experiment, participant, condition, gender, pets_now, parent_income, panas_pre = panas_pre_pos,
         panas_post = panas_post_pos, anxiety = vas_anxiety_pre) %>%
  mutate(panas_diff = panas_post - panas_pre,
         parent_income = fct_relevel(parent_income, c("< $25000", "$25000-$50000", "$50000-$75000",  "$75000-$100000", "> $100000", "Preferred not to answer")),
         pets = fct_recode(factor(pets_now), "Has pets" = "1", "Has no pets" = "0")) |>
  unite("cond_gend", condition, gender, remove = FALSE)

## What if we have lines with multiple groups of crossed factors?
hai %>%
  ggplot(aes(x = parent_income, y = panas_diff, group = cond_gend)) +
  stat_summary(fun = mean, geom = "line") # note this calculates the mean panas_diff per parent_income and cond_gend and plots a line connecting the means

## If we add colors for groups, this helps but only color differentiates the groups
hai %>%
  ggplot(aes(x = parent_income, y = panas_diff, group = cond_gend, color = cond_gend)) +
  stat_summary(fun = mean, geom = "line")

## Add redundant coding by mapping color, shape, linetype to cond_gend
hai %>%
  ggplot(aes(x = parent_income, y = panas_diff, group = cond_gend, color = cond_gend, shape = cond_gend, linetype = cond_gend)) +
  stat_summary(fun = mean) +
  stat_summary(fun = mean, geom = "line")

# But since these are factorial combinations of levels, we can manually map properties to factor levels
hai %>%
  ggplot(aes(x = parent_income, y = panas_diff, group = cond_gend, color = cond_gend, shape = cond_gend, linetype = cond_gend)) +
  stat_summary(fun = mean) +
  stat_summary(fun = mean, geom = "line") +
  scale_color_manual(values = c("firebrick", "steelblue", "firebrick", "steelblue")) +
  scale_linetype_manual(values = c(1, 1, 2, 2)) +
  scale_shape_manual(values = c(1, 1, 17, 17))


# Fitting models -----

## Smooth functions -----
biorxiv_data |>
  ggplot(aes(x = date, y = submissions)) +
  geom_point()

# Plot fitted curve with geom_smooth(). How would we do it with no confidence bands?
biorxiv_data |>
  ggplot(aes(x = date, y = submissions)) +
  geom_point()


## Logistics regression ----
# Get data on dog owner cognitive ability and whether their dog passed the Canine Good Citizen test
dog_owner_data <- read_csv("https://raw.githubusercontent.com/unl-cchil/dogobedience2021/main/data/stevens_etal_2021_data1.csv") |>
  drop_na(date) |>
  select(id, crt_score, numeracy_score, cgc_test) |>
  mutate(cognitive_ability = crt_score + numeracy_score,
    cgc = if_else(cgc_test == "Pass", 1, 0, 0))

# Plot CGC passing by cognitive ability
dog_owner_data |>
  ggplot(aes(x = cognitive_ability, y = cgc)) +
  geom_point()

# Oops---probably lots of overlap. How do we make size scale to number of points?
dog_owner_data |>
  ggplot(aes(x = cognitive_ability, y = cgc)) +
  geom_count(show.legend = FALSE)

# Add logistic regression line but conducting GLM with binomial family
dog_owner_data |>
  ggplot(aes(x = cognitive_ability, y = cgc)) +
  geom_count(show.legend = FALSE) +
  geom_smooth(method = "glm", formula = y ~ x, method.args = list(family = "binomial"))

# Or use jittered plot
dog_owner_data |>
  ggplot(aes(x = cognitive_ability, y = cgc)) +
  geom_jitter(width = 0.1, height = 0.05) +
  geom_smooth(method = "glm", formula = y ~ x, method.args = list(family = "binomial"))

# Or beeswarm
dog_owner_data |>
  ggplot(aes(x = cognitive_ability, y = cgc)) +
  ggbeeswarm::geom_beeswarm() +
  geom_smooth(method = "glm", formula = y ~ x, method.args = list(family = "binomial"))


## Custom models ----
# Create data frame of Ebbinghaus's forgetting data
forgetting <- data.frame(time = c(1/3, 1, 9, 24, 48, 24*6, 24*31), ebbinghaus = c(0.582, 0.442, 0.358, 0.337, 0.278, 0.254, 0.211))

# Plot Ebbinghaus's forgetting data
forgetting |>
  ggplot(aes(x = time, y = ebbinghaus)) +
  geom_line()

# Add geom_smooth(). Not pretty (or accurate)
forgetting |>
  ggplot(aes(x = time, y = ebbinghaus)) +
  geom_line() +
  geom_smooth(se = FALSE)

# Fit power and exponential functions to data
power_model <- nls(ebbinghaus ~ a * time ^ b, data = forgetting, start = c(a = 0.47, b = -0.13))
expon_model <- nls(ebbinghaus ~ a * exp(-b * time), data = forgetting, start = c(a = 0.5, b = 0.001))

# Create sequence of times
time_seq <- 0:(24*31)

# Create data frame of predicted values by applying fitted functions to time sequence
forgetting_fit <- data.frame(time = time_seq, power = predict(power_model, list(time = time_seq)), expon = predict(expon_model, list(time = time_seq)))

# Plot fitted power function over observed data
forgetting |>
  ggplot(aes(x = time, y = ebbinghaus)) +
  geom_line() +
  geom_line(data = forgetting_fit, aes(y = power), color = "steelblue", linetype = 2) +
  geom_line(data = forgetting_fit, aes(y = expon), color = "firebrick", linetype = 3)



# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/34_timeseries.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/34_timeseries.html


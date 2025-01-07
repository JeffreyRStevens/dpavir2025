# Plotting x-y data: categories

# Plot continuous variables for categorical variables


library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(experiment, participant, condition, panas_pre = panas_pre_pos,
         panas_post = panas_post_pos)


# Strip plots -----
# Strip plots are plots of categorized points
# Let's plot panas_pre per condition
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_point()

# Lots of potential overlap. How can we deal with overlapping points?

# Modify transparency
hai %>%
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_point(alpha = 0.1)

# Map point size to number of points
hai %>%
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_count()


# Let's "jitter" or a little random noise to x and y
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_point(position = "jitter")

# Or use the geom_jitter() function to jitter the position of the data
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_jitter()

# We need to control degree of jitter with width and height arguments
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_jitter(width = 0.05, height = 0.02)

# Every time jitter is used, the randomness is regenerated
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_jitter(width = 0.05, height = 0.02)

# So set fixed randomness with set.seed()
set.seed(1)
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_jitter(width = 0.05, height = 0.02)

# Jittering can be useful, but doesn't always look great
# Beeswarm plots are more orderly than jitter
# install.packages("ggbeeswarm")
library(ggbeeswarm)

# Replace geom_jitter() with geom_beeswarm()
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_beeswarm()

# Weird justification by default. Let's center dots
hai |>
  ggplot(aes(x = condition, y = panas_pre)) +
  geom_beeswarm(method = "center")


# Interaction plots -----
# Let's wrangle the data to get two categorical variables plus a continuous one
hai_panas_pos <- hai |>
  filter(experiment == 2) |>
  select(participant, condition, panas_pre, panas_post) |>
  pivot_longer(-c("participant", "condition"), names_to = "prepost", values_to = "panas") |>
  mutate(prepost = fct_recode(prepost, "Pre" = "panas_pre", "Post" = "panas_post"),
         prepost = fct_relevel(prepost, c("Pre", "Post")),
         condition = fct_recode(condition, "Control" = "control", "HAI" = "hai"))

# Use stat_summary() to make interaction plot. Note that we have to add a second stat_summary() with geom = "line" to get the lines connecting the grouping variable condition.
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas, group = condition)) +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line")

# How do we color the conditions separately?
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas, group = condition)) +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line")

## I don't like that the error bars overlap for the Pre condition. How do we shift the position of the data? And also move the legend to be inside the plot.
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas, group = condition, color = condition)) +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line")

# What if you already have the means and error values that you want to plot? That is, what if you can't use stat_summary()?
# This often happens to me when I want to plot within-subjects confidence intervals.
# First, let's calculate our means and confidence intervals
hai_panas_wsci <- summary(papaja::wsci(hai_panas_pos, id = "participant", factors = c("condition", "prepost"), dv = "panas"))

# Now we can plot means and error bars with the geom_pointrange() function
hai_panas_wsci |>
  ggplot(aes(x = prepost, y = mean, color = condition)) +
  geom_pointrange(aes(ymin = lower_limit, ymax = upper_limit), position = position_dodge(width = 0.1)) +
  theme(legend.position = c(0.15, 0.9))

# And connect them with geom_line() making sure to map condition to the grouping aesthetic
hai_panas_wsci |>
  ggplot(aes(x = prepost, y = mean, color = condition)) +
  geom_pointrange(aes(ymin = lower_limit, ymax = upper_limit), position = position_dodge(width = 0.1)) +
  geom_line(aes(group = condition), position = position_dodge(width = 0.1)) +
  theme(legend.position = c(0.15, 0.9))


# Slopegraphs -----
# Slopegraphs plot paired categorical variables and a continuous variable.
# They usually work best when there are relatively few levels for both categorical variables.

# We're going to plot the individual participant Pre/Post data as a slopegraph

# Now we can plot all of the data as points
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_point()

# But we want to make lines that connect the points for each participant with geom_line()
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line()

## That didn't work. How do we fix this so that the lines map to participant?
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line()

## How do we make the lines lighter so the means stand out?
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas, group = participant)) +
  geom_line()

## How would we overlay means plus 95% CIs for prepost?
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas, group = participant)) +
  geom_line(color = "grey75")

## That didn't work. Why not?
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line(aes(group = participant), color = "grey75") +
  stat_summary(fun.data = mean_cl_normal)

## Now let's include a line that connects the means
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line(aes(group = participant), color = "grey75") +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line", aes(group = 1))


# Raincloud plots ----
# Raincloud plots plot both raw data as points and the density functions
# They require the {gghalves} or other packages.

library(gghalves)

# First, let's just add the dots and the half violins
hai |>
  ggplot(aes(x = condition, y = panas_post, fill = condition, color = condition)) +
  geom_half_dotplot(show.legend = FALSE) +
  geom_half_violin(show.legend = FALSE)

# Not bad. Let's mess with binwidth
hai |>
  ggplot(aes(x = condition, y = panas_post, fill = condition, color = condition)) +
  geom_half_dotplot(show.legend = FALSE, binwidth = 0.1) +
  geom_half_violin(show.legend = FALSE)

# Notice binwidth affects dot size. Control with dotsize.
hai |>
  ggplot(aes(x = condition, y = panas_post, fill = condition, color = condition)) +
  geom_half_dotplot(show.legend = FALSE, binwidth = 0.1, dotsize = 0.8) +
  geom_half_violin(show.legend = FALSE)

# Make a true raincloud plot oriented horizontally
hai |>
  ggplot(aes(x = condition, y = panas_post, fill = condition, color = condition)) +
  geom_half_dotplot(show.legend = FALSE, stackdir = "down") +
  geom_half_violin(show.legend = FALSE, side = "r") +
  coord_flip()

# Now let's add a boxplot
hai |>
  ggplot(aes(x = condition, y = panas_post, fill = condition, color = condition)) +
  geom_half_dotplot(show.legend = FALSE) +
  geom_half_violin(show.legend = FALSE) +
  geom_boxplot(show.legend = FALSE)

# Whoa, that's a mess. Let's remove fill as an aesthetic for the boxplot.
hai |>
  ggplot(aes(x = condition, y = panas_post)) +
  geom_half_dotplot(aes(fill = condition, color = condition), show.legend = FALSE) +
  geom_half_violin(aes(fill = condition, color = condition), show.legend = FALSE) +
  geom_boxplot(aes(color = condition), show.legend = FALSE)

# OK, we need to nudge the density and dotplots over and make the boxplot narrower.
hai |>
  ggplot(aes(x = condition, y = panas_post)) +
  geom_half_dotplot(aes(fill = condition, color = condition), dotsize = 0.5, show.legend = FALSE, position = position_nudge(x = 0.1)) +
  geom_half_violin(aes(fill = condition, color = condition), show.legend = FALSE, position = position_nudge(x = -0.1)) +
  geom_boxplot(aes(color = condition), show.legend = FALSE, width = 0.1)

# Not bad!

# What if we want to add density plots to our slopegraphs? We'll copy our slopegraph code from above and add a geom_half_violin.
hai_panas_pos |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line(aes(group = participant), color = "grey75") +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line", aes(group = 1)) +
  geom_half_violin()

# Dang, the density plots are both on the left. We need to add two geom_half_violins, filtering the data for prepost level, assigning different sides, and nudging slightly.
hai_panas_pos |>
  mutate(side = ifelse(prepost == "Pre", "l", "r")) |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line(aes(group = participant), color = "grey75") +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line", aes(group = 1)) +
  geom_half_violin(data = filter(hai_panas_pos, prepost == "Pre"),
                   nudge = 0.1) +
  geom_half_violin(data = filter(hai_panas_pos, prepost == "Post"),
                   nudge = 0.1, side = "r")

# Let's add different colors for the prepost levels
hai_panas_pos |>
  mutate(side = ifelse(prepost == "Pre", "l", "r")) |>
  ggplot(aes(x = prepost, y = panas)) +
  geom_line(aes(group = participant), color = "grey75") +
  stat_summary(fun.data = mean_cl_normal) +
  stat_summary(fun = mean, geom = "line", aes(group = 1)) +
  geom_half_violin(data = filter(hai_panas_pos, prepost == "Pre"),
                   nudge = 0.1, fill = "steelblue", alpha = 0.5) +
  geom_half_violin(data = filter(hai_panas_pos, prepost == "Post"),
                   nudge = 0.1, side = "r", fill = "seagreen", alpha = 0.5)



# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/35_categories.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/35_categories.html


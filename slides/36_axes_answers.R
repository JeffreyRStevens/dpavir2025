# Adjusting axes

# Limit, label, and scale axes and learn more about faceting and creating compound plots


library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(experiment, participant, condition, gender, pets_now, parent_income, panas_pre = panas_pre_pos,
         panas_post = panas_post_pos, anxiety = vas_anxiety_pre) |>
  mutate(parent_income = fct_relevel(parent_income, c("< $25000", "$25000-$50000", "$50000-$75000",  "$75000-$100000", "> $100000", "Preferred not to answer")),
         pets = fct_recode(factor(pets_now), "Has pets" = "1", "Has no pets" = "0"))

## How do we calculate a difference score between panas_post and panas_pre?
hai <- hai |>
  mutate(panas_diff = panas_post - panas_pre)

## How do we combine condition and gender into a column called cond_gend and keep the old columns?
hai <- hai|>
  unite("cond_gend", condition, gender, remove = FALSE)


# Scaling axes ------------------------------------------------------------
# Scaling axes is done with the scale_x/y_continuous() and scale_x/y_discrete() functions

## Altering axis range -----
# There are two ways to alter an axis range.
# The first sets the limits to the axis scale and sets data outside limits to NA.
# This will remove data outside the limits, which can change stats transformations.

# Discrete axis
hai |>
  ggplot(aes(x = parent_income, y = panas_diff)) +
  geom_boxplot() +
  coord_flip()

# Let's first scale the discrete x axis to limit the levels (notice still x-axis with coord_flip())
hai |>
  ggplot(aes(x = parent_income, y = panas_diff)) +
  geom_boxplot() +
  scale_x_discrete(limits = c("$25000-$50000", "$50000-$75000", "$75000-$100000")) +
  coord_flip()

# There is a short cut that focuses on x-axis limits (and we can access the levels directly)
hai |>
  ggplot(aes(x = parent_income, y = panas_diff)) +
  geom_boxplot() +
  xlim(levels(hai$parent_income)[2:4]) +
  coord_flip()

# Continuous axis
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot()

# Need switch to scale_y_continuous() function
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(-2, 2))

# Or use ylim() function
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  ylim(-2, 2)

# Or use lims() function which can control x and y in same function
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  lims(y = c(-2, 2))

## Now use ylim() and make the axis -1 to 1
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  ylim(-1, 1)

## What happened?
# Basically, working with scale_x/y and lim functions trims the data not just axes.

# The second way to scale axes alters the coordinate system and preserves data.
# This effectively 'zooms in' the axis scale.

# Here is the original plot
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot()

# Here is what happens when we set limits using scale_y_continuous() (or ylim() or lims())
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  scale_y_continuous(limits = c(-1, 1))

# Now let's set limits by working with the coordinate system
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(-1, 1))

# This works for discrete axes, too
hai |>
  ggplot(aes(x = parent_income, y = panas_diff)) +
  geom_boxplot() +
  coord_cartesian(xlim = c(2, 4))


## Altering axis scales -----
### Log scale ----
# The default axes scale is linear
hai |>
  ggplot(aes(x = condition, y = anxiety)) +
  geom_boxplot()

# But you can switch to a base 10 log scale with scale_x/y_log10()
hai |>
  ggplot(aes(x = condition, y = anxiety)) +
  geom_boxplot() +
  scale_y_log10()

# You can use other transformations (e.g., natural log, square root) by setting the trans argument in scale_x/y_continuous
hai |>
  ggplot(aes(x = condition, y = anxiety)) +
  geom_boxplot() +
  scale_y_continuous(trans = "log2")


### Percent scales -----
# You can convert proportions to percents with scales::percent
hai |>
  ggplot(aes(x = parent_income, y = pets_now)) +
  stat_summary(fun.data = mean_se) +
  scale_y_continuous(breaks = seq(0, 0.7, 0.1),
                     labels = scales::percent(seq(0, 0.7, 0.1), accuracy = 1))


### Dollar scales -----
# You can format scales as dollars with scales::dollar
# Obviously, this variable is not actually in dollars, but it illustrates the function
hai |>
  ggplot(aes(x = parent_income, y = panas_pre)) +
  stat_summary(fun.data = mean_se) +
  scale_y_continuous(labels = scales::dollar)


## Altering axis values -----
# What if we don't like the increments used on the axis?
hai |>
  ggplot(aes(x = parent_income, y = pets_now)) +
  stat_summary(fun.data = mean_se)

## We want the axis to run from 0 to 0.7 in increments of 0.1. How do we create a vector like this?
pets_increments <- seq(0, 0.7, 0.1)

# Set the breaks argument in scale_y_continuous()
hai |>
  ggplot(aes(x = parent_income, y = pets_now)) +
  stat_summary(fun.data = mean_se) +
  scale_y_continuous(breaks = pets_increments)

## Remove axis text labels by setting labels = NULL
hai |>
  ggplot(aes(x = parent_income, y = pets_now)) +
  stat_summary(fun.data = mean_se) +
  scale_y_continuous(breaks = pets_increments, labels = NULL)

# You can also change discrete labels here
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot()

hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_boxplot() +
  scale_x_discrete(labels = c("Control", "Experimental"))


# Multiple plots ----------------------------------------------------------

## Faceting -----
# Creates separate panels based on discrete data to help visualize interactions.

# Interaction plot with groups
hai |>
  ggplot(aes(x = condition, y = panas_diff, color = pets, group = pets)) +
  stat_summary(fun.data = mean_cl_normal, position = position_dodge(width = 0.1)) +
  stat_summary(fun = mean, geom = "line", position = position_dodge(width = 0.1))

# Separate out pets into a facet rather than a group
# Notice we need to wrap the faceting variable in vars()
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(vars(pets))

# facet_wrap() produces a ribbon of panels that wrap to multiple rows when necessary.
# But you can control the numbers of rows and columns with nrow and ncol.
# If you want rows instead of columns, specify nrow.
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(vars(pets), nrow = 2)

# Sometimes, you have very different scales across your panels, and you can't really see what's going on.
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(vars(parent_income))

# You can control whether the scales are fixed across all panels or free to vary separately for each panel
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(vars(parent_income), scales = "free")

# facet_grid() is most useful when you want have more than one variable that you want to create panels for.
# You can specify which variables are rows and which are columns.
# Add gender as rows with facet_grid().
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_grid(rows = vars(gender), cols = vars(pets))

# Add experiment before pets to get another factor in there
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_grid(vars(pets), rows = vars(experiment, gender))

# Add scales = "free" to allow scales to vary freely
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_grid(vars(pets), rows = vars(gender), scales = "free")

# How is this different than using scales = "free" with facet_wrap()?


## Compound plots -----
# Compound plots add separate plots into the same figure (e.g., subfigures)
# First, let's save some plots
(condition_plot <- hai |>
   ggplot(aes(x = condition, y = panas_diff)) +
   stat_summary(fun.data = mean_cl_normal) +
   stat_summary(fun = mean, geom = "line", aes(group = 1)))

(pets_plot <- hai |>
    ggplot(aes(x = pets, y = panas_diff)) +
    stat_summary(fun.data = mean_cl_normal) +
    stat_summary(fun = mean, geom = "line", aes(group = 1)))

(income_plot <- hai |>
    ggplot(aes(x = parent_income, y = panas_diff, group = cond_gend, color = cond_gend, shape = cond_gend, linetype = cond_gend)) +
    stat_summary(fun = mean) +
    stat_summary(fun = mean, geom = "line") +
    scale_color_manual(values = c("firebrick", "steelblue", "firebrick", "steelblue")) +
    scale_linetype_manual(values = c(1, 1, 2, 2)) +
    scale_shape_manual(values = c(1, 1, 17, 17)) +
    theme(legend.position = c(0.9, 0.2),
          legend.title = element_blank()))

# Use the {patchwork} package to combine these plots into one figure
library(patchwork)

# Use the + operator to add multiple plots to the same compound plot
condition_plot + pets_plot + income_plot

# Control layout with () and /
(condition_plot + pets_plot) / income_plot

# Add subfigure tags with plot_annotation()
(condition_plot + pets_plot) / income_plot +
  plot_annotation(tag_levels = 'A')

# Add tag prefixes and suffixes
(condition_plot + pets_plot) / income_plot +
  plot_annotation(tag_levels = 'a', tag_prefix = "(", tag_suffix = ")")

# Save ggplot with ggsave()
ggsave(here::here("figures/patchwork2.png"))

# Set the size with width and height
ggsave(here::here("figures/patchwork2.png"), width = 12, height = 10)

# Changing size also changes scale of font sizes/linewidths, etc. Change these with scale
ggsave(here::here("figures/patchwork2.png"), width = 12, height = 10, scale = 0.75)


# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/36_axes.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/36_axes.html


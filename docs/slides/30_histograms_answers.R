# Plotting distributions: histograms

library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(condition, parent_income, panas_pre = panas_pre_pos, panas_post = panas_post_pos)


# Focus on distributions of continuous data


# Histograms --------------------------------------------------------------

# To make histograms, we use geom_histogram(), which uses the stat_bin() statistical transformation
# Note we only need an x variable since this is a univariate distribution
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram()

# "When making a histogram, always explore multiple bin widths." (Wilke, 2019)
# Change number with bins or the size with binwidth
## Change the number of bins to 20
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram(bins = 20)

## Change the size of the bins to 0.15
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram(binwidth = 0.15)

## How do we add a border to the bars?
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram(color = "grey")

## How do we make the bars steelblue?
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram(fill = "steelblue", color = "grey")


# Frequency polygons ---------------------------------------------------------

# To get line instead of rectangles, use geom_freqpoly which also uses stat_bin()

hai |>
  ggplot(aes(x = panas_post)) +
  geom_freqpoly()

# Also controlled with bins and binwidth
hai |>
  ggplot(aes(x = panas_post)) +
  geom_freqpoly(bins = 20)

hai |>
  ggplot(aes(x = panas_post)) +
  geom_freqpoly(binwidth = 0.15)

# Add color
hai |>
  ggplot(aes(x = panas_post)) +
  geom_freqpoly(color = "steelblue")


# Density plots -----------------------------------------------------------

# Histograms and frequency polygons display counts for bins
# Density plots display the underlying probability distribution (usually by kernel density estimation)

# To make density plots, we use geom_density(), which uses the stat_density() statistical transformation
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density()

# You can adjust the *band*width (density equivalent of histogram's binwidth) with bw
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(bw = 0.1)
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(bw = 0.05)
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(bw = 0.7)

## How can we make the density function solid and steelblue1?
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(fill = "steelblue1")

## How do we fill the density function with steelblue1 and make the line darkorchid?
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(fill = "steelblue1", color = "darkorchid")

## Make the line transparent
hai |>
  ggplot(aes(x = panas_post)) +
  geom_density(fill = "steelblue1", color = "transparent")

# Overlay density plot on histogram.
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram() +
  geom_density()

# What happened?
hai |>
  ggplot(aes(x = panas_post)) +
  geom_histogram(aes(y = after_stat(density))) +
  geom_density()


# Overlapping distributions -----------------------------------------------

## Histograms -----
# Histograms are not very good for visualizing multiple distributions
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram()

# Are they stacked or covering?
# Let's check by making bars partially transparent. How do we do that?
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram(alpha = 0.5)

# Looks like they're stacked. Let's check by assigning position to 'stack' to see if there is a difference.
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram(position = "stack", alpha = 0.5)

# Let's change their position to "identity" to let them overlap
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram(position = "identity", alpha = 0.5)

# Not great. What if we put the bars next to each other by changing position to "dodge"?
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram(position = "dodge", alpha = 0.5)

# A bit better, but it's really hard to visualize multiple histograms on the same axis. How do we separate them into two subplots?
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_histogram() +
  facet_wrap(vars(condition))

# It's just really hard to visualize multiple histograms together.


## Frequency polygons -----
# Frequency polygons are easier to plot multiple distributions
# Just need to switch fill to color
hai |>
  ggplot(aes(x = panas_post, color = condition)) +
  geom_freqpoly()


## Density plots ------
# Density plots are even better but need to switch back to fill
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_density()

## How can we improve this to see both distributions?
hai |>
  ggplot(aes(x = panas_post, fill = condition)) +
  geom_density(alpha = 0.5)

## What if we want the lines to match the shaded color?
hai |>
  ggplot(aes(x = panas_post, fill = condition, color = condition)) +
  geom_density(alpha = 0.5)

# Nice!


## Ridgeline plots-----
# install.packages("ggridges")
library(ggridges)

# To separate many densities across the y axis to make a ridgeline plot, use geom_density_ridges()
hai |>
  ggplot(aes(x = panas_pre, y = parent_income)) +
  geom_density_ridges()

# Oops, parent income isn't in the correct order. How do we fix this?
income_levels <- c("< $25000", "$25000-$50000", "$50000-$75000", "$75000-$100000", "> $100000", "Preferred not to answer")
hai |>
  mutate(parent_income = fct_relevel(parent_income, income_levels)) |>
  ggplot(aes(x = panas_pre, y = parent_income)) +
  geom_density_ridges()

# Set color to income level
hai |>
  mutate(parent_income = fct_relevel(parent_income, income_levels)) |>
  ggplot(aes(x = panas_pre, y = parent_income, fill = parent_income)) +
  geom_density_ridges(show.legend = FALSE)



# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/30_histograms.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/30_histograms.html

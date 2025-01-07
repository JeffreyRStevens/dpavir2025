# Plotting amounts: barcharts and dot plots


library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(condition, age_num, gender, race, parent_income)


# Plot amount and proportion data for categories


# Bar plots ---------------------------------------------------------------

## Calculate counts ----
# Calculate counts for bar plots with geom_bar()
hai |>
  ggplot(aes(x = parent_income)) +
  geom_bar()

# Need to reorder the levels. What function do we use?
hai <- hai |>
  mutate(parent_income = fct_relevel(parent_income, c("< $25000", "$25000-$50000", "$50000-$75000",  "$75000-$100000", "> $100000", "Preferred not to answer")))

hai |>
  ggplot(aes(x = parent_income)) +
  geom_bar()

# Now make the bars mapped to parent_income, color the borders black, and remove the legend
hai |>
  ggplot(aes(x = parent_income, fill = parent_income)) +
  geom_bar(color = "black", show.legend = FALSE)

# Convert counts to proportions by generating counts per group with after_stat(count) and then dividing by total count calculated by summing over all counts
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count)/sum(after_stat(count)))) +
  geom_bar()


## Plot values -----

# Plot values directly

# How do we create a new object that calculates the counts for each level of income?
hai_income_count <- hai |>
  count(parent_income)

# Plot values directly with stat = "identity" (in contrast to using the default stat = "count" to apply the count() function internally)
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_bar(stat = "identity")

# Or use geom_col(), which is just a wrapper for geom_bar(stat = "identity")
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_col()

# How would we convert the count data to a proportion?
hai_income_count <- hai_income_count |>
  mutate(prop = n / sum(n))

# Now let's plot the proportion
hai_income_count |>
  ggplot(aes(x = parent_income, y = prop)) +
  geom_col()

# Note this is just for amounts and proportions---that is, when there is a single data point per group.
# There is a strong consensus among statisticians that bar plot should not be used for means because they hide distributional information.
# http://users.stat.umn.edu/~rend0020/Teaching/STAT8801-2015Spring/handouts/24-dynamite.pdf
# So I will not show you how to make a dynamite plot.
# Instead, plot the raw data or a distribution plot (boxplot, violin plot, etc.).
# I would then overlay means and error over the raw/distribution plot.


# Grouping and positioning data --------------------------------------------------------

# If we want to include another variable in our bar plots, we can add them as a group/color/fill
hai |>
  ggplot(aes(x = parent_income, fill = condition)) +
  geom_bar() # equivalent to geom_bar(position = "stack")

# This stacks the bars by default. This is an example of a position adjustment specified by the `position` argument.
## You can switch from absolute counts to relative proportions by assigning `position = "fill"`. Try it.
hai |>
  ggplot(aes(x = parent_income, fill = condition)) +
  geom_bar(position = "fill")

# This can be a replacement for multiple pie charts in some circumstances
mpg |>
  ggplot(aes(x = as.factor(cyl), fill = class)) +
  geom_bar(position = "fill")


# Another important positioning adjustment is dodging, or placing groups next to one another.
## Set position to `dodge`
hai |>
  ggplot(aes(x = parent_income, fill = condition)) +
  geom_bar(position = "dodge")

# Another way that doesn't use position is to build a population pyramid
hai |>
  count(parent_income, condition) |>
  ggplot(aes(x = parent_income, y = ifelse(condition == "hai", n, -n), fill = condition)) +
  geom_col()

# Flip the x and y axis variables
hai |>
  count(parent_income, condition) |>
  ggplot(aes(y = parent_income, x = ifelse(condition == "hai", n, -n), fill = condition)) +
  geom_col()


# Cleveland dot plots ---------------------------------------------------------------

# What is the principle of proportional ink?


# Dots are often easier to interpret, especially if they are not grounded at 0
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_point()

# Often dot plots are oriented with the dependent variable on the x axis. How do we do this?
hai_income_count |>
  ggplot(aes(y = parent_income, x = n)) +
  geom_point()

# Another way is to flip the coordinates with coord_flip()
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_point() +
  coord_flip()

# What might be advantages of coord_flip()?

# Now let's try the racial categories
hai |>
  group_by(race) |>
  count() |>
  ggplot(aes(x = race, y = n)) +
  geom_point() +
  coord_flip()

# Though income levels have a natural order, racial categories do not. So let's order the levels based on the counts.
## How do we order levels based on another variable?
hai |>
  count(race) |>
  ggplot(aes(x = fct_reorder(race, n), y = n)) +
  geom_point() +
  coord_flip()

## Adding lines -----
# Sometimes, people like to include a line that starts at 0. For this we use geom_linerange()
hai |>
  count(race) |>
  ggplot(aes(x = fct_reorder(race, n), y = n)) +
  geom_point() +
  geom_linerange(aes(ymin = 0, ymax = n)) +
  coord_flip()


## Multiple dots -----

# If we want multiple dots per category based on another variable, we just need to create the tidy data (one row per observation) and map an aesthetic to the variable.
## So to include counts of gender for each racial category, we need to add gender to our count() function and map color to gender.
hai |>
  count(race, gender) |>
  ggplot(aes(x = fct_reorder(race, n), y = n, color = gender)) +
  geom_point() +
  coord_flip()

# Hmmm, we only get two dots for White and Asian. Check out the counts to see what's going on
hai |>
  count(race, gender)

# Well, Other has six males and females, so that is overplotting, which we'll cover later in the course. However, for Black and Native American, only a single gender is present in the data.
## How do we recover implicitly missing data?
hai |>
  count(race, gender) |>
  complete(race, gender)

# Now we have two genders for each racial category. Note that there was a nonbinary option in the survey, but no participants selected this, so will focus on just female and male for this plot.
## But what else is wrong? We don't want to plot NAs. We want the NAs to be 0s. How do we convert NAs to 0s?
hai |>
  count(race, gender) |>
  complete(race, gender) |>
  mutate(n = as.numeric(str_replace_na(n, "0")))

# We now have added 0s for the missing genders, so now we can plot them.
hai |>
  count(race, gender) |>
  complete(race, gender) |>
  mutate(n = as.numeric(str_replace_na(n, "0"))) |>
  ggplot(aes(x = fct_reorder(race, n), y = n, color = gender)) +
  geom_point() +
  geom_line() +
  coord_flip()

# If we want to highlight the connection between the points, we can add a geom_line grouped by race
hai |>
  count(race, gender) |>
  complete(race, gender) |>
  mutate(n = as.numeric(str_replace_na(n, "0"))) |>
  ggplot(aes(x = fct_reorder(race, n), y = n, color = gender)) +
  geom_line(aes(group = race), color = "black") +
  geom_point() +
  coord_flip()


# Coordinate systems --------------------------------------------------------------
# Cartesian coordinate systems have two axes (x and y) that are straight.
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_col()

# Polar coordinate systems have one straight and one circular axis.
hai_income_count |>
  ggplot(aes(x = parent_income, y = n)) +
  geom_col() +
  coord_polar()

# These are useful for radar charts/spider charts: https://en.wikipedia.org/wiki/Radar_chart.
## Polar coordinates also allow you to make pie charts, but I'm not going to show you how to do that. :) Instead, I'll show you how to make treemaps, which make it easier to compare across category levels. Check them out below under Extras.



# Extras -------------------------------------------------------------------

## Bin continuous data to categories -----
# How do we visualize continuous data counts?
hai |>
  ggplot(aes(x = age_num)) +
  geom_histogram(bins = 10)

# What if we want to control the bins of these continuous data?
## Categorize continuous variables with cut()
hai <- hai |>
  mutate(age_categories = cut(age_num, breaks = c(0, 18, 21, 100),
                              labels = c("<19", "19-21", ">21"))) |>
  relocate(age_categories, .after = age_num)

hai |>
  ggplot(aes(x = age_categories)) +
  geom_bar()

## Treemaps -----
# It's not easy to make treemaps with default ggplot options. Fortunately, the {treemapify} package makes it pretty easy. First, install the package
# install.packages("treemapify")
library(treemapify)

hai_income_count |>
  ggplot(aes(area = n, fill = parent_income, label = parent_income)) +
  geom_treemap() +
  geom_treemap_text(grow = TRUE, place = "center")



# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/32_barcharts.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/32_barcharts.html


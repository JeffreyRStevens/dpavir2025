# Plotting distributions: boxplots and violin plots


library(palmerpenguins)
library(tidyverse)

penguins <- penguins


# Plot multiple distributions


# Boxplots ----------------------------------------------------------------
# Boxplots require the geom_boxplot() function, which uses the stat_boxplot() statistical transformation

# Let's create boxplots of penguin body mass for each species
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot()

# To change outlier symbol and size, set outlier.shape and outlier.size
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(outlier.shape = 3, outlier.size = 3)  # outlier shape options 1-25

# To hide outliers, set outlier.shape to NA
# Range calculated for the y-axis will be the same with outliers shown and outliers hidden
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(outlier.shape = NA)

# To use full range instead of 1.5 x IQR, set coef to large number
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(coef = 5)

# OK, let's look at the data.
## I want to change the order of the boxplots so Gentoo will be displayed first, followed by Chinstrap and Adelie. How do we reorder factor levels?
penguins_reordered <- penguins %>%
  mutate(species = fct_relevel(species, c("Gentoo", "Chinstrap", "Adelie")))

penguins_reordered %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot()

## What if wanted to reorder by mean body mass?
penguins %>%
  ggplot(aes(x = reorder(species, body_mass_g, na.rm = TRUE), y = body_mass_g)) +  # reorder boxplot according to mean of y variable in ascending order
  geom_boxplot()

## How do we have ggplot calculate means and standard error?
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  stat_summary()

## Let's combine these
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot() +
  stat_summary()

## Let's make the means stand out more by making the boxplot lines grey
penguins %>%
  ggplot(aes(x = species, y = body_mass_g)) +
  geom_boxplot(color = "grey60") +
  stat_summary()

## Add color to boxplots
penguins %>%
  ggplot(aes(x = species, y = body_mass_g, color = species)) +
  geom_boxplot()

## Fill boxplot with color instead of just a colored outline
penguins %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot() +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e", "#6ed34b"))

# Let's get rid of the legend. How do we do that?
penguins %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e", "#6ed34b"))

# Change the color of the background
penguins %>%
  ggplot(aes(x = species, y = body_mass_g, fill = species)) +
  geom_boxplot(show.legend = FALSE) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e", "#6ed34b")) +
  theme_classic()

# I want to see how male & female penguins differ in body mass by species too
penguins %>%
  ggplot(aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~ species) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e")) +
  theme_classic()

## Oops, let's remove the NA column by excluding penguins that don't have sex recorded. How do we do this?
penguins_identified <- penguins %>%
  drop_na(sex)

## Ok, let's try facet wrapping by sex again
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot(show.legend = FALSE) +
  facet_wrap(~ species) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e")) +
  theme_classic()

## Let's increase the axis label and title font size
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot() +
  facet_wrap(~ species) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e")) +
  theme_classic()+
  theme(axis.title.y = element_text(face = "bold", size = 18, margin = margin(t = 0, r = 10, b = 0, l = 0)),  # change y-axis title style, size & margin
        axis.title.x = element_text(face = "bold", size = 18, margin = margin(t = 10, r = 0, b = 0, l = 0)),  # change x-axis title style, size & margin
        axis.text = element_text(face = "bold", size = 15),  # change x & y axes tick mark font & size
        strip.text.x = element_text(size = 15),  # change facet label size
        legend.position = "none")

## Add mean & 95% CIs
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g, fill = sex)) +
  geom_boxplot() +
  stat_summary(fun.data = mean_cl_normal) +  # add sample mean & 95% confidence intervals assuming normality
  facet_wrap(~ species) +
  scale_fill_manual(values=c("#4b6ed3", "#d34b6e")) +
  theme_classic()+
  theme(axis.title.y = element_text(face = "bold", size = 18, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x = element_text(face = "bold", size = 18, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        strip.text.x = element_text(size = 15),
        legend.position = "none")


# Violin plots ------------------------------------------------------------
# Violin plots require the geom_violin() function, which uses the stat_density() statistical transformation

# Let's create violin plots of the last boxplots + stat_summary
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(~ species)

# Make the density area "steelblue1" and lines "steelblue"
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g)) +
  geom_violin(fill = "steelblue1", color = "steelblue") +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(~ species)

# Make the density area and line colors map to sex with 50% transparency but make the mean and CIs black and remove legend
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g)) +
  geom_violin(aes(fill = sex, color = sex), alpha = 0.5) +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(~ species) +
  theme(legend.position = "none")

# Draw the quartiles
penguins_identified %>%
  ggplot(aes(x = sex, y = body_mass_g)) +
  geom_violin(draw_quantiles = c(0.25, 0.5, 0.75), fill = "steelblue1", color = "steelblue") +
  stat_summary(fun.data = mean_cl_normal) +
  facet_wrap(~ species)


# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/31_boxplots.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/31_boxplots.html

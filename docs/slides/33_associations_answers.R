# Plotting x-y data: associations

# Plot paired continuous variables (correlations, etc.)


library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(experiment, participant, condition, panas_pre = panas_pre_pos,
         panas_post = panas_post_pos, panas_neg = panas_pre_neg,
         bds_pre = bds_index_pre, bds_post = bds_index_post, ncpc_pre = ncpc_pre_diff,
         drm = drm_d_prime)


# Scatter plots -----
hai |>
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point()

## How do we add a linear regression line?
hai |>
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point() +
  geom_smooth(method = "lm")

# To add a diagonal reference line at x=y, use the geom_abline() with slope = 1
hai |>
  ggplot(aes(x = panas_pre, y = panas_post, color = condition)) +
  geom_abline(intercept = 0, slope = 1) +
  geom_point()


# Bubble charts -----
# In bubble charts, the size of the point gives information
# Two kinds of bubble charts
# One maps the size to a third continuous variable

## How would we map panas_neg to point size?
hai |>
  ggplot(aes(x = panas_pre, y = panas_post, size = panas_neg)) +
  geom_point()

# The second counts the number of observations for each x-y point using geom_count()
# Here's the original plot with potential overlapping points
hai |>
  ggplot(aes(x = bds_pre, y = bds_post)) +
  geom_point()

# Use geom_count() to scale dot size to number of observations
hai |>
  ggplot(aes(x = bds_pre, y = bds_post)) +
  geom_count()


# Correlation plots -----
# Correlation plots produce a matrix of scatterplots of all combinations of numerical variables
hai_numeric <- hai |>
  select(panas_pre:drm)

# Use base R's pairs() function to plot all pairwise combinations
pairs(hai_numeric)

# Create function to plot histograms
panel.hist <- function(x, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2], 0, 1.5) )
  h <- hist(x, plot = FALSE)
  breaks <- h$breaks; nB <- length(breaks)
  y <- h$counts; y <- y/max(y)
  rect(breaks[-nB], 0, breaks[-1], y, col = "cyan", ...)
}
# Create function to calculate and print correlation coefficients
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor, ...) {
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- abs(cor(x, y, use = "pairwise.complete.obs"))
  txt <- format(c(r, 0.123456789), digits = digits)[1]
  txt <- paste0(prefix, txt)
  if(missing(cex.cor)) cex.cor <- 0.8/strwidth(txt)
  text(0.5, 0.5, txt, cex = cex.cor * r)
}
# Add correlations to upper panel and histograms to diagonal
pairs(hai_numeric, upper.panel = panel.cor, diag.panel = panel.hist)

# To plot these in a ggplot environment, use ggpairs from the {GGally} package
# install.packages("GGally")
library(GGally)
ggpairs(hai, columns = 4:10)

# You can also include categorical variables to get separate histograms and boxplots
ggpairs(hai, columns = 3:10)

# Or you can add a grouping variable to aesthetics
ggpairs(hai, columns = 4:10, aes(color = condition))


# Heatmaps -----
# Heatmaps illustrate the overall correlations rather than plot the actual raw data
# We will build one from scratch to plot in ggplot
# First, calculate correlation matrix
(my_corr <- cor(hai_numeric, use = "pairwise.complete.obs"))
# Next, remove the lower part of the matrix
my_corr_lower <- my_corr
my_corr_lower[lower.tri(my_corr_lower)] <- NA
# Then, create long version of matrix to plot
my_corr_long <- data.frame(my_corr_lower) %>%
  rownames_to_column(var = "var1") %>%
  pivot_longer(-var1, names_to = "var2", values_to = "correlation", values_drop_na = TRUE) %>%
  mutate(var1 = factor(var1, levels = c("panas_pre", "panas_post", "panas_neg", "bds_pre", "bds_post", "ncpc_pre", "drm")),
         var2 = factor(var2, levels = c("panas_pre", "panas_post", "panas_neg", "bds_pre", "bds_post", "ncpc_pre", "drm")))

# Finally, plot a geom_tile() and fill the tiles based on the correlation
my_corr_long %>%
  ggplot(aes(x = var1, y = fct_rev(var2), fill = correlation)) +
  geom_tile() +
  geom_text(aes(label = round(correlation, 2)), color = "white")

# But we really need a diverging color scale. How do we add that?
my_corr_long %>%
  ggplot(aes(x = var1, y = fct_rev(var2), fill = correlation)) +
  geom_tile() +
  geom_text(aes(label = round(correlation, 2))) +
  scale_fill_distiller(palette = 'RdBu')

# Well, that doesn't set the center of the scale to 0. Let do that.
my_corr_long %>%
  ggplot(aes(x = var1, y = fct_rev(var2), fill = correlation)) +
  geom_tile() +
  geom_text(aes(label = round(correlation, 2))) +
  scale_fill_gradientn(
    colours = c("red", "white", "blue"),
    values = c(-1, 0, 1)
  )

# Still not quite scaled appropriately. Here's another solution
library(colorspace)
my_corr_long %>%
  ggplot(aes(x = var1, y = fct_rev(var2), fill = correlation)) +
  geom_tile() +
  geom_text(aes(label = round(correlation, 2))) +
  scale_fill_continuous_divergingx(palette = 'RdBu', mid = 0)


# Alternatively, use the ggcorrplot() function from {ggcorrplot}
# install.package("ggcorrplot")
library(ggcorrplot)
ggcorrplot(my_corr, type = "upper")

## Add correlation values with lab = TRUE
ggcorrplot(my_corr, type = "upper", lab = TRUE)

# Convert squares to circles and scale size to correlation value
ggcorrplot(my_corr, type = "upper", method = "circle")


# Add rugs -----
hai |>
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point()

hai |>
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point() +
  geom_rug()

# Add marginal histograms -----
# install.packages("ggExtra")
library(ggExtra)
# Create scatterplot
hai_plot <- hai |>
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point()
# Add histogram and density plot
ggMarginal(hai_plot, type = "densigram")

# It can also group on a variable, so we'll turn off the histogram
hai_plot2 <- hai |>
  ggplot(aes(x = panas_pre, y = panas_post, color = condition)) +
  geom_point() +
  theme(legend.position = c(0.15, 0.85))
ggMarginal(hai_plot2, type = "density", groupFill = TRUE)


# Plot error bars in scatter plots -------
library(palmerpenguins)
penguins |>
  ggplot(aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point()

# Prepare data by calculating means and error
penguins_species <- penguins |>
  group_by(species) |>
  summarise(length_mean = mean(bill_length_mm, na.rm = TRUE),
            length_sd = sd(bill_length_mm, na.rm = TRUE),
            depth_mean = mean(bill_depth_mm, na.rm = TRUE),
            depth_sd = sd(bill_depth_mm, na.rm = TRUE)
  )

penguins_species |>
  ggplot(aes(x = length_mean, y = depth_mean, color = species)) +
  geom_point(show.legend = FALSE) +
  geom_errorbarh(aes(xmin = length_mean - length_sd, xmax = length_mean + length_sd), show.legend = FALSE) +
  geom_errorbar(aes(ymin = depth_mean - depth_sd, ymax = depth_mean + depth_sd), show.legend = FALSE) +
  geom_text(aes(label = species), hjust = -0.25, vjust = -0.75, show.legend = FALSE)


# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/33_associations.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/33_associations.html


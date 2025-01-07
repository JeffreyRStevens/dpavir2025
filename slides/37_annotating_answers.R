# Annotating plots

# Edit labels and titles and add text, lines, and shapes to plot area


library(tidyverse)
hai <- read_csv("https://decisionslab.unl.edu/data/thayer_stevens_2020_data1.csv") |>
  select(experiment, participant, condition, gender, parent_income, panas_pre = panas_pre_pos,
         panas_post = panas_post_pos, panas_diff = panas_pos_diff) |>
  mutate(parent_income = fct_relevel(parent_income, c("< $25000", "$25000-$50000", "$50000-$75000",  "$75000-$100000", "> $100000", "Preferred not to answer")))


# Labels and titles -------------------------------------------------------

## Labels -----
# Labels for x and y axes can be defined with labs(), xlab(), and ylab()

## Make a violin plot with mean and 95% confidence interval of panas_diff as a function of condition
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal)

## Change y-axis label with ylab("PANAS difference score")
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  ylab("PANAS difference score")

# Or change both axes with labs()
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score")


## Titles, subtitles, and captions -----

# Add titles, subtitles, and captions with title, subtitle, and caption arguments in labs()
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(title = "Positive PANAS", subtitle = "Difference score",
       caption = "Source: Thayer & Stevens (2021)",
       x = "Condition", y = "PANAS differences score")


## Tags -----
# If you want to create your own subfigure label/tag, set tag argument
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score",
       tag = "(a)")


# Adding text -------------------------------------------------------------

## General text -----
# Use the annotate() function

# Add a subfigure label/tag inside the plot using annotate() functions with geom = "text"
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "text", label = "(a)", x = 0.485, y = 1.4, size = 6)

# Add stats to the plot
# Let's run a t-test for the condition effects on panas_diff
(panas_ttest <- t.test(panas_diff ~ condition, data = hai))
# View components of analysis
str(panas_ttest)
panas_ttest$statistic
panas_ttest$parameter
panas_ttest$p.value

# Create character string of statistics
## How do we combine text with objects?
(ttest_text <- paste0("t(", round(panas_ttest$parameter, 1), ") = ", round(panas_ttest$statistic, 2),
                      ", p ", ifelse(panas_ttest$p.value >= 0.001, paste0("= ", round(panas_ttest$p.value, 3)), "< 0.001")))

# Add text annotation specifying the x and y coordinates for the middle and center of the annotation
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "text", label = ttest_text, x = 1.5, y = 1.125, size = 5)

# To format characters (e.g., italicize), you can use the {ggtext} package and markdown syntax
(ttest_text <- paste0("_t_(", round(panas_ttest$parameter, 1), ") = ", round(panas_ttest$statistic, 2),
                      ", _p_ ", ifelse(panas_ttest$p.value >= 0.001, paste0("= ", round(panas_ttest$p.value, 3)), "< 0.001")))

# install.packages(ggtext)
library(ggtext)
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "richtext", label = ttest_text, fill = NA, label.color = NA, x = 1.5, y = 1.125, size = 5)

## Can also split across two lines. Anyone remember how to code a new line into a character string?
(ttest_text <- paste0("t(", round(panas_ttest$parameter, 1), ") = ", round(panas_ttest$statistic, 2),
                      ", \np ", ifelse(panas_ttest$p.value >= 0.001, paste0("= ", round(panas_ttest$p.value, 3)), "< 0.001")))

# Let's add Ns to bottom of violin plot
## How do we calculate Ns for each condition?
(cond_nums <- hai |>
  count(condition))

# This time, we'll use paste inside the ggplot annotate
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "text", label = ttest_text, x = 1.5, y = 1.125, size = 5) +
  annotate(geom = "text", label = paste0("N=", cond_nums$n[1]), x = 1, y = -1.5) +
  annotate(geom = "text", label = paste0("N=", cond_nums$n[2]), x = 2, y = -1.5)


## Labeling categorical data -----

# Let's plot our bar plot with proportions
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue")

# Use geom_text() with stat = "count" to add counts
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue") +
  labs(x = "Parental income", y = "Proportion of participants") +
  geom_text(stat = "count", aes(label = after_stat(count)))

# Change location with vjust
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue") +
  labs(x = "Parental income", y = "Proportion of participants") +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.25, size = 5)

## Set vjust to 2 and color to white
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue") +
  labs(x = "Parental income", y = "Proportion of participants") +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = 2, size = 5, color = "white")

# To place text in fixed location, set y
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue") +
  labs(x = "Parental income", y = "Proportion of participants") +
  geom_text(stat = "count", aes(label = after_stat(count)), y = 0.02, size = 5, color = "white")

## Paste text into label (N=)
hai |>
  ggplot(aes(x = parent_income, y = after_stat(count / sum(count)))) +
  geom_bar(fill = "steelblue") +
  labs(x = "Parental income", y = "Proportion of participants") +
  geom_text(stat = "count", aes(label = paste0("N=", after_stat(count))), y = 0.02, size = 5, color = "white")

# Now let's repeat the violin plot with the sample size added at the bottom but without calculating the count first
hai |>
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "text", label = ttest_text, x = 1.5, y = 1.125, size = 5) +
  geom_text(stat = "count", aes(label = paste0("N=", after_stat(count))), y = -1.5)

# How is this different from using annotate()? How can you replicate the annotate() version?


## Labeling scatterplot data -----

# Let's make a small scatterplot for individual cars
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point()

# Now let's label the points with the rownames
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_text(aes(label = rownames(mtcars)))

# Ugh, the labels are right on top of the points. Let's change the justification
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_text(aes(label = rownames(mtcars)), hjust = "left")

# Need to nudge them to the right a bit.
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_text(aes(label = rownames(mtcars)), nudge_x = 0.1, hjust = "left")

# Let's try geom_label() to make the text easier to read
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_label(aes(label = rownames(mtcars)), nudge_x = 0.1, hjust = "left")

# Still not great. The {ggrepel} package helps spread out the text better.
# install.packages("ggrepel")
library(ggrepel)
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_text_repel(aes(label = rownames(mtcars)))

# And with labels
mtcars |>
  ggplot(aes(x = wt, y = mpg)) +
  geom_point() +
  geom_label_repel(aes(label = rownames(mtcars)))


# Reference lines and shapes ---------------------------------------------------------

## Diagonal lines -----

## What function creates diagonal lines?
hai %>%
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1)

# Color points based on location by coding it in the data
# To color points above the diagonal line differently than those on or below...
hai %>%
  mutate(change = case_when(
    panas_post > panas_pre ~ "above",
    panas_post < panas_pre ~ "below",
    TRUE ~ "on")) %>%
  ggplot(aes(x = panas_pre, y = panas_post, color = change)) +
  geom_point(show.legend = FALSE) +
  geom_abline(intercept = 0, slope = 1, color = "grey")


## Vertical and horizontal lines -----

# Let's draw a vertical line at the median panas_pre
## How do we calculate the median panas_pre
median_pre <- median(hai$panas_pre)

# Use geom_vline() to draw vertical line
hai %>%
  ggplot(aes(x = panas_pre, y = panas_post)) +
  geom_point() +
  geom_vline(xintercept = median_pre, color = "blue") +
  annotate(geom = "text", label = "Median", x = median_pre + 0.18, y = 4.75, color = "blue")

## Use geom_hline() to draw horizontal line
hai %>%
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  geom_hline(yintercept = 0, linetype = 2, color = "grey") +
  stat_summary(fun.data = mean_cl_normal) +
  labs(x = "Condition", y = "PANAS differences score")


## Segments -----
# Draw line segments with "segment" geom in annotate()
hai %>%
  ggplot(aes(x = condition, y = panas_diff)) +
  geom_violin() +
  geom_hline(yintercept = 0, linetype = 2, color = "grey") +
  labs(x = "Condition", y = "PANAS differences score") +
  annotate(geom = "segment", x = 2, xend = 2.25, y = 0.26, yend = 0.75, color = "grey60") +
  annotate(geom = "text", label = "Mean±95% CI", x = 2.35, y = 0.82) +
  stat_summary(fun.data = mean_cl_normal)


## Shapes -----

# Draw rectangles with annotate(geom = "rect")
hai %>%
  ggplot(aes(x = panas_pre, y = panas_post)) +
  annotate(geom = "rect", xmin = 2.5, xmax = 3.5, ymin = 3, ymax = 4, fill = "blue", alpha = 0.25) +
  geom_point()

# You can have R calculate and plot an ellipse to encircle data with stat_ellipse()
hai %>%
  ggplot(aes(x = panas_pre, y = panas_post, color = condition)) +
  geom_point() +
  stat_ellipse()

# You can draw circles separately from the data with the geom_circle() function in the {ggforce} package


# Let's code! ------------------------------------------------------------
# https://jeffreyrstevens.github.io/dpavir2023/code/37_annotating.Rmd
# https://jeffreyrstevens.github.io/dpavir2023/code/37_annotating.html


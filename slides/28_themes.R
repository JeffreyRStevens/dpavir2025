library(tidyverse)

# Defined themes ----------------------------------------------------------
# Here's the standard/default theme
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point()

# You can change the overall theme type, e.g., theme_classic()
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme_classic()

# theme_bw()
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme_bw()

# theme_minimal()
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme_minimal()

# The {ggthemes} package has a lot more kinds of themes (e.g., 538, The Economist, Wall Street Journal)

# In addition to overall themes, you can alter individual elements of theme components.
# They are specified by the component (e.g., panel background, legend position) and the elements within the component (e.g., lines, rectangles, text)

# Plotting area ------------------------------------------------------------------
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point()

# Change the plot background by assigning the fill for the rectangle element of the panel background component.
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white")
  )

# You also need to change the color of the border
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black")
  )

# Or change the color of the axis lines
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        axis.line.x.bottom = element_line(color = "black"),
        axis.line.y.left = element_line(color = "black")
  )


# Grid lines --------------------------------------------------------------
# By default there are white grid lines
# You can add them or change their color with panel.grid
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        panel.grid = element_line(color = "grey")
  )

# There are major grid lines (at tick marks) and minor grid lines (between tick marks) that can be customized separately.
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        panel.grid = element_line(color = "grey"),
        panel.grid.minor = element_line(linetype = 2)
  )

# You can remove a component with element_blank()
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        panel.grid.major = element_line(color = "grey"),
        panel.grid.minor = element_blank()
  )


# Legends ------------------------------------------------------------------
# Instead of adding show.legend=FALSE to all of your geoms, you can remove a legend with legend.position = "none"
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = "none"
  )

# You can also move the legend to the top or bottom of the plot
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = "top"
  )

# You can place the legend inside the plot by specifying coordinates (from 0-1)
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.8)
  )

# Drop the legend title with element_blank()
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.8),
        legend.title = element_blank()
  )


# Aspect ratios ------------------------------------------------------------------
# Set the plot aspect ratio, which can be useful for compound plots
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.85),
        aspect.ratio = 1
  )


# Font types and sizes ------------------------------------------------------------------
# Set properties of fonts for all text components using the text argument.
# This can change the font family for everything and set the overall font size (preserving relative font size differences).
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.8),
        text = element_text(size = 18, family = "Times")
  )

# You can also alter individual text components
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.8),
        axis.title = element_text(face = "bold"),
        axis.text = element_text(face = "italic"),
        legend.text = element_text(family = "Palatino")
  )


# Strips ------------------------------------------------------------------

# Strips are the facet labels.
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  facet_wrap(~model)

# Strips are the facet labels. You can customize aspects of the strip background.
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  facet_wrap(~model) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.05),
        strip.background = element_rect(fill = "white")
  )

# And the strip font
mpg %>%
  ggplot(aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  facet_wrap(~model) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill = NA, color = "black"),
        legend.position = c(0.8, 0.05),
        strip.background = element_rect(fill = "ivory", color = "black"),
        strip.text = element_text(size = 5)
  )


## Use APA theme -----------------------------------------------------------
# install.packages("papaja")
library(papaja)
mpg %>%
  ggplot(aes(x = drv, y = hwy)) +
  geom_boxplot() +
  theme_apa()


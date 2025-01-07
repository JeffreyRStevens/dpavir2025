
run_exercise <- function(name) {
  rmarkdown::run(here::here(paste0("exercises/", name, "/", name, ".Rmd")))
}

publish_exercise <- function(name) {
  file <- paste0("exercises/", name, "/", name, ".Rmd")
  title <- paste0("dpavir2023_", name)
  quarto::quarto_publish_app(here::here(file), title = title, server = "shinyapps.io")
}

render_all_exercises <- function() {
  exercise_files <- paste0("exercises/", list.files(here("exercises/"), pattern = ".Rmd", recursive = TRUE))
  purrr::map(exercise_files, ~ rmarkdown::run(.x, shiny_args = list(launch.browser = FALSE)))
}

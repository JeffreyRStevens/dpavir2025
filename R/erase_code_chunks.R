library(readr)
library(stringr)
library(here)

# Replace code chunk contents with blank line
empty_chunk <- function(x, fill) {
  x <- gsub("\\{r .+?\\}", "\\{r\\}", x)
  x <- gsub("```\\{r\\}.+?```", paste0("```\\{r\\}\n", fill, "\n```"), x)
}

# Create new Rmd file with empty code chunks
erase_answers <- function(filename, fill = "# >") {
  outputfile <- sub("_answers", "", filename)
  file <- read_file(here(filename))

  empty_chunk(file, fill = fill) |>
    write_file(here(outputfile))
  invisible()
}


# Get all answer files
code_answers <- paste0("code/", list.files(here("code/"), pattern = ".Rmd"))
code_answers <- code_answers[-which(code_answers == "code/23_dates_answers.Rmd")]

# Apply erase_answers() to all answer files
purrr::map(code_answers, erase_answers)


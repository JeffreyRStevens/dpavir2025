
# Load packages
library(tidyverse)
library(here)
library(labelled)
library(dataReporter)

# Import data
dog_data <- read_csv(here("data/dog_breed_traits.csv"))

# Create vector with description entries in order of data columns
column_labels <- c("AKC dog breed", "Rating of how affectionate dog is to family",
                   "Rating of how good breed is with family", "Rating of how good breed is with other breeds",
                   "Rating of how much fur the breed sheds", "Rating of how frequently the breed must be groomed",
                   "Rating of how much the breed drools", "Type of fur coat", "Categorical length of fur coat",
                   "Rating of how open to strangers breed is", "Rating of how playful breed is",
                   "Rating of how protective/watchful breed is", "Rating of how adaptable breed is",
                   "Rating of how trainable breed is", "Rating of how much energy a breed has",
                   "Rating of how often the breed barks", "Rating of how much mental stimulation a breed needs")


for (i in 1:ncol(dog_data)) {
  attr(dog_data, "Description") <- column_labels
}

# Create codebook from labelled data frame
dataReporter::makeCodebook(dog_data, file = here("data/dog_codebook.pdf"),
                           replace = TRUE)


# Set the descriptions to be column labels (note, not column names but labels)
dog_data_labelled <- dog_data |>
  labelled::set_variable_labels(.labels = column_labels)
# After your ran the above line, view dog_data_labelled in Viewer

# Create codebook from labelled data frame
dataReporter::makeCodebook(dog_data_labelled, file = here("data/dog_codebook.pdf"),
                           replace = TRUE)

# You can also create a CSV of your data dictionary
labelled::generate_dictionary(dog_data_labelled) |>
  write_csv(here("data/dog_data_dictionary.csv"))

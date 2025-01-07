Accessing your data
- Log into Spotify at spotify.com
- In the top right, click on your profile and select Account.
- Scroll down to Security and privacy and select Account privacy.
- Scroll down to Download your data and check ?? under Account data. Click Request data. You may have to verify the request through an email that they send you. Depending on your listening history, it may take several days to receive the data.


Preparing your data
- Save the downloaded zip file in a folder for this assignment. 
- Unzip the data file by double clicking it.
- Open the `MyData/` folder and look for files starting with `StreamingHistory`. A new file is created for every 10,000 song played, so you may have multiple files.
- In RStudio, install the `{rjson}` package.
- Run the following code:
```
# Assign directory path from project directory
dir <- "MyData"
# List relevant JSON files
files <- list.files(dir, pattern = "StreamingHistory*.json")
# Construct the relative paths to the JSON files
filepaths <- file.path(dir, files)
# Import JSON files and combine into a data frame
all_data <- map(filepaths, rjson::fromJSON) |>
  list_cbind()
```
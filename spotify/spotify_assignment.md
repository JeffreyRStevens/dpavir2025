
We're going to make our own Spotify Wrapped! 

## Download Spotify data

### If you listen to Spotify

- Go to <https://spotify.com> and log in to your account. 
- In the top right, click on your profile and select _Account._
- Scroll down to Security and privacy and select _Account privacy_.
- Scroll down to Download your data and check _Select account data_ under _Account data_. Click _Request data_. You may have to verify the request through an email that they send you. Depending on your listening history, it may take several days to receive the data.
- Once you have access to the zip file, download it into a folder for this assignment. 
- Unzip the data file by double clicking it.
- Look for the file(s) starting with `StreamingHistory` (they may be in a `MyData/` folder). A new file is created for every 10,000 song played, so you may have multiple files. These are the JSON files that contain the data.

### If you don't listen to Spotify

- Download the example Spotify data from <https://jeffreyrstevens.github.io/dpavir2025/spotify/StreamingHistory_music.zip>.
- Unzip the file, so that you have three files: `StreamingHistory_music_0.json`, `StreamingHistory_music_1.json`, and `StreamingHistory_music_2.json`.

## Import the data

In the folder for this assignment, create a `data/` folder. Copy all streaming history JSON files into the `data/` folder.

We haven't talked about how to import JSON data in the course, because it's beyond our scope. Here's how to import this data file type.

- Install the `{rjson}` package.
- If you have a single file, import with:
```{r eval = FALSE}
spotify <- rjson::fromJSON("data/<filename>")
```

- if you have multiple files, import with:
```{r eval = FALSE}
dir <- "data"
files <- list.files(dir, pattern = "StreamingHistory*.json")
filepaths <- file.path(dir, files)
spotify <- map(filepaths, rjson::fromJSON) |>
  list_cbind()
```

Now you should have a data frame `spotify` with the columns _endTime_, _artistName_, _trackName_, and _msPlayed_.

## Assignment

Now that you have your data as a data frame, it's time to analyze your data to generate your mid-year Spotify Wrapped. Please create a Quarto document and use code blocks with `echo = TRUE` so that I can see your code and answer. For bonus points, also turn these into a Quarto presentation.

1. How many total minutes did you listen to Spotify over the last year? Note that the _msPlayed_ column is in milliseconds, so you'll need to convert to minutes.

1. What was your biggest listening day (date with most minutes) and how many minutes did you listen?

1. How many different songs did you listen to over the year?

1. What was the top song that you listened to and how many times did you listen? 

1. What was the first day that you listened to that song?

1. What were your top five most frequently played songs overall?

1. What were your top three most frequently played songs from the first half of the year?

1. What were your top three most frequently played songs from the second half of the year?

1. How many different artists did you listen to?

1. What artist did you listen to most frequently and how many minutes did you listen to that artist?

1. What was the longest number of days in a row that you listened to that artist?

1. What were your top five most frequently played artists overall?

1. Create a plot of the number of minutes listened for each month of the year.

1. Create another plot of your choice.





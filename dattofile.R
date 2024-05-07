#this program reads the dats in DSI_DATA and then outputs them in a single csv

# Function to search for files recursively in a directory
# setwd("yourwdifneeded")

#getting files and converting them to dataframes

find_files <- function(directory, file_pattern) {
  files <- list.files(directory, recursive = TRUE, full.names = TRUE, pattern = file_pattern)
  return(files)
}

# files <- list.files(directory, recursive = TRUE, full.names = TRUE)
# matching_files <- grep(file_pattern, files, value = TRUE)

directory <- "DSI_Data"
file_pattern <- '*.dat'

matching_files <- find_files(directory, file_pattern)
print(matching_files)

datreader <- function(filePath) {
  header <- readLines(filePath, n = 1)
  header <- strsplit(header, "\\s+")[[1]]
  df <- read.table(text=gsub("::", " ", readLines(filePath)), header=FALSE)
  
  colnames(df) <- header
  return(df)
}

stuff <- gregexpr("(DB|Syn)\\d+", matching_files)
info <- regmatches(matching_files, stuff)

winfo <- unlist(info)

#processing
frame_list <- list()

# data <- lapply(matching_files, datreader)

for(n in matching_files){
  data <- datreader(n)
  data <- data#[,-1,drop = FALSE]
  frame_list[[n]] <- data
}


rawdata <- list()
dsidata <- list()

for (i in seq_along(frame_list)) {
  tempdat <- as.data.frame(frame_list[[i]])
  rownames(tempdat) <- paste0(rownames(tempdat), "_", winfo[i])

  if (i %% 2 == 0) {
    rawdata[[length(rawdata) + 1]] <- as.data.frame(tempdat)
  } else {
    dsidata[[length(dsidata) + 1]] <- as.data.frame(tempdat)
  }
}

comboRaw <- do.call(rbind, rawdata)[, -1, drop = FALSE]
comboDSI <- do.call(rbind, dsidata)[, -1, drop = FALSE]

combo <- cbind(comboRaw, comboDSI)

# print(tail(comboRaw))
# print(tail(comboDSI))
# print(head(rawdata[[2]]))
#outputting

output_directory <- "zoutput"
if (!file.exists(output_directory)) {
  dir.create(output_directory)
}

filename <- file.path(output_directory, "combined.csv")
write.csv(combo, filename, row.names = TRUE)

rm(list = ls())
gc()
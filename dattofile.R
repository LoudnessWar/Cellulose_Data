#this program reads the dats in DSI_DATA and then outputs them in a single csv

# Function to search for files recursively in a directory
# setwd("yourwdifneeded")

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


stuff <- gregexpr("(DB|Syn)\\d+", matching_files)
info <- regmatches(matching_files, stuff)

winfo <- unlist(info)

datreader <- function(filePath) {
  
  header <- readLines(filePath, n = 1)
  header <- strsplit(header, "\\s+")[[1]]
  
  
  df <- read.table(text=gsub("::", " ", readLines(filePath)), header=FALSE)
  
  colnames(df) <- header
  
  return(df)
}

output_directory <- "zoutput"
if (!file.exists(output_directory)) {
  dir.create(output_directory)
}

frame_list <- list()

for(n in matching_files){
  data <- datreader(n)
  data <- data[,-1,drop = FALSE]
  frame_list[[n]] <- data
}

combo <- do.call(rbind, frame_list)

filename <- file.path(output_directory, "combined.csv")
write.csv(combo, filename, row.names = TRUE)



rm(list = ls())
gc()
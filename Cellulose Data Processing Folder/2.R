# Function to search for files recursively in a directory
setwd("C:/Users/aiden/Desktop/thinger")

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


stuff <- gregexpr("(DB|Syn)\\d+", matching_files)#I stole this off the internet :skull:
info <- regmatches(matching_files, stuff)

#ok so its putting them as this weird nested list
winfo <- unlist(info)#bc its winning

datreader <- function(filePath) {
  
  header <- readLines(filePath, n = 1)
  header <- strsplit(header, "\\s+")[[1]]
  
  
  df <- read.table(text=gsub("::", " ", readLines(filePath)), header=FALSE)
  
  colnames(df) <- header
  
  #print(df)
  return(df)
}

output_directory <- "zoutput"
if (!file.exists(output_directory)) {
  dir.create(output_directory)
}

for(n in matching_files){
  data <- datreader(n)
  data <- data[,-1,drop = FALSE]
  output_subdirectory <- file.path(output_directory, dirname(n))
  if (!file.exists(output_subdirectory)) {
    dir.create(output_subdirectory, recursive = TRUE)
  }
  filename <- file.path(output_subdirectory, paste0("output_", basename(n), ".csv"))
  write.csv(data, filename, row.names = TRUE)
}


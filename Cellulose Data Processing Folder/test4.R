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

#print(winfo)

datreader <- function(filePath) {
  
  header <- readLines(filePath, n = 1)
  header <- strsplit(header, "\\s+")[[1]]
  
  
  df <- read.table(text=gsub("::", " ", readLines(filePath)), header=FALSE)
  
  colnames(df) <- header
  
  #print(df)
  return(df)
}

data <- lapply(matching_files, datreader)
#lapply(data, print)

means <- lapply(data, colMeans)
#print(means)


calculate_sd <- function(df) {
  sapply(df, sd, na.rm = TRUE)
}

stanDeviation <- sapply(data, calculate_sd)
#print(stanDeviation)


meanFrameListRAW <- list()

for (i in seq_along(means)) {
  if (i %% 2 == 0) { # Check if the index is even
    #print(means[i])
    meanDataFrame <- as.data.frame(means[i])
    #this is genius
    colnames(meanDataFrame) <- winfo[i]
    meanFrameListRAW[[length(meanFrameListRAW) + 1]] <- t(meanDataFrame)
    
  }
}
#print(meanFrameListRAW)
combinedMeanRaw <- do.call(rbind, meanFrameListRAW)
colnames(combinedMeanRaw) <- paste("mean", colnames(combinedMeanRaw), sep = "_")
#print(combinedMeanRaw)

meanFrameList <- list()

for (i in seq_along(means)) {
  if (i %% 2 == 1) { # Check if the index is even
    #print(means[i])
    meanDataFrame <- as.data.frame(means[i])
    #print(meanDataFrame)
    # Append the data frame to the list
    colnames(meanDataFrame) <- winfo[i]
    meanFrameList[[length(meanFrameList) + 1]] <- t(meanDataFrame)
  }
}
#print(meanFrameList)
combinedMean <- do.call(rbind, meanFrameList)
colnames(combinedMean) <- paste("mean", colnames(combinedMean), sep = "_")
#print(combinedMean)

sdFrameListRAW <- list()

for (i in seq_along(stanDeviation)) {
  if (i %% 2 == 0) { # Check if the index is even
    #print(means[i])
    sdDataFrame <- as.data.frame(stanDeviation[i])
    #this is genius
    colnames(sdDataFrame) <- winfo[i]
    sdFrameListRAW[[length(sdFrameListRAW) + 1]] <- t(sdDataFrame)
    
  }
}
combinedSDRaw <- do.call(rbind, sdFrameListRAW)
colnames(combinedSDRaw) <- paste("SD", colnames(combinedSDRaw), sep = "_")
#print(combinedSDRaw)


sdFrameList <- list()

for (i in seq_along(stanDeviation)) {
  if (i %% 2 == 1) { # Check if the index is even
    #print(means[i])
    sdDataFrame <- as.data.frame(stanDeviation[i])
    #print(meanDataFrame)
    # Append the data frame to the list
    colnames(sdDataFrame) <- winfo[i]
    sdFrameList[[length(sdFrameList) + 1]] <- t(sdDataFrame)
  }
}
combinedSD <- do.call(rbind, sdFrameList)
colnames(combinedSD) <- paste("SD", colnames(combinedSD), sep = "_")
#print(combinedSD)


#getting rid of # frame
combinedMeanRaw <- combinedMeanRaw[, -1, drop = FALSE]
combinedMean <- combinedMean[, -1, drop = FALSE]

combinedSDRaw <- combinedSDRaw[, -1, drop = FALSE]
combinedSD <- combinedSD[, -1, drop = FALSE]

combineddf <- cbind(combinedSD, combinedMean)
#print(combineddf)

combinedDFRAW <- cbind(combinedSDRaw, combinedMeanRaw)
#print(combinedDFRAW)

finalDF<- cbind(combinedDFRAW, combineddf)
print(finalDF)

write.csv(finalDF, "fartmuffinJR.csv", row.names = TRUE)



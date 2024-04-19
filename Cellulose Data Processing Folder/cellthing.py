import os
import fnmatch
import pandas as pd


def datreader(file_path):#this one is for if you want to run a single file but as a data frame
    df = pd.read_csv(file_path, delimiter='\t')
    df.drop(df.columns[0], axis=1)# to get read of #frame
    return df

#this gets the stats for the lists
def calculate_stats(dataFrames):
    stats = []
    for df in dataFrames:
        if not df.empty and pd.api.types.is_numeric_dtype(df.iloc[:, 0]):#idk what the second part does low key
            stats.append({
                'File': df.columns[0],
                'Average': df.mean().iloc[0],
                'Standard Deviation': df.std().iloc[0]
            })
        else:#if you want can fill missing data with averages instead would have to do later though
            stats.append({
                'File': df.columns[0],
                'Average': None,
                'Standard Deviation': None
            })
    return pd.DataFrame(stats)

#gets all the files of name *.dat
def find_files(directory, pattern):
    matches = []
    for root, dirnames, filenames in os.walk(directory):
        for filename in fnmatch.filter(filenames, pattern):
            matches.append(os.path.join(root, filename))
    return matches

directoryToSearch = os.getcwd()
filesToFind = '*.dat'
found_files = find_files(directoryToSearch, filesToFind)
data = []
for file_path in found_files:
    print(file_path)
    data = datreader(file_path)
    print(data.head(10))
    
# statistics_df = calculate_stats(data)

# print(statistics_df)

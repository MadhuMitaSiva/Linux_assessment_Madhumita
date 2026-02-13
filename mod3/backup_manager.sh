#!/bin/bash

#Check for the number of arguments
if [ $# -ne 3 ]; then
    echo "Invalid number of arguments."
    exit
fi

# Read the arguments from the Command Line 
Source_path="$1"
Dest_path="$2"
ext="$3"
Totalfile_size=0
BACKUP_COUNT=0
export BACKUP_COUNT

# Checks if the source directory is present or not
if [ ! -d "$Source_path" ]; then
    echo "$Source_path: No such directory found"
    exit
fi

#Check if the backup directory is present, if not create it. If unable to create exit
if [ ! -d "$Dest_path" ]; then
    mkdir -p "$Dest_path" || (echo "Unable to create the directory $Dest_path"; exit)
fi

# Array with files to be backed up
mapfile -t backup_files < <(find "$Source_path" -type f -name "*$ext")

# Exits if the directory does not contain any file of the specified extension
if (( ${#backup_files[@]} == 0 )); then
    echo "No files of $ext present in $Source_path directory."
    exit
fi

for file in "${backup_files[@]}"; do # iterates for each file in the array 
    size=$(stat -c%s "$file")
    filename=$(basename "$file")
    dest_file="$Dest_path/$filename"
    # Checks if the file does not exist already.
    if [ ! -f "$dest_file" ]; then
        cp "$file" "$Dest_path"
        ((BACKUP_COUNT++)) #increments the count of backed up file
        Totalfile_size=$(( Totalfile_size + size ))
    elif [ "$file" -nt "$dest_file"]; then # Checks if the file is newest or not using the -nt 
        cp "$file" "$Dest_path"
        ((BACKUP_COUNT++)) #increments the count of backed up file
    else
        echo "File $filename already backed up...." #The exact file with same timestamp already exist

    fi    
done
# Writesthe backup report 
echo "Total files processed: $BACKUP_COUNT">>backup_report.log
echo "Total size of files backed up: $Totalfile_size bytes">>backup_report.log
echo "Path to backup directory: $Dest_path">>backup_report.log

    





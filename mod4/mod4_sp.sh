#!/bin/bash
#filepath
filepath=~/Desktop/assessments/mod4/input.txt
output_file=~/Desktop/assessments/mod4/output.txt

while read -r line || [[ -n "$line" ]]; do
	if [[ "$line" == "\"frame.time\""* ]]; then
		echo "$line">>$output_file
	elif [[ "$line" == "\"wlan.fc.type\""* ]];then
		echo "$line">>$output_file
	elif [[ "$line" == "\"wlan.fc.subtype\""* ]]; then
		echo "$line">>$output_file
	fi
done<$filepath
echo "File:output.txt written successfully."

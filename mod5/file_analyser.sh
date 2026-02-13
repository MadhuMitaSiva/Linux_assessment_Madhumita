#!/bin/bash
FLAG=1 
#Recursive function to search for subdirectories
directory_search(){
    local fd_call=$1 # takes the first value along the function call
    for fd_path in "$fd_call"/*; do
        if [[ -f "$fd_path" ]]; then
            #echo "file : $fd_path"
            file_search "$fd_path"  #sends the file and keyword to search
        elif [[ -d "$fd_path" ]]; then
            #echo "directory : $fd_path"
            directory_search "$fd_path" # Recursively calls by sending the subdir
        else 
            echo "$fd_path file is empty" | tee -a error.log
        fi     
    done
}

# file searching function
file_search(){
    f_path=$1
    if [[ -e "$f_path" ]]; then
        grep -q "$KEY" "$f_path" 
        if [[ $? -eq 0 ]]; then
            echo "$KEY present in $(basename "$f_path")"
            FLAG=0
        fi
    else
        echo "$f_path No such file/directory found." | tee -a error.log
        exit 1
    fi
}
# help argument using here document
disp_help(){
    cat << EOF
    --help is used to give the detailed description

    -d - directory name/path
    -f - filename name/ path
    -k - keyword to be checked
EOF
exit 0
}

# Getopts implementation
while getopts ":d:f:k:-:" args; do
    case "$args" in 
        d) Dir_path="$OPTARG";;
        f) file_path="$OPTARG";;
        k) KEY="$OPTARG";;
        -) long_arg="$OPTARG";;
        \?) echo "$OPTARG:Invalid argument passed. Use --help for more details" | tee -a error.log ;;
    esac
done
if [[ "$long_arg" == "help" ]]; then
    disp_help
fi
if [[ -n "$KEY" ]]; then
        if [[ "$KEY"=~'^ [a-zA-Z0-9]+$' ]]; then #regex to validate the keyword
            if [[ -n "$Dir_path" ]]; then
                directory_search "$Dir_path"
            elif [[ -n "$file_path" ]]; then
                file_search "$file_path"
            fi
        else 
            echo "Invalid Keyword" | tee -a error.log
            exit 1
        fi
fi

if [[ -n "$KEY" && "$FLAG" -eq 1 ]]; then
       echo "$KEY: Keyword not found in file/files" | tee -a error.log
fi
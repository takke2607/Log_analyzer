#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <log_file> <pattern_file>"
    exit 1
fi

log_file="$1"
pattern_file="$2"

# Check if log file exists
if [ ! -f "$log_file" ]; then
    echo "Error: Log file $log_file not found."
    exit 1
fi

# Check if pattern file exists
if [ ! -f "$pattern_file" ]; then
    echo "Error: Pattern file $pattern_file not found."
    exit 1
fi

# Iterate over each line in the log file
while IFS= read -r line; do
    matched=false
    # Iterate over each pattern in the pattern file
    while IFS= read -r pattern; do
        # Use grep to search for the pattern in the line
        if [[ "$line" =~ $pattern ]]; then
            echo "Potential attack detected with pattern: $pattern"
            echo "$line"
            echo "----------------------------------------"
            matched=true
            break
        fi
    done < "$pattern_file"
    # Check if the line matched any pattern, if not, ignore the line
    if ! $matched; then
        continue
    fi
done < "$log_file"
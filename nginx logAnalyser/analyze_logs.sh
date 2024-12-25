#!/bin/bash

# Check if the log file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOGFILE="$1"

if [ ! -f "$LOGFILE" ]; then
    echo "Error: Log file not found!"
    exit 1
fi

# Function to extract the top N elements for a given field
get_top_elements() {
    local field=$1
    local description=$2
    local log_file=$3
    local n=$4

    echo "Top $n $description:"
    awk -v field="$field" '{print $field}' "$log_file" \
        | sort | uniq -c | sort -nr | head -n "$n" \
        | awk '{print $2 " - " $1 " requests"}'
    echo
}

# Extract IP address (Field 1)
get_top_elements 1 "IP addresses with the most requests" "$LOGFILE" 5

# Extract requested paths (Field 7 contains the request line, such as GET /path HTTP/1.1)
echo "Top 5 most requested paths:"
awk '{print $7}' "$LOGFILE" \
    | sort | uniq -c | sort -nr | head -n 5 \
    | awk '{print $2 " - " $1 " requests"}'
echo

# Extract response status codes (Field 9)
get_top_elements 9 "response status codes" "$LOGFILE" 5

# Extract user agents (Field 12 onwards, combined as a single string)
echo "Top 5 user agents:"
awk -F\" '{print $6}' "$LOGFILE" \
    | sort | uniq -c | sort -nr | head -n 5 \
    | awk '{print $2 " - " $1 " requests"}'
echo

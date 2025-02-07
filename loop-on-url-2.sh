#!/bin/bash

set -x # Enable debugging

URL="https://dcgsvcs.com" # Website URL assignment

while true; do
    title=$(curl -sL "$URL" | grep -oP '(?<=<title>).*(?=</title>)')
    # title=$(curl -sL "$URL" | pup 'title text{}') # Using pup for better parsing
    if [[ -n "$title" ]]; then
        echo "$title"
    else
        echo "Error or no title found"
    fi
    sleep 10 # Be respectuful - increase sleep time
done

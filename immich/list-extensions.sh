#!/bin/bash

# Check if directory argument is provided
if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <directory>"
    echo "Directory must exist"
    exit 1
fi

# Convert to absolute path
BASE_DIR=$(cd "$1" && pwd)

echo "Scanning directory: $BASE_DIR"
echo "Finding all file extensions..."

# Find all files, extract extensions, sort and count
find "$BASE_DIR" -type f -name "*.*" | \
    awk -F. '{
        if (NF>1) {
            extension=tolower($NF)
            count[extension]++
            total++
        }
    } END {
        printf "\nFound %d files with extensions:\n\n", total
        for (ext in count) {
            printf "%-10s: %5d files (%0.1f%%)\n", 
                   ext, 
                   count[ext], 
                   (count[ext]/total)*100
        }
    }' | sort -k3nr

exit 0
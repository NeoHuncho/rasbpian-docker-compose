#!/bin/bash

set -e
set -u

# Cleanup function
cleanup() {
    local exit_code=$?
    rm -f "${TEMP_FILE:-}"
    exit $exit_code
}

trap cleanup EXIT

# Check if the input directory is provided and exists
if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    printf "Usage: %s <directory>\n" "$0"
    printf "Directory must exist\n"
    exit 1
fi

# Convert to absolute path
BASE_DIR=$(cd "$1" && pwd)

# Log file setup
LOG_FILE="$(pwd)/compression.log"
printf "Compression started at %s\n" "$(date)" > "$LOG_FILE"

# Process video function

process_video() {
    local input_file="$1"
    local TEMP_FILE="${input_file%.*}_temp.mp4"
    local output_file="${input_file%.*}.mp4"
    local current="$2"
    local total="$3"
    
    printf "[%d/%d] Processing: %s\n" "$current" "$total" "$input_file"
    
    # Get original file size and timestamps
    local original_size=$(stat -f %z "$input_file")

    if ! ffmpeg -i "$input_file" \
        -map 0:v:0 -map 0:a:0? \
        -map_metadata 0 \
        -c:v h264_videotoolbox \
        -b:v 5M \
        -maxrate 6M \
        -bufsize 6M \
        -crf 18 \
        -vf "scale='min(1920,iw)':'-2':flags=lanczos" \
        -c:a aac -b:a 128k \
        -threads 0 \
        -movflags +faststart \
        -y "$TEMP_FILE" 2>> "$LOG_FILE"; then
        
        printf "[%d/%d] Error processing: %s\n" "$current" "$total" "$input_file"
        rm -f "$TEMP_FILE"
        return 1
    fi

    # Get compressed size and calculate savings
    local compressed_size=$(stat -f %z "$TEMP_FILE")
    local saved_space=$((original_size - compressed_size))
    local compression_ratio=$(echo "scale=2; $compressed_size * 100 / $original_size" | bc)

    # Move and restore timestamps
    if mv "$TEMP_FILE" "$output_file"; then
        rm "$input_file"
        printf "[%d/%d] Compressed: %s (%.2f%% of original, saved %.2f MB)\n" \
            "$current" "$total" \
            "$input_file" \
            "$compression_ratio" \
            "$(echo "scale=2; $saved_space / 1048576" | bc)"
        return 0
    else
        printf "[%d/%d] Error moving temp file: %s\n" "$current" "$total" "$output_file"
        rm -f "$TEMP_FILE"
        return 1
    fi
}

# Create array to store files (Mac compatible)
files=()
while IFS= read -r -d $'\0' file; do
    files+=("$file")
done < <(find "$BASE_DIR" -type f \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mod" -o -iname "*.mts" -o -iname "*.mpg" -o -iname "*.wmv" -o -iname "*.m4v" -o -iname "*.3gp" \) ! -iname ".*" -print0)


total_files=${#files[@]}
printf "Found %d files to process\n" "$total_files"

# Process files from array
for ((i=0; i<total_files; i++)); do
    if [ -f "${files[$i]}" ]; then
        process_video "${files[$i]}" $((i+1)) "$total_files"
    else
        printf "[%d/%d] Error: File not found: %s\n" $((i+1)) "$total_files" "${files[$i]}"
    fi
done

printf "Compression completed at %s\n" "$(date)" >> "$LOG_FILE"
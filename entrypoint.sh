#!/bin/bash
set -e

# Get inputs from environment variables

# For hyphenated input names, GitHub should convert hyphens to underscores
# i.e. "output-format" becomes INPUT_OUTPUT_FORMAT. Which does not seem to happen
SOURCE_PATTERN="${INPUT_SOURCE}"
OUTPUT_FORMAT="${INPUT_OUTPUT-FORMAT}"
OUTPUT_DIR="${INPUT_OUTPUT-DIR}"
TEMPLATE="${INPUT_TEMPLATE}"
EXTRA_ARGS="${INPUT_EXTRA-ARGS}"

# Create output directory if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Process template option
TEMPLATE_ARG=""
if [ -n "$TEMPLATE" ]; then
  TEMPLATE_ARG="--template=${TEMPLATE}"
fi

# Find and process all source files
for source_file in $SOURCE_PATTERN; do
  if [ -f "$source_file" ]; then
    filename=$(basename -- "$source_file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    
    output_file="${OUTPUT_DIR}/${filename}.${OUTPUT_FORMAT}"
    
    echo "Converting $source_file to $output_file"
    
    # Execute pandoc with the specified options
    pandoc "$source_file" -o "$output_file" $TEMPLATE_ARG $EXTRA_ARGS
    
    echo "Conversion complete: $output_file"
  fi
done
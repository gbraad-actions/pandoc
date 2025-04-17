#!/bin/bash
set -e

# Get inputs from environment variables

# For hyphenated input names, GitHub should convert hyphens to underscores
# i.e. "output-format" becomes INPUT_OUTPUT_FORMAT. Which does not seem to happen
# Get source pattern
SOURCE_PATTERN="${INPUT_SOURCE}"

# For hyphenated input names, we need a different approach
# Extract raw environment variables for hyphenated names
export_env_var() {
  # Get all environment variables
  ALL_ENV=$(env)
  
  # Extract specific variable (e.g., INPUT_OUTPUT-FORMAT) using grep and cut
  VAR_NAME="INPUT_$1"
  VAR_LINE=$(echo "$ALL_ENV" | grep "^$VAR_NAME=" || echo "")
  
  if [ -n "$VAR_LINE" ]; then
    # Extract the value (everything after the first =)
    VAR_VALUE="${VAR_LINE#*=}"
    # Export to given name
    export "$2"="$VAR_VALUE"
    return 0
  else
    return 1
  fi
}

# Extract our variables properly
export_env_var "OUTPUT-FORMAT" "OUTPUT_FORMAT" || OUTPUT_FORMAT="pdf"
export_env_var "OUTPUT-DIR" "OUTPUT_DIR" || OUTPUT_DIR="output"
export_env_var "TEMPLATE" "TEMPLATE" || TEMPLATE=""
export_env_var "EXTRA-ARGS" "EXTRA_ARGS" || EXTRA_ARGS=""

# Debug information
echo "Debug info after processing:"
echo "- Source pattern: ${SOURCE_PATTERN}"
echo "- Output format: ${OUTPUT_FORMAT}"
echo "- Output directory: ${OUTPUT_DIR}"
echo "- Template: ${TEMPLATE}"
echo "- Extra arguments: ${EXTRA_ARGS}"


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
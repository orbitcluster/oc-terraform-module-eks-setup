#!/bin/bash
# Retrieve environment variables and output as JSON for Terraform "external" data source

# Check if MASTER_S3_DIRECTORY is set
if [ -z "$MASTER_S3_DIRECTORY" ]; then
  # Write error to stderr so strict JSON parsing doesn't fail on stdout
  echo "Error: MASTER_S3_DIRECTORY environment variable is not set." >&2
  exit 1
else
  # Safely echo JSON
  echo "{\"master_s3_directory\": \"$MASTER_S3_DIRECTORY\"}"
fi

#!/bin/bash
# Generated with llama3.2 2025-04-12

# Set the directory path where your repositories are located
REPO_DIR="/Users/nathan/code"

# Function to create a compressed tarball
create_tarball() {
  local dir="$1"
  local tar_name="${dir##*/}"
  local tar_path="$REPO_DIR/$tar_name.tar.gz"

  echo "Creating tarball for $tar_name..."

  # Create the archive
  tar -czf "$tar_path" "$dir"

  echo "Tarball created: $tar_path"
}

# Function to process a repository
process_repository() {
  local dir="$1"

  echo "Processing repository at $dir..."

  # Create a compressed tarball for the directory
  create_tarball "$dir"

  echo "Repository processed."
}

# Loop through all top-level directories in $REPO_DIR
for dir in "$REPO_DIR"/*; do
  if [ -d "$dir" ]; then
    process_repository "$dir"
  fi
done

echo "All done!"

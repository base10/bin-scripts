#!/bin/bash

# Generated with llama3.2 2025-04-12
# Set the directory path where your repositories are located
REPO_DIR="/Users/nathan/code"

# Loop through all directories and subdirectories at the same level as
repositories
for dir in "$REPO_DIR"/*; do
  # Check if the current directory is a repository (contains .git directory)
  if [ -d "$dir"/.git ]; then
    # Create a compressed tarball of the current directory
    tar_name="${dir##*/}"
    tar_path="$REPO_DIR/$tar_name"
    tar_path_with_ext="${tar_path%.*/}.tar.gz"
    echo "Created tarball: $tar_path_with_ext"
    tar -czf "$tar_path_with_ext" "$dir"
  fi
done

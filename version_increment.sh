#!/bin/bash

# Function to increment the version
increment_version() {
    local current_version=$1
    local new_version=$(echo "$current_version" | awk -F'_' '{print $1}' | awk -F'.' '{$NF+=1; print}' OFS='.')
    echo "${new_version}_QA"
}

# Get the latest tag
latest_tag=$(git describe --tags --abbrev=0)

# Increment the version
new_tag=$(increment_version "$latest_tag")

# Create a new tag
git tag "$new_tag"

# Push the new tag to remote
git push origin "$new_tag"

# name: Version Incrementation

on:fdfd
  push:
    branches:
      - main

jobs:
  increment_version:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Get Latest Tag
        id: latest_tag
        run: |
          git fetch --tags
          latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
          if [ -z "$latest_tag" ]; then
            # If no tag found, use branch name
            latest_tag=$(echo "v1.0.0_${GITHUB_REF#refs/heads/}")
          fi
          echo "::set-output name=latest_tag::$latest_tag"

      - name: Increment Version
        id: increment_version
        run: |
          # Extract major, minor, and patch numbers from the latest tag
          major=$(echo "${{ steps.latest_tag.outputs.latest_tag }}" | cut -d'.' -f1 | sed 's/v//')
          minor=$(echo "${{ steps.latest_tag.outputs.latest_tag }}" | cut -d'.' -f2)
          patch=$(echo "${{ steps.latest_tag.outputs.latest_tag }}" | cut -d'.' -f3 | cut -d'_' -f1)
          # Increment the appropriate part (e.g., minor) as needed
          minor=$((minor + 1))
          # Form the new version string
          new_version="v${major}.${minor}.${patch}_QA"
          echo "::set-output name=new_version::$new_version"

      - name: Commit Changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git commit -am "Increment version to ${{ steps.increment_version.outputs.new_version }}"
          git push


      - name: Commit Changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git commit -am "Increment version to ${{ steps.increment_version.outputs.new_version }}"
          git push

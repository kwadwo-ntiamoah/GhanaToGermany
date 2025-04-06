#!/bin/bash

# Define project paths and output base path
projects=(
    "./Api/"
    "./Shared/"
    "./UI/"
    # Add other project paths
)

output_base="./Output"

# Publish each project
for project in "${projects[@]}"; do
    project_name=$(basename "$project")
    output_path="${output_base}/${project_name}"

    echo "Publishing $project to $output_path"
    dotnet publish "$project" -c Release -o "$output_path"
done
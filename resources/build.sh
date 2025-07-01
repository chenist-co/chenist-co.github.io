#!/bin/bash

MICRO_COURSES_DIR="/home/alin/Documents/Stoic/academy/micro-courses"

echo "Starting micro-courses PDF generation and cleanup..."

# Iterate through each subdirectory in the micro-courses directory
for course_dir in "$MICRO_COURSES_DIR"/*/; do
    if [ -d "$course_dir" ]; then
        course_name=$(basename "$course_dir")
        echo "Processing course: $course_name"
        
        # Change to the course directory
        pushd "$course_dir" > /dev/null
        
        # Check if main.tex exists
        if [ -f "main.tex" ]; then
            echo "  Compiling main.tex..."
            pdflatex main.tex > /dev/null 2>&1
            pdflatex main.tex > /dev/null 2>&1 # Run twice for TOC/references
            
            echo "  Cleaning up auxiliary files..."
            rm -f main.aux main.log main.out main.toc
            echo "  Cleanup complete."
        else
            echo "  main.tex not found in $course_name, skipping."
        fi
        
        # Return to the original directory
        popd > /dev/null
        echo "Finished processing $course_name."
    fi
done

echo "All micro-courses processed."

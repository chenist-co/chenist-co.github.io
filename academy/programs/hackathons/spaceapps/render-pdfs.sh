#!/bin/bash
# Script to generate PDFs from TeX files

# Change to the script directory
cd "$(dirname "$0")"

# Make sure the pdfs directory exists
mkdir -p pdfs

echo "Generating PDFs from TeX files..."

# Process each TeX file in the pdfs directory
for texfile in pdfs/*.tex; do
    # Get the base filename without extension
    filename=$(basename "$texfile" .tex)
    
    echo "Compiling $filename.tex..."
    
    # Compile the TeX file using pdflatex
    (cd pdfs && pdflatex "$filename.tex") && \
    echo "Generated pdfs/$filename.pdf" || \
    echo "Failed to generate PDF for $filename"
    
    # Run pdflatex a second time to resolve references if needed
    (cd pdfs && pdflatex "$filename.tex") > /dev/null 2>&1
    
    # Clean up auxiliary files
    rm -f pdfs/*.aux pdfs/*.log pdfs/*.out
done

echo "PDF generation complete!"
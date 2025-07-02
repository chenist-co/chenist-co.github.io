#!/bin/bash
# Script to generate LaTeX-based PDFs for event pages

# Change to the script directory
cd "$(dirname "$0")"

echo "Generating LaTeX-based event PDFs..."

# Make sure the pdfs directory exists
mkdir -p ../pdfs
# Make sure the temp directory exists
mkdir -p ../_temp

# Run the Python script
python3 generate_latex_pdfs.py

echo "PDF generation script completed!"
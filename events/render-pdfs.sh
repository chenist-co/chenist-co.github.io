#!/bin/bash
# Script to generate PDFs for event pages

# Change to the script directory
cd "$(dirname "$0")"

# Make sure the pdfs directory exists
mkdir -p pdfs
# Make sure the temp directory exists
mkdir -p _temp

echo "Generating event PDFs..."

# Process each event qmd file
for event in pages/*.qmd; do
    # Skip template files
    if [[ $event == *"_"* ]]; then
        continue
    fi
    
    event_name=$(basename "$event" .qmd)
    output_file="pdfs/${event_name}.pdf"
    
    echo "Rendering $event_name..."
    
    # Copy the qmd file to the temp directory
    cp "$event" _temp/
    
    # Use quarto to render the PDF in the temp directory
    (cd _temp && quarto render "$(basename "$event")" --to pdf) && \
    
    # Move the generated PDF to the pdfs directory
    mv "_temp/${event_name}.pdf" "$output_file" && \
    echo "Generated $output_file" || \
    echo "Failed to generate PDF for $event_name"
done

# Clean up
rm -f _temp/*.qmd _temp/*.pdf

echo "PDF generation complete!"
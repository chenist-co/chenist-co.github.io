#!/bin/bash
# Script to generate PDFs for webinar pages

# Change to the script directory
cd "$(dirname "$0")"

# Make sure the pdfs directory exists
mkdir -p pdfs
# Make sure the temp directory exists
mkdir -p _temp

echo "Generating webinar PDFs..."

# Process each webinar qmd file
for webinar in pages/*.qmd; do
    # Skip template files
    if [[ $webinar == *"_"* ]]; then
        continue
    fi
    
    webinar_name=$(basename "$webinar" .qmd)
    output_file="pdfs/${webinar_name}.pdf"
    
    echo "Rendering $webinar_name..."
    
    # Copy the qmd file to the temp directory
    cp "$webinar" _temp/
    
    # Use quarto to render the PDF in the temp directory
    (cd _temp && quarto render "$(basename "$webinar")" --to pdf) && \
    
    # Move the generated PDF to the pdfs directory
    mv "_temp/${webinar_name}.pdf" "$output_file" && \
    echo "Generated $output_file" || \
    echo "Failed to generate PDF for $webinar_name"
done

# Clean up
rm -f _temp/*.qmd _temp/*.pdf

echo "PDF generation complete!"
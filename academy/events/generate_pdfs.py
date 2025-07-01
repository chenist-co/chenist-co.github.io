#!/usr/bin/env python3
"""
Generate PDF files for all event pages using quarto.
This script:
1. Reads each event page .qmd file
2. Extracts metadata and content
3. Creates a temporary .qmd file with the PDF format
4. Renders the PDF using quarto
5. Moves the output to the correct location
"""

import os
import re
import sys
import yaml
import subprocess
import shutil
from pathlib import Path

# Directories
BASE_DIR = Path(__file__).parent.resolve()
PAGES_DIR = BASE_DIR / "pages"
PDFS_DIR = BASE_DIR / "pdfs"
TEMP_DIR = BASE_DIR / "_temp"

# Template
TEMPLATE_FILE = PAGES_DIR / "_event-pdf-template.qmd"

def extract_metadata(file_path):
    """Extract YAML metadata and content from a .qmd file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract YAML metadata
    yaml_match = re.match(r'^---\n(.*?)\n---\n', content, re.DOTALL)
    if not yaml_match:
        print(f"Warning: No YAML metadata found in {file_path}")
        return {}, content
    
    yaml_text = yaml_match.group(1)
    try:
        metadata = yaml.safe_load(yaml_text)
    except yaml.YAMLError as e:
        print(f"Error parsing YAML metadata in {file_path}: {e}")
        return {}, content
    
    # Get the content after metadata
    main_content = content[yaml_match.end():]
    
    return metadata, main_content

def extract_sections(content):
    """Extract sections from the content."""
    # Basic extraction for common sections
    sections = {}
    
    # Get event overview
    overview_match = re.search(r'## Event Overview\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if overview_match:
        sections['overview'] = overview_match.group(1).strip()
    
    # Get challenge areas if present
    challenge_match = re.search(r'## Challenge Areas\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if challenge_match:
        sections['challenge_areas'] = challenge_match.group(1).strip()
    
    # Get schedule
    schedule_match = re.search(r'## Schedule\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if schedule_match:
        sections['schedule'] = schedule_match.group(1).strip()
    
    # Get prizes if present
    prizes_match = re.search(r'## Prizes\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if prizes_match:
        sections['prizes'] = prizes_match.group(1).strip()
    
    # Get who should attend
    who_match = re.search(r'## Who Should (Attend|Participate)\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if who_match:
        sections['who_should_attend'] = who_match.group(2).strip()
    
    # Get registration info
    reg_match = re.search(r'## Registration Information\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if reg_match:
        sections['registration_info'] = reg_match.group(1).strip()
    
    # Get FAQ if present
    faq_match = re.search(r'## Frequently Asked Questions\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if faq_match:
        sections['faq'] = faq_match.group(1).strip()
    
    return sections

def render_pdf(template_file, output_file, data):
    """Create a temporary .qmd file and render it to PDF using quarto."""
    # Create temp directory if it doesn't exist
    os.makedirs(TEMP_DIR, exist_ok=True)
    
    # Read template
    with open(template_file, 'r', encoding='utf-8') as f:
        template = f.read()
    
    # Simple template substitution
    for key, value in data.items():
        placeholder = '{{' + key + '}}'
        if isinstance(value, str):
            template = template.replace(placeholder, value)
    
    # Handle conditional sections
    for key in data:
        # Replace conditional opening tags
        template = re.sub(r'{{#' + key + '}}(.*?){{/' + key + '}}', 
                         r'\1' if data.get(key) else '', 
                         template, 
                         flags=re.DOTALL)
    
    # Create temporary file
    temp_file = TEMP_DIR / f"{output_file.stem}_temp.qmd"
    with open(temp_file, 'w', encoding='utf-8') as f:
        f.write(template)
    
    # Run quarto to render PDF
    try:
        subprocess.run(['quarto', 'render', str(temp_file), '--to', 'pdf'], check=True)
        
        # Move the output PDF to the desired location
        temp_pdf = TEMP_DIR / f"{output_file.stem}_temp.pdf"
        if os.path.exists(temp_pdf):
            shutil.move(temp_pdf, output_file)
            print(f"Generated {output_file}")
        else:
            print(f"Error: PDF not generated for {temp_file}")
    except subprocess.CalledProcessError as e:
        print(f"Error rendering PDF: {e}")
    finally:
        # Clean up temp file
        if os.path.exists(temp_file):
            os.remove(temp_file)

def main():
    """Main function to process all event pages."""
    # Create output directory
    os.makedirs(PDFS_DIR, exist_ok=True)
    
    # Process each event page
    for qmd_file in PAGES_DIR.glob('*.qmd'):
        # Skip template and hidden files
        if qmd_file.name.startswith('_') or qmd_file.name.startswith('.'):
            continue
        
        print(f"Processing {qmd_file.name}...")
        
        # Extract metadata and content
        metadata, content = extract_metadata(qmd_file)
        if not metadata:
            continue
        
        # Extract sections
        sections = extract_sections(content)
        
        # Combine data for template
        data = {**metadata, **sections}
        
        # Define output PDF file
        output_pdf = PDFS_DIR / f"{qmd_file.stem}.pdf"
        
        # Render PDF
        render_pdf(TEMPLATE_FILE, output_pdf, data)
    
    # Clean up temp directory if it's empty
    if os.path.exists(TEMP_DIR) and not os.listdir(TEMP_DIR):
        os.rmdir(TEMP_DIR)
    
    print("PDF generation complete!")

if __name__ == "__main__":
    main()
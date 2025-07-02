# Event PDF Generation

This directory contains scripts and resources for generating professional-looking PDF versions of event pages.

## Overview

Two approaches are available for generating PDFs:

1. **Quarto PDF Generation** - Using the built-in Quarto PDF rendering capabilities
2. **LaTeX PDF Generation** - Using a custom LaTeX template for more control over styling

## Quarto PDF Generation

The `render-pdfs.sh` script in the parent directory uses Quarto's PDF rendering capabilities to generate PDFs directly from QMD files. This approach is simpler but offers less control over the output styling.

To use:
```bash
cd ..
./render-pdfs.sh
```

## LaTeX PDF Generation

The LaTeX-based PDF generation provides more control over the PDF appearance and includes professional typesetting features. The output PDFs have a consistent design with headers, footers, and well-formatted sections.

To use:
```bash
./generate_latex_pdfs.sh
```

### Script Details

- `generate_latex_pdfs.py` - Python script that extracts content from QMD files and generates LaTeX files
- `generate_latex_pdfs.sh` - Shell script wrapper for easier execution

### Requirements

To use the LaTeX PDF generation script, you need:

- Python 3.6+
- LaTeX distribution (TeX Live or similar)
- PyYAML library (`pip install pyyaml`)

### Output

Generated PDFs are placed in the `../pdfs/` directory. Temporary files are created in `../_temp/` and are cleaned up after processing.

## Customization

To customize the LaTeX template, edit the `LATEX_TEMPLATE` variable in `generate_latex_pdfs.py`. The template uses standard LaTeX syntax with placeholders that get replaced with content from the QMD files.

## Troubleshooting

If PDF generation fails, check:

1. The LaTeX logs in the `_temp` directory
2. Make sure all required LaTeX packages are installed
3. Verify that the QMD files have proper YAML frontmatter
4. Check for special characters in the content that might need escaping
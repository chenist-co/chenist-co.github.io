#!/usr/bin/env python3
"""
Generate LaTeX-based PDF files for all event pages.
This script:
1. Reads each event page .qmd file
2. Extracts metadata and content
3. Creates a LaTeX file with the event information
4. Renders the LaTeX file to PDF using pdflatex
5. Moves the output to the correct location
"""

import os
import re
import sys
import yaml
import subprocess
import shutil
from pathlib import Path
from datetime import datetime

# Directories
BASE_DIR = Path(__file__).parent.parent.resolve()
PAGES_DIR = BASE_DIR / "pages"
PDFS_DIR = BASE_DIR / "pdfs"
TEMP_DIR = BASE_DIR / "_temp"

# Template for LaTeX file
LATEX_TEMPLATE = r"""
\documentclass[11pt]{article}
\usepackage[a4paper, margin=1in]{geometry}
\usepackage{graphicx}
\usepackage{xcolor}
\usepackage{hyperref}
\usepackage{enumitem}
\usepackage{fontawesome}
\usepackage{tcolorbox}
\usepackage{fancyhdr}
\usepackage{tabularx}
\usepackage{booktabs}
\usepackage{url}

% Define colors
\definecolor{primary}{RGB}{0, 123, 255}
\definecolor{secondary}{RGB}{108, 117, 125}
\definecolor{success}{RGB}{40, 167, 69}
\definecolor{dark}{RGB}{50, 54, 66}

% Set up hyperlinks
\hypersetup{
    colorlinks=true,
    linkcolor=primary,
    urlcolor=primary,
}

% Set up headers and footers
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[C]{\thepage}
\fancyhead[L]{\textcolor{primary}{<<EVENT_TITLE>>}}
\fancyhead[R]{\textcolor{primary}{<<EVENT_DATE>>}}

% Custom commands
\newcommand{\sectiontitle}[1]{
    \vspace{0.3cm}
    \noindent\textcolor{primary}{\Large\textbf{#1}}
    \vspace{0.2cm}
}

\newcommand{\eventitem}[2]{
    \noindent\textbf{#1} \hfill #2\\
}

\begin{document}

\begin{center}
    \vspace*{-1cm}
    \textcolor{primary}{\Huge\textbf{<<EVENT_TITLE_UPPERCASE>>}}\\
    \vspace{0.5cm}
    \textcolor{primary}{\Large\textbf{<<EVENT_SUBTITLE>>}}\\
    \vspace{0.3cm}
    \textcolor{secondary}{\large <<EVENT_DATE_FORMATTED>> • <<EVENT_LOCATION>>}\\
    \vspace{0.5cm}
    {\normalsize Generated on: <<GENERATION_DATE>>}\\
    \vspace{0.8cm}
\end{center}

<<EVENT_IMAGE>>

\begin{tcolorbox}[colback=primary!10, colframe=primary, title=\textbf{Event Overview}]
<<EVENT_OVERVIEW>>

\textit{Note: Details, dates, and themes are subject to change.}
\end{tcolorbox}

<<EVENT_CHALLENGE_AREAS>>

\sectiontitle{Schedule}
<<EVENT_SCHEDULE>>

<<EVENT_PRIZES>>

\sectiontitle{Who Should <<ATTEND_OR_PARTICIPATE>>}
<<WHO_SHOULD_ATTEND>>

\sectiontitle{Registration Information}
<<REGISTRATION_INFO>>

\begin{tcolorbox}[colback=success!10, colframe=success, title=\textbf{Ready to Learn More?}]
Join us for this event that will challenge your abilities and connect you with the community.

Visit our website: \href{https://chen.ist/events}{chen.ist/events}
\end{tcolorbox}

<<EVENT_FAQ>>

\vspace{1cm}
\begin{center}
    \textbf{For more information and updates:}\\
    \vspace{0.3cm}
    Visit \href{https://chen.ist/events}{chen.ist/events}\\
    \vspace{0.3cm}
    Contact: \texttt{contact@chen.ist}
\end{center}

\end{document}
"""

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
    
    # Remove HTML blocks
    content = re.sub(r'```\{=html\}.*?```', '', content, flags=re.DOTALL)
    
    # Get event overview
    overview_match = re.search(r'## Event Overview\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if overview_match:
        sections['overview'] = overview_match.group(1).strip()
    
    # Get challenge areas if present
    challenge_match = re.search(r'## Challenge (Areas|Format)\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if challenge_match:
        sections['challenge_areas'] = challenge_match.group(2).strip()
    
    # Get schedule
    schedule_match = re.search(r'## Schedule\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if schedule_match:
        sections['schedule'] = schedule_match.group(1).strip()
    
    # Get prizes if present
    prizes_match = re.search(r'## Prizes( and Recognition)?\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if prizes_match:
        sections['prizes'] = prizes_match.group(2).strip()
    
    # Get who should attend
    who_match = re.search(r'## Who Should (Attend|Participate)\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if who_match:
        sections['who_should_attend'] = who_match.group(2).strip()
        sections['attend_or_participate'] = who_match.group(1).upper()
    else:
        sections['attend_or_participate'] = "ATTEND"
    
    # Get registration info
    reg_match = re.search(r'## Registration Information\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if reg_match:
        sections['registration_info'] = reg_match.group(1).strip()
    
    # Get FAQ if present
    faq_match = re.search(r'## Frequently Asked Questions\s+(.*?)(?=##|\Z)', content, re.DOTALL)
    if faq_match:
        sections['faq'] = faq_match.group(1).strip()
    
    return sections

def format_date(date_str):
    """Format date from ISO format to readable format."""
    try:
        date_obj = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
        return date_obj.strftime('%B %d, %Y')
    except ValueError:
        return date_str

def convert_markdown_to_latex(text):
    """Convert basic Markdown to LaTeX."""
    if not text:
        return ""
    
    # Convert headers
    text = re.sub(r'### (.*)', r'\\subsubsection*{\1}', text)
    text = re.sub(r'## (.*)', r'\\subsection*{\1}', text)
    
    # Convert bold
    text = re.sub(r'\*\*(.*?)\*\*', r'\\textbf{\1}', text)
    
    # Convert italic
    text = re.sub(r'\*(.*?)\*', r'\\textit{\1}', text)
    
    # Convert links
    text = re.sub(r'\[(.*?)\]\((.*?)\)', r'\\href{\2}{\1}', text)
    
    # Convert bullet lists
    text = re.sub(r'- (.*?)(?=\n- |\n\n|\Z)', r'\\item \1', text, flags=re.DOTALL)
    text = re.sub(r'(\n\\item .*?(?=\n\n|\Z))', r'\\begin{itemize}[leftmargin=*]\1\n\\end{itemize}', text, flags=re.DOTALL)
    
    # Convert tables (simple conversion, may need improvement)
    def table_to_latex(match):
        table_content = match.group(0)
        rows = table_content.strip().split('\n')
        
        # Skip the header separator line
        header_row = rows[0]
        content_rows = rows[2:] if len(rows) > 2 and '|---' in rows[1] else rows[1:]
        
        # Create the LaTeX table
        header_cells = [cell.strip() for cell in header_row.split('|')[1:-1]]
        latex_table = '\\begin{tabularx}{\\textwidth}{' + 'l' + 'X' * (len(header_cells) - 1) + '}\n'
        latex_table += '\\toprule\n'
        
        # Add header row
        latex_table += ' & '.join(['\\textbf{' + cell + '}' for cell in header_cells]) + ' \\\\\n'
        latex_table += '\\midrule\n'
        
        # Add content rows
        for row in content_rows:
            cells = [cell.strip() for cell in row.split('|')[1:-1]]
            latex_table += ' & '.join(cells) + ' \\\\\n'
        
        latex_table += '\\bottomrule\n'
        latex_table += '\\end{tabularx}\n'
        
        return latex_table
    
    # Find and convert all tables
    text = re.sub(r'\|.*?\|(?:\n\|.*?\|)+', table_to_latex, text)
    
    return text

def generate_latex(metadata, sections):
    """Generate LaTeX content from metadata and sections."""
    # Initialize LaTeX content with template
    latex_content = LATEX_TEMPLATE
    
    # Replace title and other metadata
    title = metadata.get('title', 'Event')
    subtitle = metadata.get('subtitle', '')
    
    # Format dates
    event_date = metadata.get('date', '')
    event_end_date = metadata.get('enddate', '')
    
    formatted_date = format_date(event_date)
    if event_end_date:
        formatted_date += f" - {format_date(event_end_date)}"
    
    # Get current date for generation date
    generation_date = datetime.now().strftime('%B %d, %Y')
    
    # Prepare image section
    image_path = metadata.get('image', '')
    image_section = ''
    if image_path:
        if not image_path.startswith('/'):
            image_path = '/' + image_path
        image_section = f'% Comment out image if it causes issues\n% \\includegraphics[width=\\textwidth]{{{image_path}}}'
    
    # Replace placeholders in template
    replacements = {
        '<<EVENT_TITLE>>': title,
        '<<EVENT_TITLE_UPPERCASE>>': title.upper(),
        '<<EVENT_SUBTITLE>>': subtitle,
        '<<EVENT_DATE>>': formatted_date.split(' - ')[0] if ' - ' in formatted_date else formatted_date,
        '<<EVENT_DATE_FORMATTED>>': formatted_date,
        '<<EVENT_LOCATION>>': metadata.get('location', ''),
        '<<GENERATION_DATE>>': generation_date,
        '<<EVENT_IMAGE>>': image_section,
        '<<EVENT_OVERVIEW>>': convert_markdown_to_latex(sections.get('overview', '')),
        '<<ATTEND_OR_PARTICIPATE>>': sections.get('attend_or_participate', 'ATTEND'),
        '<<WHO_SHOULD_ATTEND>>': convert_markdown_to_latex(sections.get('who_should_attend', '')),
        '<<REGISTRATION_INFO>>': convert_markdown_to_latex(sections.get('registration_info', '')),
    }
    
    # Optional sections
    if 'challenge_areas' in sections:
        replacements['<<EVENT_CHALLENGE_AREAS>>'] = f"\\sectiontitle{{Challenge Details}}\n{convert_markdown_to_latex(sections['challenge_areas'])}"
    else:
        replacements['<<EVENT_CHALLENGE_AREAS>>'] = ''
    
    if 'schedule' in sections:
        replacements['<<EVENT_SCHEDULE>>'] = convert_markdown_to_latex(sections['schedule'])
    else:
        replacements['<<EVENT_SCHEDULE>>'] = ''
    
    if 'prizes' in sections:
        replacements['<<EVENT_PRIZES>>'] = f"\\sectiontitle{{Prizes and Recognition}}\n{convert_markdown_to_latex(sections['prizes'])}"
    else:
        replacements['<<EVENT_PRIZES>>'] = ''
    
    if 'faq' in sections:
        replacements['<<EVENT_FAQ>>'] = f"\\sectiontitle{{Frequently Asked Questions}}\n{convert_markdown_to_latex(sections['faq'])}"
    else:
        replacements['<<EVENT_FAQ>>'] = ''
    
    # Apply all replacements
    for placeholder, value in replacements.items():
        latex_content = latex_content.replace(placeholder, value)
    
    return latex_content

def compile_latex(tex_file):
    """Compile LaTeX file to PDF."""
    try:
        # Run pdflatex twice to ensure proper references
        subprocess.run(['pdflatex', '-interaction=nonstopmode', tex_file], 
                       cwd=tex_file.parent, 
                       capture_output=True, 
                       check=True)
        subprocess.run(['pdflatex', '-interaction=nonstopmode', tex_file], 
                       cwd=tex_file.parent, 
                       capture_output=True, 
                       check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error compiling LaTeX: {e}")
        return False

def main():
    """Main function to process all event pages."""
    # Create output directories
    os.makedirs(PDFS_DIR, exist_ok=True)
    os.makedirs(TEMP_DIR, exist_ok=True)
    
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
        
        # Generate LaTeX content
        latex_content = generate_latex(metadata, sections)
        
        # Create LaTeX file
        temp_tex = TEMP_DIR / f"{qmd_file.stem}.tex"
        with open(temp_tex, 'w', encoding='utf-8') as f:
            f.write(latex_content)
        
        # Compile LaTeX to PDF
        if compile_latex(temp_tex):
            # Move the PDF to the target directory
            temp_pdf = TEMP_DIR / f"{qmd_file.stem}.pdf"
            target_pdf = PDFS_DIR / f"{qmd_file.stem}.pdf"
            shutil.copy(temp_pdf, target_pdf)
            print(f"Generated {target_pdf}")
        else:
            print(f"Failed to generate PDF for {qmd_file.name}")
    
    # Clean up temporary files
    for ext in ['.aux', '.log', '.out', '.toc']:
        for file in TEMP_DIR.glob(f'*{ext}'):
            os.remove(file)
    
    # Clean up temporary directory if it's empty
    temp_files = list(TEMP_DIR.glob('*'))
    if not temp_files:
        try:
            os.rmdir(TEMP_DIR)
        except OSError:
            pass
    
    print("PDF generation complete!")

if __name__ == "__main__":
    main()
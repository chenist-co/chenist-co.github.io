#!/bin/bash

# This script compiles the main.tex file in each course folder into a PDF.

COURSES_DIR="courses"

for COURSE_DIR in "$COURSES_DIR"/*; do
  if [ -d "$COURSE_DIR" ]; then
    CHAPTERS_DIR="$COURSE_DIR/chapters"
    if [ -d "$CHAPTERS_DIR" ]; then
      for MD_FILE in "$CHAPTERS_DIR"/*.md; do
        if [ -f "$MD_FILE" ]; then
          TEX_FILE="${MD_FILE%.md}.tex"
          echo "Converting $MD_FILE to $TEX_FILE..."
          pandoc "$MD_FILE" -o "$TEX_FILE"
        fi
      done
    fi
    MAIN_TEX_FILE="$COURSE_DIR/main.tex"
    if [ -f "$MAIN_TEX_FILE" ]; then
      echo "Compiling $MAIN_TEX_FILE..."
      pdflatex -output-directory="$COURSE_DIR" "$MAIN_TEX_FILE"
      pdflatex -output-directory="$COURSE_DIR" "$MAIN_TEX_FILE"
    fi
  fi
done
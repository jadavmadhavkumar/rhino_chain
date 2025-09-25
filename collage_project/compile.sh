#!/bin/bash

# Clean up auxiliary files
rm -f *.log *.aux *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.bbl *.blg *.acn *.glo *.idx *.ist *.bcf *.run.xml

# Check if main.tex exists
if [ ! -f "main.tex" ]; then
    echo "Error: main.tex not found!"
    exit 1
fi

# Check for required LaTeX tools
command -v pdflatex >/dev/null 2>&1 || { echo "Error: pdflatex not found. Install texlive-core: sudo pacman -S texlive-core"; exit 1; }
command -v latexmk >/dev/null 2>&1 || { echo "Warning: latexmk not found. Install it if needed: sudo pacman -S texlive-binextra"; }

# First compilation - generates .aux files
echo "Running pdflatex (first pass)..."
if ! pdflatex -interaction=nonstopmode main.tex; then
    echo "Error: First pdflatex run failed. Check main.log for details."
    echo "If a package like tracklang.sty is missing, install it with: sudo pacman -S texlive-langextra"
    exit 1
fi

# Second compilation - builds TOC and references
echo "Running pdflatex (second pass)..."
if ! pdflatex -interaction=nonstopmode main.tex; then
    echo "Error: Second pdflatex run failed. Check main.log for details."
    exit 1
fi

# Third compilation - finalizes everything
echo "Running pdflatex (final pass)..."
if ! pdflatex -interaction=nonstopmode main.tex; then
    echo "Error: Final pdflatex run failed. Check main.log for details."
    exit 1
fi

# Optional: Use latexmk for automated compilation
echo "Running latexmk..."
if ! latexmk -pdf main.tex; then
    echo "Warning: latexmk run failed. Check main.log for details."
else
    echo "latexmk compilation completed."
fi

# Check if the PDF was generated successfully
if [ -f "main.pdf" ]; then
    echo "Compilation successful! Output: main.pdf"
else
    echo "Error: Compilation failed. Check main.log for details."
    exit 1
fi

# Make this script executable
chmod +x "$0"
echo "Script made executable."

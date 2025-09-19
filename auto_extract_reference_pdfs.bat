@echo off
REM Automated PDF-to-Text Extraction for Reference Files
REM Requires poppler-utils (pdftotext) in PATH

echo ========================================
echo EXTRACTING PDF TEXT FROM REFERENCE FOLDER
echo ========================================
python extract_all_reference_pdfs.py

echo ========================================
echo EXTRACTION COMPLETE
echo ========================================
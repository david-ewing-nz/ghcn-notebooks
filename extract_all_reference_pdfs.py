import os
import subprocess
import sys
from pathlib import Path

import fitz  # PyMuPDF


def extract_pdf_text_pymupdf(pdf_path, txt_path):
    doc = fitz.open(pdf_path)
    text = ""
    for page in doc:
        text += page.get_text()
    with open(txt_path, "w", encoding="utf-8") as f:
        f.write(text)
    print(f"Extracted: {pdf_path} -> {txt_path}")


def main():
    reference_dir = Path("reference")
    pdf_files = [reference_dir / "assignment.pdf", reference_dir / "grading.pdf"]
    for pdf in pdf_files:
        txt = pdf.with_suffix(".txt")
        if pdf.exists():
            extract_pdf_text_pymupdf(pdf, txt)
        else:
            print(f"File not found: {pdf}")


if __name__ == "__main__":
    main()

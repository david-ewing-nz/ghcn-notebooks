import re

import PyPDF2


def extract_text_from_pdf(pdf_path):
    with open(pdf_path, "rb") as file:
        reader = PyPDF2.PdfReader(file)
        text = ""
        for page in reader.pages:
            text += page.extract_text()
    return text


pdf_path = r"d:\github\ghcn-notebooks\reference\grading.pdf"
text = extract_text_from_pdf(pdf_path)

# Print the full text to see the structure
print("Full grading PDF content:")
print(text)
print("\n" + "=" * 80 + "\n")

# Search for any lines with numbers that might be marks
lines = text.split("\n")
number_lines = [line for line in lines if re.search(r"\d+", line)]

print("Lines with numbers (potential marks):")
for line in number_lines:
    print(line)

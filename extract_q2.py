import PyPDF2


def extract_text_from_pdf(pdf_path):
    with open(pdf_path, "rb") as file:
        reader = PyPDF2.PdfReader(file)
        text = ""
        for page in reader.pages:
            text += page.extract_text()
    return text


pdf_path = r"d:\github\ghcn-notebooks\reference\assignment.pdf"
text = extract_text_from_pdf(pdf_path)

# Search for Q2 and surrounding lines
lines = text.split("\n")
q2_indices = [
    i
    for i, line in enumerate(lines)
    if "Q2" in line or ("Question 2" in line and "2." in line)
]

print("Q2 related sections:")
for idx in q2_indices:
    start = max(0, idx - 5)
    end = min(len(lines), idx + 10)
    section = "\n".join(lines[start:end])
    print(f"\n--- Section around line {idx} ---")
    print(section)

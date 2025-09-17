import json


def extract_q2_cells(notebook_path):
    with open(notebook_path, "r", encoding="utf-8") as f:
        notebook = json.load(f)

    q2_cells = []
    for i, cell in enumerate(notebook["cells"]):
        if cell["cell_type"] == "code":
            source = "".join(cell["source"])
            if "Q2" in source:
                q2_cells.append(
                    {
                        "cell_index": i,
                        "source": source[:500] + "..." if len(source) > 500 else source,
                    }
                )

    return q2_cells


notebook_path = r"d:\github\ghcn-notebooks\code\20250916D_Build.ipynb"
q2_cells = extract_q2_cells(notebook_path)

print(f"Found {len(q2_cells)} cells with Q2:")
for cell in q2_cells:
    print(f"\n--- Cell {cell['cell_index']} ---")
    print(cell["source"])

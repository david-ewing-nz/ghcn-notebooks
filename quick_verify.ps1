# Quick verification script - PowerShell version
Write-Host "========================================" -ForegroundColor Green
Write-Host "QUICK NOTEBOOK VERIFICATION" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Checking core cells in 18A notebook..." -ForegroundColor Yellow

# Run Python verification
python -c "
import json
with open('code/20250918A_Build.ipynb', 'r', encoding='utf-8') as f:
    nb = json.load(f)

cells = nb['cells']
imports_found = helpers_found = variables_found = False

for i, cell in enumerate(cells):
    if cell['cell_type'] == 'code':
        source = ''.join(cell['source'])
        if 'from IPython.display' in source and 'from math' in source and not imports_found:
            print(' Imports cell: Cell', i+1, '- PRESENT')
            imports_found = True
        elif 'HELPER / DIAGNOSTIC FUNCTIONS' in source and not helpers_found:
            print(' Helper functions cell: Cell', i+1, '- PRESENT')
            helpers_found = True
        elif 'SECTION 1: ENVIRONMENT SETUP' in source and not variables_found:
            print(' Variables cell: Cell', i+1, '- PRESENT')
            variables_found = True

print()
q2_count = 0
for i, cell in enumerate(cells):
    if cell['cell_type'] == 'code':
        source = ''.join(cell['source'])
        if 'Q2' in source:
            q2_count += 1

print('Q2 cells found:', q2_count)
print()
print('VERIFICATION COMPLETE')
"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
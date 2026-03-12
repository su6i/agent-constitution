---
name: Form Filling Automation
description: A comprehensive guide to programmatically filling PDF forms using Python (ReportLab + PyPDF).
---

[Back to README](../../README.md)

# Automated PDF Form Filling Skill

This skill documents the workflow for filling flat (non-interactive) PDF forms by generating a transparent text overlay and merging it with the original document.

## 🛠 Prerequisites

*   **Python 3.10+**
*   **Libraries**:
    *   `reportlab`: For generating the PDF overlay (text, images).
    *   `pypdf`: For merging the overlay with the source PDF.
    *   `pdfplumber`: For debugging and finding exact X/Y coordinates.
    *   `uv`: Recommended for dependency management.

```bash
uv add reportlab pypdf pdfplumber
```

## 🚀 Workflow

### Phase 1: Coordinate Discovery (Debugging)
Before writing code, you need to find the X/Y coordinates for each field. Use `pdfplumber` to scan for keywords.

**Template `scripts/debug_coordinates.py`:**
```python
import pdfplumber
def find_coordinates(pdf_path, page_num, keywords):
    with pdfplumber.open(pdf_path) as pdf:
        words = page.extract_words()
        height = page.height
        
        print(f"--- Searching Page {page_num + 1} ---")
        words.sort(key=lambda w: w['top']) # Sort by vertical position
        
        for w in words:
            text = w['text']
            # Coordinates: bottom-left is 0,0 usually in PDF, but visual top-left is different.
            # ReportLab uses bottom-left 0,0. 
            # PDFPlumber gives 'top' from top.
            # Convert to ReportLab Y: height - bottom
            reportlab_y = height - w['bottom']
            
            for k in keywords:
                if k.lower() in text.lower():
                    print(f"['{text}'] x={w['x0']:.2f}, y={reportlab_y:.2f}")

if __name__ == "__main__":
    find_coordinates("form.pdf", 0, ["Nom", "Prénom", "Date"])
```

### Phase 2: Create Overlay Logic
Use `reportlab` to draw text at the discovered coordinates.

**Best Practices:**
*   **Vertical Alignment**: To make text sit *on* or just *above* a dotted line, often add **+2 to +5 points** to the discovered Y-coordinate.
*   **Centering**: Use a helper function to center text between two X-coordinates.
*   **Data Separation**: Keep data in a dictionary (`DATA`) separate from drawing logic.

**Template `scripts/fill_forms.py`:**
```python
import io
import os
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import A4
from pypdf import PdfReader, PdfWriter

DATA = {
    "surname": "DOE",
    "firstname": "John",
}

def create_overlay():
    packet = io.BytesIO()
    c = canvas.Canvas(packet, pagesize=A4)
    c.setFont("Helvetica", 11)

    # Helper for alignment
    def draw_centered(x_start, x_end, y, text):
        center_x = (x_start + x_end) / 2
        c.drawCentredString(center_x, y + 2, text) # +2 visual offset

    # Draw Fields
    draw_centered(100, 300, 500, DATA["surname"]) # Discovered Y=500
    
    # Checkboxes (if needed)
    # c.drawString(150, 400, "X")

    c.save()
    packet.seek(0)
    return packet
```

### Phase 3: Merge and Output
Combine the generated overlay with the original blank form.

```python
def fill_pdf(original_path, output_path, overlay_func):
    overlay_pdf = PdfReader(overlay_func())
    original_pdf = PdfReader(original_path)
    writer = PdfWriter()

    for i, page in enumerate(original_pdf.pages):
        # Merge if overlay has this page
        if i < len(overlay_pdf.pages):
            page.merge_page(overlay_pdf.pages[i])
        writer.add_page(page)

    with open(output_path, "wb") as f:
        writer.write(f)
```

## 💡 Troubleshooting & Tips

1.  **Invisible Text**:
    *   Use `pdfplumber` to extract text from the *generated* PDF (`dump_text.py`) to verify it was written.
    *   If present but invisible, check if it's white text, hidden behind layers (move Y down), or Font issues.
    
2.  **Alignment Drift**:
    *   "Floating" text: Reduce Y coordinate.
    *   "Overlapping" text: Adjust X or reduce font size.
    *   Use `drawCentredString` for variable-length content (Names, Cities) to avoid fitting issues.

3.  **Preserving Manual Edits**:
    *   When updating code for a user, **Always Read** the current file first. Re-writing a function blindly destroys their manual coordinate tweaks.
    *   Identify "Manual" sections in code comments (e.g., `# User Edit`).

[Back to README](../../README.md)

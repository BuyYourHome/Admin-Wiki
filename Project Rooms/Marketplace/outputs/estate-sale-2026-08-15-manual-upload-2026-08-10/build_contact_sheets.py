from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps

root = Path(__file__).resolve().parent
font = ImageFont.load_default(size=20)
cols, rows = 3, 3
cell_w, cell_h, label_h = 520, 390, 44

for source_name, output_name in (("source-copies", "contact-sheets"), ("enhanced", "contact-sheets-enhanced")):
    source = root / source_name
    output = root / output_name
    output.mkdir(exist_ok=True)
    files = sorted(p for p in source.iterdir() if p.suffix.lower() in {".jpg", ".jpeg", ".png", ".webp"})
    for sheet_no, start in enumerate(range(0, len(files), cols * rows), 1):
        canvas = Image.new("RGB", (cols * cell_w, rows * (cell_h + label_h)), "white")
        draw = ImageDraw.Draw(canvas)
        for offset, path in enumerate(files[start:start + cols * rows]):
            image = Image.open(path).convert("RGB")
            thumb = ImageOps.contain(image, (cell_w - 16, cell_h - 16))
            x = (offset % cols) * cell_w + (cell_w - thumb.width) // 2
            y0 = (offset // cols) * (cell_h + label_h)
            y = y0 + (cell_h - thumb.height) // 2
            canvas.paste(thumb, (x, y))
            label = path.stem.replace("ES-20260815-20260810-", "")
            draw.rectangle((offset % cols * cell_w, y0 + cell_h, (offset % cols + 1) * cell_w, y0 + cell_h + label_h), fill="white")
            draw.text((offset % cols * cell_w + 8, y0 + cell_h + 8), label, fill="black", font=font)
        canvas.save(output / f"contact-sheet-{sheet_no:02d}.jpg", quality=92)
    print(f"created {sheet_no} {output_name} sheets for {len(files)} files")

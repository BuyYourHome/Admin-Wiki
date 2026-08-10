from pathlib import Path
from PIL import Image, ImageEnhance, ImageOps

root = Path(__file__).resolve().parent
captures = root / "source-copies"
originals = root / "source-originals"
enhanced = root / "enhanced"
enhanced.mkdir(exist_ok=True)

for capture in sorted(p for p in captures.iterdir() if p.suffix.lower() in {".jpg", ".jpeg", ".png", ".webp"}):
    key = "-".join(capture.stem.split("-")[:4])
    candidates = sorted(originals.glob(f"{key}-original.*")) if originals.exists() else []
    source = candidates[0] if candidates else capture
    image = ImageOps.exif_transpose(Image.open(source)).convert("RGB")
    image = ImageOps.autocontrast(image, cutoff=0.5, preserve_tone=True)
    image = ImageEnhance.Color(image).enhance(1.04)
    image = ImageEnhance.Contrast(image).enhance(1.03)
    image = ImageEnhance.Sharpness(image).enhance(1.12)
    if max(image.size) < 1200:
        scale = 1200 / max(image.size)
        image = image.resize((round(image.width * scale), round(image.height * scale)), Image.Resampling.LANCZOS)
    out = enhanced / f"{key}-enhanced.jpg"
    image.save(out, quality=94, optimize=True, progressive=True)

print(f"prepared {len(list(enhanced.glob('*.jpg')))} enhanced photos")

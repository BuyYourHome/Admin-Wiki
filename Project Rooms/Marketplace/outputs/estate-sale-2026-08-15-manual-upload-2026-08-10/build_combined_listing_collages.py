from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageOps

root = Path(__file__).resolve().parent
source = root / "enhanced"
output = root / "combined-post"
output.mkdir(exist_ok=True)

font = ImageFont.truetype("arial.ttf", 36)
small = ImageFont.truetype("arial.ttf", 26)

groups = [
    (
        "Collectibles and Decor",
        [
            ("132605", "Gone With the Wind collectibles", "$175"),
            ("133254", "Ornate oval mirror", "$75"),
            ("134358", "Gone With the Wind card set", "$20"),
            ("133606", "Jewelry / keepsake boxes", "$20"),
        ],
    ),
    (
        "Small Decor",
        [
            ("134439", "Nativity wall plaque", "$12"),
            ("134521", "Frog children's plate", "$5"),
            ("134704", "Bear figurine trio", "$15"),
            ("134732", "Butterfly display ornament", "$15"),
        ],
    ),
    (
        "Media and Household",
        [
            ("133647", "Mixed cassette-tape lot", "$25"),
            ("134808", "GE clock cassette recorder", "$20"),
            ("134827", "Boxed household-item lot", "$30"),
            ("142826", "Floral ceramic decor trio", "$35"),
        ],
    ),
    (
        "Furniture and Lighting",
        [
            ("140558", "Pair of torchiere floor lamps", "$25"),
            ("140657", "Wood rocking chair", "$45"),
        ],
    ),
]

def find_photo(time_key: str) -> Path:
    matches = sorted(source.glob(f"*-{time_key}-enhanced.jpg"))
    if not matches:
        raise FileNotFoundError(time_key)
    return matches[0]

for number, (heading, items) in enumerate(groups, 1):
    canvas = Image.new("RGB", (1600, 1300), "#f4f1eb")
    draw = ImageDraw.Draw(canvas)
    draw.rectangle((0, 0, 1600, 90), fill="#263238")
    draw.text((40, 22), heading, fill="white", font=font)
    positions = [(20, 110), (810, 110), (20, 680), (810, 680)]
    tile_h = 500 if len(items) > 2 else 1060
    positions = positions if len(items) > 2 else [(20, 110), (810, 110)]
    for (time_key, label, price), (x, y) in zip(items, positions):
        image = Image.open(find_photo(time_key)).convert("RGB")
        target_h = tile_h - 90
        thumb = ImageOps.contain(image, (750, target_h))
        px = x + (750 - thumb.width) // 2
        py = y + (target_h - thumb.height) // 2
        canvas.paste(thumb, (px, py))
        draw.rectangle((x, y + target_h, x + 750, y + tile_h), fill="white")
        draw.text((x + 14, y + target_h + 12), label, fill="#111111", font=small)
        draw.text((x + 650, y + target_h + 12), price, fill="#9b1c1c", font=small, anchor="ra")
    draw.text((40, 1250), "Estate sale • Cary, NC • Saturday, Aug. 15 • 9 AM–noon", fill="#263238", font=small)
    canvas.save(output / f"estate-sale-new-items-{number:02d}.jpg", quality=94, optimize=True)

print(f"created {len(groups)} combined-listing photo boards")

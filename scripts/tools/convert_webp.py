import os
import subprocess
import sys

def install_pillow():
    try:
        import PIL
    except ImportError:
        print("Installing Pillow...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "Pillow", "pillow-heif"])

install_pillow()

from PIL import Image
from pathlib import Path
try:
    from pillow_heif import register_heif_opener
    register_heif_opener()
except ImportError:
    print("pillow-heif not found, HEIC conversion might fail.")

def convert_to_webp(directory):
    path = Path(directory)
    converted_files = []
    
    for ext in ['*.jpg', '*.jpeg', '*.png', '*.heic', '*.JPG', '*.JPEG', '*.PNG', '*.HEIC']:
        for img_path in path.rglob(ext):
            try:
                # Open image
                with Image.open(img_path) as img:
                    webp_path = img_path.with_suffix('.webp')
                    
                    # Convert RGBA to RGB if it's going to be a lossy JPEG-like image, 
                    # but WebP supports RGBA so we can just save it as is.
                    # We will use quality 85 which is a good balance for web.
                    img.save(webp_path, 'WEBP', quality=85)
                    print(f"Converted: {img_path.name} -> {webp_path.name}")
                    converted_files.append((img_path, webp_path))
            except Exception as e:
                print(f"Error converting {img_path}: {e}")
                
    return converted_files

if __name__ == "__main__":
    img_dir = "./assets/img"
    print(f"Starting conversion in {img_dir}...")
    converted = convert_to_webp(img_dir)
    print(f"Done! Converted {len(converted)} images.")
    
    # Save a mapping of old to new filenames so we can replace them in HTML
    with open('convert_map.txt', 'w') as f:
        for old, new in converted:
            # We only care about the relative path from the root of the project
            old_rel = str(old).replace('./', '')
            new_rel = str(new).replace('./', '')
            f.write(f"{old_rel}|{new_rel}\n")

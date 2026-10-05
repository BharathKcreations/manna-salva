# pyrefly: ignore [missing-import]
from PIL import Image, ImageFilter

def make_clean_logo():
    # Load logo-store
    im = Image.open('assets/images/logo-store.png').convert('RGBA')
    w, h = im.size
    
    # Create mask
    # Background in logo-store is the store wall: high brightness and pinkish/cream hue
    mask = Image.new('L', (w, h), 0)
    
    # We will do BFS flood fill from edges to identify outer background
    visited = set()
    queue = []
    
    for x in range(w):
        queue.append((x, 0))
        queue.append((x, h - 1))
        visited.add((x, 0))
        visited.add((x, h - 1))
        
    for y in range(h):
        if (0, y) not in visited:
            queue.append((0, y))
            visited.add((0, y))
        if (w - 1, y) not in visited:
            queue.append((w - 1, y))
            visited.add((w - 1, y))
            
    def is_outer_bg(pixel):
        r, g, b, a = pixel
        # Logo black badge:
        if r < 95 and g < 95 and b < 95:
            return False
        # Logo gold ribbon: gold has high red, moderate green, low blue (r - b > 45)
        if r > 120 and g > 80 and (r - b > 40 or g - b > 25) and b < 130:
            return False
        # White text inside badge won't be reached by outer BFS
        # Background wall is grayish cream/pink:
        # r ~ 220-250, g ~ 200-230, b ~ 180-220 (b is high! difference between r and b is < 45)
        return True

    outer_bg = set()
    head = 0
    while head < len(queue):
        cx, cy = queue[head]
        head += 1
        px = im.getpixel((cx, cy))
        if is_outer_bg(px):
            outer_bg.add((cx, cy))
            for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                nx, ny = cx + dx, cy + dy
                if 0 <= nx < w and 0 <= ny < h and (nx, ny) not in visited:
                    visited.add((nx, ny))
                    queue.append((nx, ny))

    # Build mask: 255 for logo, 0 for outer_bg
    for x in range(w):
        for y in range(h):
            if (x, y) not in outer_bg:
                mask.putpixel((x, y), 255)
            else:
                mask.putpixel((x, y), 0)

    # Smooth the mask edges slightly
    # Erode and feather slightly for smooth antialiasing
    blurred_mask = mask.filter(ImageFilter.GaussianBlur(radius=0.7))
    
    clean_im = im.copy()
    clean_im.putalpha(blurred_mask)
    clean_im.save('assets/images/brand-logo.png')
    print("Saved assets/images/brand-logo.png")

make_clean_logo()

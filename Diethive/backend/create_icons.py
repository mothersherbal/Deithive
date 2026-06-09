import os
from PIL import Image, ImageDraw

def make_round(img):
    mask = Image.new('L', img.size, 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, img.size[0], img.size[1]), fill=255)
    result = img.copy()
    result.putalpha(mask)
    return result

def main():
    img_path = r"C:\Users\DELL\.gemini\antigravity\brain\885d352a-eaf1-4626-b68b-7d31babd35ae\diethive_app_icon_1772680867721.png"
    base_out = r"C:\Users\DELL\AndroidStudioProjects\DietHive\app\src\main\res"
    
    sizes = {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192
    }
    
    try:
        img = Image.open(img_path).convert("RGBA")
        
        # We will make round icons as well
        round_img = make_round(img)
        
        for dpi, size in sizes.items():
            folder = os.path.join(base_out, f"mipmap-{dpi}")
            os.makedirs(folder, exist_ok=True)
            
            # normal launcher
            img_resized = img.resize((size, size), Image.Resampling.LANCZOS)
            img_resized.save(os.path.join(folder, "ic_launcher.png"), format="PNG")
            
            # round launcher
            round_resized = round_img.resize((size, size), Image.Resampling.LANCZOS)
            round_resized.save(os.path.join(folder, "ic_launcher_round.png"), format="PNG")
        
        print("Success")
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    main()

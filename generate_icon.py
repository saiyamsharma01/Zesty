import math
import os
from PIL import Image, ImageDraw, ImageFilter

def create_ultra_3d_zesty_icon(output_path="assets/icons/app_icon.png", size=1024):
    # Render at 2048x2048 supersampling for crisp edges and smooth lighting
    W = size * 2
    H = size * 2
    
    # 1. Base Full-Bleed Background with Cinematic Lighting
    img = Image.new("RGBA", (W, H), (0, 0, 0, 255))
    draw = ImageDraw.Draw(img)
    
    # Base vertical gradient: Royal Deep Plum / Violet to Midnight Navy
    for y in range(H):
        t = y / H
        # Deep luxury gradient: #3D0959 -> #240538 -> #11021C
        r = int(61 * (1 - t*0.8) + 17 * (1 - t))
        g = int(9 * (1 - t*0.8) + 2)
        b = int(89 * (1 - t*0.7) + 28 * (1 - t))
        draw.line([(0, y), (W, y)], fill=(r, g, b, 255))
        
    # Multi-layered luminous ambient lighting blooms
    bloom = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    bdraw = ImageDraw.Draw(bloom)
    
    # Big warm coral-gold back-light behind the 'Z' (giving high contrast and 3D depth)
    cx, cy = int(W * 0.50), int(H * 0.48)
    max_r = int(W * 0.70)
    for ri in range(max_r, 0, -8):
        t = ri / max_r
        alpha = int(60 * (1 - t)**1.4)
        bdraw.ellipse([cx - ri, cy - ri, cx + ri, cy + ri], fill=(255, 95, 20, alpha))
        
    # Secondary hot spot near center
    for ri in range(int(W * 0.35), 0, -6):
        t = ri / (W * 0.35)
        alpha = int(75 * (1 - t)**1.5)
        bdraw.ellipse([cx - ri, cy - ri - int(H*0.05), cx + ri, cy + ri - int(H*0.05)], fill=(255, 185, 40, alpha))

    # Top-left soft violet-blue ambient light
    for ri in range(int(W * 0.45), 0, -8):
        t = ri / (W * 0.45)
        alpha = int(40 * (1 - t)**1.8)
        bdraw.ellipse([int(W*0.15) - ri, int(H*0.15) - ri, int(W*0.15) + ri, int(H*0.15) + ri], fill=(170, 70, 255, alpha))

    # Bottom-right warm amber rim light
    for ri in range(int(W * 0.40), 0, -8):
        t = ri / (W * 0.40)
        alpha = int(45 * (1 - t)**1.8)
        bdraw.ellipse([int(W*0.85) - ri, int(H*0.85) - ri, int(W*0.85) + ri, int(H*0.85) + ri], fill=(255, 120, 0, alpha))

    img = Image.alpha_composite(img, bloom)

    # 2. 3D Geometric Floating 'Z' Emblem
    z_pts = [
        (W * 0.22, H * 0.22),  # Top-left
        (W * 0.78, H * 0.22),  # Top-right
        (W * 0.78, H * 0.36),  # Top-bar bottom-right
        (W * 0.48, H * 0.63),  # Diagonal inner-top
        (W * 0.78, H * 0.63),  # Bottom-bar top-right
        (W * 0.78, H * 0.77),  # Bottom-bar bottom-right
        (W * 0.22, H * 0.77),  # Bottom-bar bottom-left
        (W * 0.22, H * 0.63),  # Bottom-bar top-left
        (W * 0.52, H * 0.36),  # Diagonal inner-bottom
        (W * 0.22, H * 0.36),  # Top-bar bottom-left
    ]

    # Deep 3D Ambient Drop Shadow onto Background
    shadow_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    s_draw = ImageDraw.Draw(shadow_layer)
    
    # Soft large diffused shadow
    for offset_y in [70, 95, 120]:
        s_pts = [(x + 20, y + offset_y) for (x, y) in z_pts]
        s_draw.polygon(s_pts, fill=(5, 1, 15, 85))
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(radius=45))
    img = Image.alpha_composite(img, shadow_layer)

    # 3. Extrusion Layers for 3D Depth
    ext_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    edraw = ImageDraw.Draw(ext_layer)
    
    num_steps = 75
    dx_total = 28
    dy_total = 68
    
    for i in range(num_steps, 0, -1):
        ratio = i / num_steps
        ox = int(dx_total * ratio)
        oy = int(dy_total * ratio)
        
        # Shading for 3D extrusion: Front fiery vibrant, back dark wine terracotta
        cr = int(225 * (1 - ratio * 0.65) + 35)
        cg = int(60 * (1 - ratio * 0.8) + 10)
        cb = int(15 * (1 - ratio * 0.8) + 5)
        
        layer_pts = [(x + ox, y + oy) for (x, y) in z_pts]
        edraw.polygon(layer_pts, fill=(cr, cg, cb, 255))
        
        if i < num_steps:
            prev_ox = int(dx_total * ((i + 1) / num_steps))
            prev_oy = int(dy_total * ((i + 1) / num_steps))
            for k in range(len(z_pts)):
                p1 = (z_pts[k][0] + ox, z_pts[k][1] + oy)
                p2 = (z_pts[(k+1)%len(z_pts)][0] + ox, z_pts[(k+1)%len(z_pts)][1] + oy)
                p3 = (z_pts[(k+1)%len(z_pts)][0] + prev_ox, z_pts[(k+1)%len(z_pts)][1] + prev_oy)
                p4 = (z_pts[k][0] + prev_ox, z_pts[k][1] + prev_oy)
                
                angle = math.atan2(p2[1]-p1[1], p2[0]-p1[0])
                light_val = math.sin(angle) * 0.5 + 0.5
                side_r = min(255, int(cr * (0.65 + 0.45 * light_val)))
                side_g = min(255, int(cg * (0.65 + 0.45 * light_val)))
                side_b = min(255, int(cb * (0.65 + 0.45 * light_val)))
                edraw.polygon([p1, p2, p3, p4], fill=(side_r, side_g, side_b, 255))

    img = Image.alpha_composite(img, ext_layer)

    # 4. Front Face of "Z" with Radiant Sunrise Gradient & Bevel Chamfer
    z_front = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    zf_draw = ImageDraw.Draw(z_front)
    
    min_y = int(H * 0.20)
    max_y = int(H * 0.80)
    
    z_temp = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    zt_draw = ImageDraw.Draw(z_temp)
    
    # Radiant Citrus Gradient:
    for y in range(min_y, max_y + 1):
        t = (y - min_y) / (max_y - min_y)
        if t < 0.42:
            st = t / 0.42
            fr = 255
            fg = int(245 * (1 - st) + 125 * st)
            fb = int(20 * (1 - st) + 0 * st)
        else:
            st = (t - 0.42) / 0.58
            fr = 255
            fg = int(125 * (1 - st) + 26 * st)
            fb = int(0 * (1 - st) + 75 * st)
        zt_draw.line([(0, y), (W, y)], fill=(fr, fg, fb, 255))
        
    z_mask = Image.new("L", (W, H), 0)
    ImageDraw.Draw(z_mask).polygon(z_pts, fill=255)
    z_front.paste(z_temp, (0, 0), z_mask)
    
    # 3D Bevel Chamfer Highlight along the front face perimeter
    zf_draw.polygon(z_pts, outline=(255, 255, 205, 230), width=8)
    
    # Top surface specular shine
    top_shine = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    tsh_draw = ImageDraw.Draw(top_shine)
    tsh_draw.polygon([
        (W * 0.22, H * 0.22),
        (W * 0.78, H * 0.22),
        (W * 0.78, H * 0.26),
        (W * 0.22, H * 0.26),
    ], fill=(255, 255, 255, 140))
    
    # Diagonal glass reflection beam
    tsh_draw.polygon([
        (W * 0.48, H * 0.22),
        (W * 0.65, H * 0.22),
        (W * 0.32, H * 0.77),
        (W * 0.20, H * 0.77),
    ], fill=(255, 255, 255, 60))
    
    z_front = Image.composite(Image.alpha_composite(z_front, top_shine), z_front, z_mask)
    img = Image.alpha_composite(img, z_front)

    # 5. Glowing 3D Speed Lightning Bolt (5-10 Min Express Delivery)
    bolt_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    bdraw = ImageDraw.Draw(bolt_layer)
    
    bolt_pts = [
        (W * 0.58, H * 0.26),  # Top right tip
        (W * 0.40, H * 0.48),  # Left bend
        (W * 0.52, H * 0.48),  # Right step
        (W * 0.34, H * 0.74),  # Bottom strike tip
        (W * 0.61, H * 0.43),  # Outer right bend
        (W * 0.48, H * 0.43),  # Inner left step
        (W * 0.65, H * 0.26),  # Top outer right
    ]
    
    # Drop shadow from lightning bolt onto Z
    bolt_cast_shadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    bcs_draw = ImageDraw.Draw(bolt_cast_shadow)
    bcs_pts = [(x + 15, y + 25) for (x, y) in bolt_pts]
    bcs_draw.polygon(bcs_pts, fill=(0, 0, 0, 160))
    bolt_cast_shadow = bolt_cast_shadow.filter(ImageFilter.GaussianBlur(radius=15))
    img = Image.alpha_composite(img, bolt_cast_shadow)

    # Electric Neon Glow behind the bolt
    bolt_glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    bg_draw = ImageDraw.Draw(bolt_glow)
    bg_draw.polygon(bolt_pts, fill=(255, 240, 60, 220))
    bolt_glow = bolt_glow.filter(ImageFilter.GaussianBlur(radius=25))
    img = Image.alpha_composite(img, bolt_glow)
    
    # Bolt 3D Extrusion
    for bi in range(16, 0, -1):
        box = bi * 0.55
        boy = bi * 0.95
        b_ext = [(x + box, y + boy) for (x, y) in bolt_pts]
        bdraw.polygon(b_ext, fill=(200, 130, 0, 255))
        
    # Bolt Core Front Face (Radiant Electric Lemon & Pure White Core)
    bolt_front = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    bf_draw = ImageDraw.Draw(bolt_front)
    bf_draw.polygon(bolt_pts, fill=(255, 255, 160, 255))
    bf_draw.polygon(bolt_pts, outline=(255, 255, 255, 255), width=6)
    
    # Pure white central flare inside bolt
    core_pts = [
        (W * 0.57, H * 0.29),
        (W * 0.43, H * 0.47),
        (W * 0.51, H * 0.47),
        (W * 0.38, H * 0.70),
        (W * 0.58, H * 0.44),
        (W * 0.49, H * 0.44),
        (W * 0.62, H * 0.29),
    ]
    bf_draw.polygon(core_pts, fill=(255, 255, 255, 240))
    
    bolt_layer = Image.alpha_composite(bolt_layer, bolt_front)
    img = Image.alpha_composite(img, bolt_layer)

    # 6. Ultra 3D Juicy Citrus Orange Wheel & Curved Glossy Green Leaves
    fruit_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(fruit_layer)
    
    fcx, fcy = int(W * 0.72), int(H * 0.70)
    fradius = int(W * 0.175)
    
    # Fruit realistic 3D cast shadow
    fshadow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    fs_draw = ImageDraw.Draw(fshadow)
    fs_draw.ellipse([fcx - fradius - 10, fcy - fradius + 25, fcx + fradius + 25, fcy + fradius + 50], fill=(0, 0, 0, 210))
    fshadow = fshadow.filter(ImageFilter.GaussianBlur(radius=30))
    img = Image.alpha_composite(img, fshadow)
    
    # 3D Orange Peel Extrusion Thickness
    for fi in range(24, 0, -1):
        fox = fi * 0.45
        foy = fi * 0.85
        pr = int(220 * (1 - fi/24 * 0.5) + 30)
        pg = int(80 * (1 - fi/24 * 0.6) + 10)
        fdraw.ellipse([fcx - fradius + fox, fcy - fradius + foy, fcx + fradius + fox, fcy + fradius + foy], fill=(pr, pg, 0, 255))
        
    # Outer Rind (Vibrant Sunset Orange with 3D rim stroke)
    fdraw.ellipse([fcx - fradius, fcy - fradius, fcx + fradius, fcy + fradius], fill=(255, 120, 0, 255), outline=(255, 195, 60, 255), width=7)
    
    # Inner White Albedo / Pith
    pith_r = fradius - int(W * 0.016)
    fdraw.ellipse([fcx - pith_r, fcy - pith_r, fcx + pith_r, fcy + pith_r], fill=(255, 250, 225, 255))
    
    # Juicy Pulp Ring
    pulp_r = pith_r - int(W * 0.012)
    fdraw.ellipse([fcx - pulp_r, fcy - pulp_r, fcx + pulp_r, fcy + pulp_r], fill=(255, 130, 0, 255))
    
    # 8 Juicy Pulp Segments with 3D bevels
    num_segs = 8
    for s in range(num_segs):
        start_ang = s * (360 / num_segs) + 5
        end_ang = (s + 1) * (360 / num_segs) - 5
        # Main segment pulp
        fdraw.pieslice([fcx - pulp_r, fcy - pulp_r, fcx + pulp_r, fcy + pulp_r], start=start_ang, end=end_ang, fill=(255, 140, 0, 255))
        # Inner radiant juice highlight
        sub_r = pulp_r - int(W * 0.02)
        fdraw.pieslice([fcx - sub_r, fcy - sub_r, fcx + sub_r, fcy + sub_r], start=start_ang + 2, end=end_ang - 2, fill=(255, 185, 25, 245))
        # Micro juice vesicle sparkle
        rad_mid = math.radians((start_ang + end_ang) / 2)
        vx = fcx + int(pulp_r * 0.65 * math.cos(rad_mid))
        vy = fcy + int(pulp_r * 0.65 * math.sin(rad_mid))
        fdraw.ellipse([vx - 5, vy - 5, vx + 5, vy + 5], fill=(255, 230, 100, 230))
        
    # Central White Core
    core_r = int(W * 0.024)
    fdraw.ellipse([fcx - core_r, fcy - core_r, fcx + core_r, fcy + core_r], fill=(255, 252, 235, 255))
    
    # 3D Specular Highlight on Orange Face
    fdraw.arc([fcx - fradius + 10, fcy - fradius + 10, fcx + fradius - 10, fcy + fradius - 10], start=200, end=310, fill=(255, 255, 255, 220), width=6)

    # 3D Natural Smooth Curved Leaf with Stem
    leaf_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ldraw = ImageDraw.Draw(leaf_layer)
    
    # Generate smooth organic leaf curve using parametric bezier points
    def generate_leaf_points(center_x, center_y, leaf_len, angle_deg, fatness=0.45):
        rad = math.radians(angle_deg)
        cos_a = math.cos(rad)
        sin_a = math.sin(rad)
        perp_cos = -sin_a
        perp_sin = cos_a
        
        pts_left = []
        pts_right = []
        steps = 30
        for st in range(steps + 1):
            t = st / steps
            # Base to tip distance
            dist = t * leaf_len
            # Width envelope: 0 at base, max at 0.45, 0 at tip
            w = math.sin(t * math.pi) * (leaf_len * fatness) * (1 - 0.3 * t)
            
            # Centerline position with slight natural S-curve
            curl = math.sin(t * math.pi) * (leaf_len * 0.12)
            bx = center_x + dist * cos_a + curl * perp_cos
            by = center_y + dist * sin_a + curl * perp_sin
            
            pts_left.append((bx + w * perp_cos, by + w * perp_sin))
            pts_right.append((bx - w * perp_cos, by - w * perp_sin))
            
        return pts_left + pts_right[::-1], (center_x, center_y), (center_x + leaf_len * cos_a, center_y + leaf_len * sin_a)

    # Main Fresh Emerald Leaf
    leaf_base_x = fcx + int(fradius * 0.15)
    leaf_base_y = fcy - int(fradius * 0.85)
    main_leaf_pts, base_pt, tip_pt = generate_leaf_points(leaf_base_x, leaf_base_y, int(W * 0.16), -55, 0.48)
    
    # Leaf 3D drop shadow
    for li in range(16, 0, -1):
        lox, loy = li * 0.35, li * 0.75
        l_sh = [(x + lox, y + loy) for (x, y) in main_leaf_pts]
        ldraw.polygon(l_sh, fill=(5, 35, 12, 190))
        
    # Stem: smooth brown-green curve
    stem_pts = [
        (fcx, fcy - int(fradius * 0.75)),
        (leaf_base_x, leaf_base_y)
    ]
    ldraw.line(stem_pts, fill=(100, 160, 50, 255), width=10)
    
    # Leaf Body (Glossy Vibrant Emerald Gradient)
    ldraw.polygon(main_leaf_pts, fill=(35, 205, 85, 255), outline=(150, 255, 175, 250), width=6)
    
    # Upper half highlight on leaf for 3D curved leaf effect
    half_leaf = main_leaf_pts[:len(main_leaf_pts)//2] + [tip_pt, base_pt]
    ldraw.polygon(half_leaf, fill=(60, 235, 115, 140))
    
    # Central Leaf Vein
    ldraw.line([base_pt, tip_pt], fill=(200, 255, 210, 240), width=6)
    
    # Side tiny leaf veins
    for vi in range(1, 5):
        vt = vi / 5.0
        vx = base_pt[0] + (tip_pt[0] - base_pt[0]) * vt
        vy = base_pt[1] + (tip_pt[1] - base_pt[1]) * vt
        ldraw.line([(vx, vy), (vx - 18, vy - 12)], fill=(160, 255, 180, 180), width=3)
        ldraw.line([(vx, vy), (vx + 18, vy + 8)], fill=(160, 255, 180, 180), width=3)
    
    # Glossy Dew Drop on Leaf
    dew_x = int(base_pt[0] + (tip_pt[0] - base_pt[0]) * 0.55)
    dew_y = int(base_pt[1] + (tip_pt[1] - base_pt[1]) * 0.55) - 10
    ldraw.ellipse([dew_x - 14, dew_y - 14, dew_x + 14, dew_y + 14], fill=(255, 255, 255, 210))
    ldraw.ellipse([dew_x - 7, dew_y - 9, dew_x + 3, dew_y - 3], fill=(255, 255, 255, 255))
    
    fruit_layer = Image.alpha_composite(fruit_layer, leaf_layer)
    img = Image.alpha_composite(img, fruit_layer)

    # 7. Sparkling Magic Speed Particles & Cosmic Stars
    sparkle_layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sp_draw = ImageDraw.Draw(sparkle_layer)
    
    def draw_diamond_star(x, y, rad, color=(255, 255, 255, 255)):
        pts = [
            (x, y - rad),
            (x + rad * 0.22, y - rad * 0.22),
            (x + rad, y),
            (x + rad * 0.22, y + rad * 0.22),
            (x, y + rad),
            (x - rad * 0.22, y + rad * 0.22),
            (x - rad, y),
            (x - rad * 0.22, y - rad * 0.22),
        ]
        sp_draw.polygon(pts, fill=color)
        sp_draw.ellipse([x - rad*0.35, y - rad*0.35, x + rad*0.35, y + rad*0.35], fill=(255, 255, 255, 255))
        sp_draw.ellipse([x - rad*1.2, y - rad*1.2, x + rad*1.2, y + rad*1.2], fill=(color[0], color[1], color[2], 60))
        
    # Top-right prominent star
    draw_diamond_star(int(W * 0.83), int(H * 0.17), int(W * 0.052), (255, 245, 170, 255))
    # Mid-left star
    draw_diamond_star(int(W * 0.15), int(H * 0.46), int(W * 0.042), (255, 255, 255, 240))
    # Bottom-left star
    draw_diamond_star(int(W * 0.28), int(H * 0.86), int(W * 0.034), (255, 220, 120, 240))
    # Top-left mini star
    draw_diamond_star(int(W * 0.32), int(H * 0.13), int(W * 0.026), (255, 200, 255, 220))
    
    # Floating glowing orbs
    glowing_orbs = [
        (int(W * 0.17), int(H * 0.25), 14, (255, 180, 50, 180)),
        (int(W * 0.85), int(H * 0.38), 16, (255, 80, 180, 180)),
        (int(W * 0.18), int(H * 0.70), 10, (255, 255, 255, 200)),
        (int(W * 0.88), int(H * 0.58), 12, (255, 150, 40, 190)),
    ]
    for ox, oy, orad, ocol in glowing_orbs:
        sp_draw.ellipse([ox - orad, oy - orad, ox + orad, oy + orad], fill=ocol)
        sp_draw.ellipse([ox - orad*2.5, oy - orad*2.5, ox + orad*2.5, oy + orad*2.5], fill=(ocol[0], ocol[1], ocol[2], 45))
        
    img = Image.alpha_composite(img, sparkle_layer)

    # 8. Luxury Glassmorphic Rim Light & Upper Specular Sheen
    sheen = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    sh_draw = ImageDraw.Draw(sheen)
    sh_draw.ellipse([-W * 0.25, -H * 0.55, W * 1.25, H * 0.48], fill=(255, 255, 255, 26))
    img = Image.alpha_composite(img, sheen)

    # 9. Downsample from 2048x2048 to target size (1024x1024) with Lanczos filtering
    final_icon = img.resize((size, size), Image.Resampling.LANCZOS)
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    rgb_icon = Image.new("RGB", final_icon.size, (20, 3, 35))
    rgb_icon.paste(final_icon, mask=final_icon.split()[3])
    rgb_icon.save(output_path, "PNG", quality=100)
    print(f"✅ Generated 3D App Icon: {output_path} ({size}x{size})")
    
    # Android Adaptive Foreground & Background
    fg_size = size
    fg_img = Image.new("RGBA", (fg_size, fg_size), (0, 0, 0, 0))
    scaled_w = int(fg_size * 0.76)
    scaled_h = int(fg_size * 0.76)
    scaled_center = final_icon.resize((scaled_w, scaled_h), Image.Resampling.LANCZOS)
    fg_offset = (fg_size - scaled_w) // 2
    fg_img.paste(scaled_center, (fg_offset, fg_offset), mask=scaled_center.split()[3])
    fg_path = "assets/icons/app_icon_fg.png"
    fg_img.save(fg_path, "PNG", quality=100)
    print(f"✅ Generated Adaptive Foreground: {fg_path}")

    bg_img = Image.new("RGB", (size, size), (25, 4, 40))
    bg_draw = ImageDraw.Draw(bg_img)
    for y in range(size):
        t = y / size
        r = int(61 * (1 - t*0.8) + 17 * (1 - t))
        g = int(9 * (1 - t*0.8) + 2)
        b = int(89 * (1 - t*0.7) + 28 * (1 - t))
        bg_draw.line([(0, y), (size, y)], fill=(r, g, b))
    bg_path = "assets/icons/app_icon_bg.png"
    bg_img.save(bg_path, "PNG", quality=100)
    print(f"✅ Generated Adaptive Background: {bg_path}")
    
    return rgb_icon

if __name__ == "__main__":
    create_ultra_3d_zesty_icon("assets/icons/app_icon.png", 1024)

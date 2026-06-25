---
title: "Template_Project_Logo"
description: Agent Constitution file
location: .agent/prompts/template_project_logo.md
agent_priority: Standard
last_updated: 2026-06-25
---

# Template Project Logo

[Back to README](../../README.md)

```text
### ROLE: Professional Graphic Designer
### TASK: Create a high-quality, minimalist GitHub Repository Banner

- **DIMENSIONS**: 3.33:1 Aspect Ratio (optimized for 400x120px)
- **COMPOSITION**: Split layout. 
    - Left: A modern, sleek vector icon representing [INSERT THEME, e.g., Cloud Computing].
    - Right: Bold, futuristic sans-serif text reading "[INSERT PROJECT NAME]".
- **STYLE**: Minimalist, High-tech, Flat design, Vector art.
- **COLOR PALETTE**: [INSERT COLORS, e.g., Dark Mode Charcoal with Emerald Green accents].
- **BACKGROUND**: Solid dark aesthetic with subtle, low-opacity geometric patterns (hexagons or grid lines).
- **QUALITY**: 4k resolution, sharp edges, no blur, professional developer UI/UX aesthetic.
- **CONSTRAINTS**: Centered and balanced, clean lines, high contrast for readability on GitHub.
```

---

## 🌐 Two logos per project — always ship BOTH

Every logo lives in **two different boxes**, so produce **two variants** together:

| Target | Shape | File | Why |
|---|---|---|---|
| **GitHub README** | horizontal banner **3.33:1** (~1080×324) | `assets/project_logo_horizontal.(svg\|png)` | icon left + wordmark right |
| **Website (`amirshirali.com`)** | **square 1:1** (1024×1024) | `portfolio/public/logo-<project>.(svg\|png)` | the portfolio renders cards with `aspect-square … object-cover` → a horizontal banner gets **cropped**! |

**Rule:** whenever you design or refresh a GitHub logo, **also produce the square
website variant** (same icon + palette; wordmark below the icon, or icon-only) and
drop it in `portfolio/public/logo-<project>.*`. Keep the two in sync.

### Square website-logo prompt (append to the banner prompt above)
- **DIMENSIONS**: 1:1 square, 1024×1024.
- **COMPOSITION**: icon centered (hero); optional wordmark beneath. Keep safe
  margins so the card's rounded corners / `object-cover` never clip it.
- **CONSISTENCY**: identical icon, palette, and accent as the GitHub banner —
  only the layout/ratio changes.

---
[Back to README](../../README.md)

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**ShroomLab 3D** — static catalogue website for a 3D printing business in Cuddalore, India. No backend, no payments. Customers browse products and order via WhatsApp/Instagram DM. Hosted on GitHub Pages at `https://kumarprem886.github.io/ShroomLab_3D/`.

## Running Locally

```powershell
# Option 1 — Node.js (preferred, no install needed)
cd C:\Users\prem.am.kumar\shroomlab-website
node -e "require('http').createServer((q,s)=>{require('fs').readFile('.'+q.url.replace(/\/$/,'/index.html'),(_,d)=>s.end(d))}).listen(5500)"
# then open http://localhost:5500

# Option 2 — Python
py -m http.server 5500
```

## Deploying

```powershell
cd C:\Users\prem.am.kumar\shroomlab-website
git add index.html admin.html
git commit -m "your message"
git push https://{GITHUB_TOKEN}@github.com/kumarprem886/ShroomLab_3D.git main
# Token is stored separately — ask the user or check local git credentials
```

## Architecture

Two HTML files, fully self-contained (CSS + JS inlined):

### `index.html` — Public catalogue

**Product data** lives in a `const PRODUCTS = [...]` array (~line 447). Each entry is a plain JS object:
```js
{
  title: "Product Name",
  price: "99",           // shown but hidden via CSS (.price-cur { display: none })
  compare_at: "199",     // optional strikethrough price
  cat: "flexi",          // category key — must match a key in BADGE/BADGE_CLASS
  isNew: true,           // optional NEW badge
  icon: "🐾",            // emoji shown when no image is available
  bg: "linear-gradient(...)", // optional gradient background for placeholder
  image: "url",          // single image (string)
  images: ["url1","url2"] // multi-image carousel (array takes priority over image)
}
```

**Adding a new category** requires 5 coordinated edits in `index.html`:
1. Badge CSS: `.badge-{key} { background: #hex; color: #fff; }`
2. Filter button HTML in `.filter-bar`
3. `BADGE` object: `key: 'emoji Label'`
4. `BADGE_CLASS` object: `key: 'badge-key'`
5. `counts` object + `document.getElementById('cnt-{key}')` DOM line

**Image carousel** — `renderCard()` detects `images[]` vs `image` string. For `images.length > 1` it renders a clickable carousel with dot indicators; click calls `cycleImg(el, dir)`.

**Image sources** — Two CDN types are used:
- `makerworld.bblmw.com/makerworld/model/{id}/design/{hash}.{ext}` — MakerWorld renders (not scrapable; Cloudflare-blocked; must copy URL manually from browser)
- `cdn.shopify.com/...` — legacy product images
- `images/filename.jpg` — local files in `images/` folder

**Category keys**: `flexi`, `kit`, `custom`, `home`, `assemble`, `jewellery`, `idols`, `vases`, `keychains`, `namedecor`

### `admin.html` — Product management panel

Accessed at `/admin.html` (linked from nav as "⚙️ Admin"). All state persists in `localStorage`:
- `shroomlab_new_products` — products added via admin
- `shroomlab_new_categories` — custom categories created via admin

**Workflow**: Fill form → save product → use **Export → Products JS** tab to copy generated JS entries → paste into `PRODUCTS` array in `index.html`. If you added a new category, use **Export → New Categories** tab to get the exact CSS/HTML/JS snippets to paste.

**Image upload** compresses via Canvas API (max 900px, JPEG 0.85). Uploaded images must be manually saved to `images/` using the **📥 Download Images** button, then committed.

**Built-in category keys** (hardcoded in `admin.html` `BUILTIN` object — keep in sync with `index.html`): `flexi`, `kit`, `custom`, `home`, `vases`, `jewellery`, `idols`, `assemble`, `keychains`, `namedecor`.

## Key Constraints

- **MakerWorld (makerworld.com) is Cloudflare-blocked** for automated fetching. To get CDN image URLs: open the model page in a real browser → right-click the main image → "Copy image address" → paste into admin panel or directly into `PRODUCTS`.
- Prices are hidden site-wide via `.price-cur { display: none }` and `.price-old { display: none }` — do not remove these rules.
- No build step, no npm, no framework. Edit HTML files directly.
- `products.json` in the repo root is unused — ignore it.

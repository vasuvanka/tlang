# Tlang documentation website

Static documentation site for Tlang. Markdown docs are rendered in the browser; no build step required.

## View locally (with rendered docs)

**Use a local server** so the viewer can fetch `../docs/*.md`:

```bash
# From repo root (required — viewer fetches ../docs/)
python -m http.server 8000
```

Then open **http://localhost:8000/website/** and click any doc link. Or open a doc by URL:

- **http://localhost:8000/website/view.html?doc=getting-started**
- **http://localhost:8000/website/view.html?doc=libraries/fmt**

You can also use `?file=` or `?path=` (e.g. `view.html?path=docs/language-reference`).

## View without server (links only)

Opening `website/index.html` or `website/docs.html` via `file://` works for the index and doc list, but **view.html** will not load markdown (fetch to `../docs/` fails under file protocol). Use a local server to get rendered docs.

## Deploy on GitHub Pages

1. **Enable GitHub Pages (required first):** Go to [**Settings → Pages**](https://github.com/vasuvanka/tlang/settings/pages). Under **Build and deployment**, set **Source** to **GitHub Actions** (not "Deploy from a branch"). Save. If this isn’t done, the deploy job will fail with a 404.
2. Push to `main` (or `dev`). The workflow [`.github/workflows/deploy-pages.yml`](../.github/workflows/deploy-pages.yml) builds the site (website + `docs/` as `docs/`) and deploys it.
3. The site will be at **https://vasuvanka.github.io/tlang/** (repo: [github.com/vasuvanka/tlang](https://github.com/vasuvanka/tlang)). Doc viewer and MD rendering work there; internal doc links open in the viewer.

To deploy only from `main`, edit the workflow and change the `on.push.branches` and the `deploy` job `if` to reference only `main`.

## Contents

- **index.html** — Landing: hero, quick start, features, philosophy.
- **docs.html** — Documentation index; every link opens the doc in the viewer.
- **view.html** — Renders a single doc: `?doc=getting-started` or `?doc=libraries/fmt`. Uses [marked](https://marked.js.org/) to convert Markdown to HTML. Internal `.md` links in the doc are rewritten to open in the viewer. The doc fetch path works both locally (from `/website/` → `../docs/`) and on GitHub Pages (→ `docs/`).
- **styles.css** — Typography, layout, and prose (rendered markdown) styles.

# MSc thesis manuscript

*High-Performance Patch-Match Multi-View Stereo: Separating Algorithmic Cost
from Implementation Overhead* — MSc thesis, Computer Science, Eötvös Loránd
University, Faculty of Informatics, 2026.

This repository holds the manuscript, written in [Typst](https://typst.app).
It is a submodule of the thesis monorepo, whose `benchmark/` directory produces
the measurements and generated tables quoted here.

## Layout

| Path | Content |
|---|---|
| `main.typ` | entry point: metadata, front matter, chapters, back matter |
| `chapters/*.typ` | the chapters |
| `my_thesis.bib` | bibliography (BibTeX) |
| `generated/` | tables generated in the superproject (see below); never edited by hand |
| `images/` | figures; `elte_cimer_szines.pdf` is the ELTE logo |
| `template/` | the ELTE FI thesis template (Typst port of elteikthesis, see below) |
| `template/fonts/` | Latin Modern fonts used by the template |

## Build

Requires **Typst 0.15.1** (`typst --version`).

```sh
make build    # main.typ -> build/thesis.pdf
make watch    # recompile on every change
make clean    # remove build/thesis.pdf
```

The template uses the Latin Modern fonts in `template/fonts/`, so every Typst
call needs `--font-path template/fonts`; the Makefile passes it. Without it,
Typst warns about unknown font families and falls back to New Computer Modern.
For direct CLI use, `export TYPST_FONT_PATHS=template/fonts` has the same effect.

### Editor setup (Tinymist)

With the [Tinymist](https://github.com/Myriad-Dreamin/tinymist) language server
(VS Code extension "Tinymist Typst", or any LSP client), point it at the
fonts and the entry file, e.g. in `.vscode/settings.json`:

```json
{
  "tinymist.fontPaths": ["${workspaceFolder}/template/fonts"],
  "tinymist.systemFonts": false
}
```

Open `main.typ` and pin it as the main file ("Typst: Pin the main file") so
previews of chapter files render the whole document.

## Template

`template/elteikthesis.typ` is a Typst port of the LaTeX class
[mcserep/elteikthesis](https://github.com/mcserep/elteikthesis) v2.4
(tag `v2.4`, commit `4f0162d9b7`), © 2013–2024 Máté Cserép, Bálint Bognár.
It reproduces the class's page layout, headings, running header, contents and
lists, captions, theorem-like environments, todo notes, title page and
bibliography style, in English and Hungarian (`lang: "en" | "hu"`), with the
class options `parspace`, `noindent`, `nohyp`, `twoside`, `draft` and
`final`. The function signature and helpers are documented at the top of
`template/elteikthesis.typ`.

The port was checked page by page against the upstream example PDFs. The
ported example documents (`elteikthesis_en.typ`, `elteikthesis_hu.typ` and
their `samples_*` chapters) were added in commit `1a915c0` and removed again
when this repository became thesis-only; their last version is in the parent
of the commit that removed them. The upstream repository has the original
LaTeX examples.

Title-page lines that are too long (department, supervisor, affiliation) run
into the margin, as in LaTeX; break them by hand with `\`.

## Generated tables

Tables in `generated/` come from the superproject and are never edited here:

- `deviations.*` and `methods-provenance.*` — from the method manifest and the
  forks: `uv run deviations render` (in the superproject's `benchmark/`).
- `results-<campaign>-*` — from a campaign's result store:
  `uv run python -m report render <campaign dir>`. These are git-ignored by
  `generated/.gitignore` and committed deliberately (`git add -f`) only for the
  campaign the thesis quotes.

Workflow: render in the superproject, commit the files here, then bump this
submodule in the superproject.

## Licences

- Template (`template/`, except fonts): MIT, see `LICENSE`.
- Fonts (`template/fonts/`): Latin Modern, GUST Font License (LPPL 1.3c),
  see `template/fonts/GUST-FONT-LICENSE.txt` and `template/fonts/README.txt`.
- ELTE logo: shipped with the upstream template (as `elte_cimer_szines.eps`);
  the PDF here is a vector conversion of it.

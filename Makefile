# Typst build of the thesis. Requires Typst 0.15.1 (`typst --version`).
TYPST ?= typst
# Latin Modern fonts shipped with the template (GUST Font License)
TYPSTFLAGS = --font-path template/fonts

.PHONY: build build-examples watch clean latex

build:
	mkdir -p build
	$(TYPST) compile $(TYPSTFLAGS) main.typ build/thesis.pdf

# The example documents of the template (port of elteikthesis v2.4).
build-examples:
	mkdir -p build
	$(TYPST) compile $(TYPSTFLAGS) elteikthesis_en.typ build/elteikthesis_en.pdf
	$(TYPST) compile $(TYPSTFLAGS) elteikthesis_hu.typ build/elteikthesis_hu.pdf

watch:
	mkdir -p build
	$(TYPST) watch $(TYPSTFLAGS) main.typ build/thesis.pdf

# Removes only the Typst outputs; other files in build/ are left alone.
clean:
	rm -f build/thesis.pdf build/elteikthesis_en.pdf build/elteikthesis_hu.pdf

# Legacy LaTeX build (kept until the LaTeX sources are removed).
latex: my_thesis.tex
	mkdir -p build
	pdflatex -halt-on-error -output-directory build my_thesis.tex

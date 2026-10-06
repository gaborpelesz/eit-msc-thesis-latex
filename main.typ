// MSc thesis — entry point (ported from the former LaTeX my_thesis.tex).
// Build: `make build` (Typst 0.15.1) -> build/thesis.pdf

// official ELTE IK thesis template ported from LaTeX to Typst
// https://github.com/mcserep/elteikthesis
#import "template/elteikthesis.typ": *

#show: elteikthesis.with(
  // class options as ported from the original repo (see the parameters of `elteikthesis`):
  // parspace: true,  // adds vertical space between paragraphs
  // noindent: true,  // no indentation of first lines in each paragraph, use with parspace
  // nohyp: true,     // no hyphenation of words, probably never use
  // twoside: true,   // double sided format
  // draft: true,     // quicker draft compilation without rendering images, this doesn't matter in Typst as it is already fast
  // final: true,     // set final to hide todos

  // Document's metadata
  title: [High-Performance Patch-Match \ Multi-View Stereo: Separating Algorithmic Cost from Implementation Overhead],
  year: [2026], // year of defense

  // Author's metadata
  author: [Gabor Pelesz],
  degree: [Autonomous Systems MSc],

  // Supervisor(s)' metadata
  supervisor: [Adam Istvan Szucs], // internal supervisor's name
  affiliation: [[SUPERVISOR AFFILIATION]], // internal supervisor's affiliation
  // ext-supervisor: [[EXTERNAL SUPERVISOR NAME]], // external supervisor's name
  // ext-affiliation: [[EXTERNAL SUPERVISOR AFFILIATION]], // external supervisor's affiliation

  // University's metadata
  university: [Eötvös Loránd University],
  faculty: [Faculty of Informatics],
  city: [Budapest],
  logo: image("images/elte_cimer_szines.pdf"),

  lang: "en",

  // Topic declaration page (mandatory) - can also be attached instead
  // declaration: include-pdf(read("topicdeclaration.pdf", encoding: none)),
)

// List of todos (not in the final document)
// #list-of-todos()

// Main content
#include "chapters/benchmarks.typ"
// Not included in the LaTeX build (of the author's chapters, my_thesis.tex input only benchmarks.tex);
// whether to include it is the author's decision.
#include "chapters/mvs_methods.typ"

// Acknowledgements (optional)
#heading(numbering: none)[#tr("acknowledgements")]
#todo(inline: true)[Acknowledgements: to be written by the author.]

// Appendices (optional)
#show: appendix
// #include "chapters/<appendix>.typ"

// Bibliography (mandatory)
#bibliography("thesis.bib")

// List of figures (optional)
#list-of-figures()

// List of tables (optional)
#list-of-tables()

// List of algorithms (optional)
// #list-of-algorithms()

// List of codes (optional)
// #list-of-codes()

// List of symbols (optional)
// #print-nomenclature()

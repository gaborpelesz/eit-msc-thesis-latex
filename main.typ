// MSc thesis — entry point (Typst port of my_thesis.tex).
// Build: `make build` (Typst 0.15.1) -> build/thesis.pdf
#import "template/elteikthesis.typ": *

#show: elteikthesis.with(
  // Class options (see the parameters of `elteikthesis`):
  // parspace: true,  // Add vertical space between paragraphs
  // noindent: true,  // No indentation of first lines in each paragraph
  // nohyp: true,     // No hyphenation of words
  // twoside: true,   // Double sided format
  // draft: true,     // Quicker draft compilation without rendering images
  // final: true,     // Set final to hide todos

  // Document's metadata
  title: [High-Performance Patch-Match Multi-View Stereo: Separating Algorithmic Cost from Implementation Overhead],
  year: [2026], // year of defense

  // Author's metadata
  author: [[AUTHOR NAME]],
  degree: [Computer Science MSc],

  // Supervisor(s)' metadata
  supervisor: [[SUPERVISOR NAME]], // internal supervisor's name
  affiliation: [[SUPERVISOR AFFILIATION]], // internal supervisor's affiliation
  // ext-supervisor: [[EXTERNAL SUPERVISOR NAME]], // external supervisor's name
  // ext-affiliation: [[EXTERNAL SUPERVISOR AFFILIATION]], // external supervisor's affiliation

  // University's metadata
  university: [Eötvös Loránd University],
  faculty: [Faculty of Informatics],
  department: [[DEPARTMENT]],
  city: [Budapest],
  logo: image("images/elte_cimer_szines.pdf"),

  lang: "en",

  // Topic declaration page (mandatory) - can also be attached instead
  // declaration: include-pdf(read("topicdeclaration.pdf", encoding: none)),
)

// List of todos (not in the final document)
// #list-of-todos()

// Main content
// #include "chapters/<chapter>.typ"

// Acknowledgements (optional)
#heading(numbering: none)[#tr("acknowledgements")]
#todo(inline: true)[Acknowledgements: to be written by the author.]

// Appendices (optional)
#show: appendix
// #include "chapters/<appendix>.typ"

// Bibliography (mandatory)
#bibliography("my_thesis.bib")

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

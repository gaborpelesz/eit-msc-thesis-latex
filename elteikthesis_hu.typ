// Example document of the Typst port of elteikthesis v2.4 (Hungarian).
// Ported from elteikthesis_hu.tex of mcserep/elteikthesis v2.4.
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
  title: [Dolgozat címe], // title
  year: [2024], // year of defense

  // Author's metadata
  author: "Hallgató Hanga",
  degree: [programtervező informatikus BSc],

  // Superivsor(s)' metadata
  supervisor: [Témavezető Tamás], // internal supervisor's name
  affiliation: [egyetemi tanársegéd], // internal supervisor's affiliation
  // ext-supervisor: [Külső Kornél], // external supervisor's name
  // ext-affiliation: [informatikai igazgató], // external supervisor's affiliation

  // University's metadata
  university: [Eötvös Loránd Tudományegyetem], // university's name
  faculty: [Informatikai Kar], // faculty's name
  department: [Programozáselmélet és Szoftvertechnológiai \ Tanszék], // department's name
  city: [Budapest], // city
  logo: image("images/elte_cimer_szines.pdf"), // logo

  // Set document language
  lang: "hu",
  // lang: "en",

  // Topic declaration page (mandatory) - can also be attached instead
  // declaration: include-pdf(read("temabejelento.pdf", encoding: none)),
)

// List of todos (not in the final document)
// #list-of-todos()

// Main content
#include "samples_hu/intro.typ"
#include "samples_hu/user.typ"
#include "samples_hu/impl.typ"
#include "samples_hu/sum.typ"

// Acknowledgements (optional) - in case your thesis received funding or would like to express special thanks to someone
#heading(numbering: none)[#tr("acknowledgements")]
Amennyiben a szakdolgozati / diplomamunka projekted pénzügyi támogatást kapott egy projektből vagy az egyetemtől, jellemzően kötelező feltüntetni a dolgozatban is. A dolgozat elkészítéséhez segítséget nyújtó oktatók, hallgatótársak, kollégák felé is nyilvánítható külön köszönet.

// Appendices (optional) - useful for detailed information in long tables, many and/or large figures, etc.
#show: appendix
#include "samples_hu/sim.typ"

// Bibliography (mandatory)
#bibliography("elteikthesis.bib")

// List of figures (optional) - useful over 3-5 figures
#list-of-figures()

// List of tables (optional) - useful over 3-5 tables
#list-of-tables()

// List of algorithms (optional) - useful over 3-5 algorithms
#list-of-algorithms()

// List of codes (optional) - useful over 3-5 code samples
#list-of-codes()

// List of symbols (optional)
// #print-nomenclature()

// Example document of the Typst port of elteikthesis v2.4 (English).
// Ported from elteikthesis_en.tex of mcserep/elteikthesis v2.4.
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
  title: [Title of the thesis], // title
  year: [2024], // year of defense

  // Author's metadata
  author: "John Smith",
  degree: [Computer Science BSc],

  // Superivsor(s)' metadata
  supervisor: [John Doe], // internal supervisor's name
  affiliation: [Assistant Lecturer], // internal supervisor's affiliation
  // ext-supervisor: [Jane Doe], // external supervisor's name
  // ext-affiliation: [Senior Developer], // external supervisor's affiliation

  // University's metadata
  university: [Eötvös Loránd University], // university's name
  faculty: [Faculty of Informatics], // faculty's name
  department: [Dept. of Software Technology and Methodology], // department's name
  city: [Budapest], // city
  logo: image("images/elte_cimer_szines.pdf"), // logo

  // Set document language
  // lang: "hu",
  lang: "en",

  // Topic declaration page (mandatory) - can also be attached instead
  // declaration: include-pdf(read("topicdeclaration.pdf", encoding: none)),
)

// List of todos (not in the final document)
// #list-of-todos()

// Main content
#include "samples_en/intro.typ"
#include "samples_en/user.typ"
#include "samples_en/impl.typ"
#include "samples_en/sum.typ"

// Acknowledgements (optional) - in case your thesis received funding or would like to express special thanks to someone
#heading(numbering: none)[#tr("acknowledgements")]
In case your thesis received financial support from a project or the university, it is usually required to indicate the proper attribution in the thesis itself. Special thanks can also be expressed towards teachers, fellow students and colleagues who helped you in the process of creating your thesis.

// Appendices (optional) - useful for detailed information in long tables, many and/or large figures, etc.
#show: appendix
#include "samples_en/sim.typ"

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

// MSc thesis — entry point (ported from the former LaTeX my_thesis.tex).
// Build: `make build` (Typst 0.15.1) -> build/thesis.pdf

// official ELTE IK thesis template ported from LaTeX to Typst
// https://github.com/mcserep/elteikthesis
#import "template/elteikthesis.typ": *

#show: elteikthesis.with(
  // class options as ported from the original repo (see the parameters of `elteikthesis`):
  parspace: true,  // adds vertical space between paragraphs
  noindent: true,  // no indentation of first lines in each paragraph, use with parspace
  // nohyp: true,     // no hyphenation of words, probably never use
  // twoside: true,   // double sided format
  // draft: true,     // quicker draft compilation without rendering images, this doesn't matter in Typst as it is already fast
  // final: true,     // set final to hide todos
  revision: sys.inputs.at("rev", default: none), // build stamp, passed by the Makefile and CI

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
// #include "chapters/benchmarks.typ"
// Not included in the LaTeX build (of the author's chapters, my_thesis.tex input only benchmarks.tex);
// whether to include it is the author's decision.
// #include "chapters/mvs_methods.typ"


= Introduction

problem formulation, claims, RQs, contributions from thesis itself and how the thesis is structured

(budget 4 pages)

= Background

// | Background (MVS, PatchMatch, GPU model, ETH3D metrics) | 7 |

short 3D reconstruction and Dense MVS intro, contains the formulation of patch match algorithm and focuses on early patch match implementaion. Also intros the general structure of MVS programs and ETH3D as a benchmarking target.

make sure we include enough GPU and performance optimization background to cover methodology and results sections. Especially considering the deep analysis.

(budget 7 pages)


= Literature review

describes the lineage and selected methods that the thesis considers. shows and analyzes the algorithmic improvements and what added costs these have. Also analyzes the software source code a bit.

also include
- prior optimizaiton work on CUMVS -> third-party evidence that optimization headroom exists
- lineage and code sharing evidence
- maybe cost of each improvement (referring to the later benchmarking section)

watch out for this not to blow up! we have a lot of methods, and deeply analysing all of them can take a lot of time. The focus should be on the methodology and the results sections instead of this!
- consider analysing only a few key papers, and mentioning others that are less relevant
  - acm family
  - APD-MVS
  - HPM-MVS
  - (maybe MP-MVS or DPE-MVS)


#include "chapters/methodology.typ"


= Results & Discussion

/*
showing and analysing benchmarking results. showing selected method and some deep analyses results (e.g., cuda kernels occupancy etc.)
demonstrate our own implementation that fixes issues
*/

3. Can a systematically engineered, production-grade reimplementation of a recent state-of-the-art method recover a substantial fraction of the runtime and memory cost while preserving its benchmark accuracy?
  - can we find a single change in a lineage shared kernel part (for example in the ACM family) that if we improve, it would improve the perf of all lineage items?

== Preparing for the benchmarking, Findings

1. all nine methods (ACM-family, two HPM, APD, DPE) ship converters that look for `.jpg` images in a case-sensitive manner while ETH3D downloaded images are `*.JPG` with upper-case. Because of this, the converter decodes and re-encodes every image using OpenCV's default JPEG quality, 95. The re-encode changes 46-59% of pixels at 46-50 dB PSNR.
  - CUMVS reads original images and it doesn't re-encode


== Benchmarking

// put the full benchmark result tables in the appendix




= Conclusion

/*
should answer the RQs directly, say what the work can't claim and list of future work
1. To what extent is the performance decline across successive patch-match MVS algorithms attributable to genuine algorithmic complexity versus inherited implementation inefficiency?
2. Which implementation-level factors (memory access patterns, GPU occupancy, redundant computation, data layout, host-device transfers) contribute most to the performance gap in existing reference implementations?
3. Can a systematically engineered, production-grade reimplementation of a recent state-of-the-art method recover a substantial fraction of the runtime and memory cost while preserving its benchmark accuracy?
4. What software engineering and performance optimization practices should the MVS research community adopt to prevent the continued accumulation of avoidable overhead in future methods?
*/

// Acknowledgements (optional)
// #heading(numbering: none)[#tr("acknowledgements")]
// #todo(inline: true)[Acknowledgements: to be written by the author.]

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

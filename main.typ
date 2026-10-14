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

= Methodology #todo[FOCUS ON THIS FIRST]

/*
types of research methodologies:
- quantitative
  - controlled benchmarking & experimental CS
  - empirical performance analysis
- qualitative
  - A/B testing, empirical case studies, content analysis, interviews and think-aloud protocols
- mixed methods
  - start by qualitative, develop a tool and method and perform quantitative
*/

methodology / RQ:
- RQ1
  - main methodology: quantitative experimental (benchmarks) / deductive, math proofs (time complexity math maybe)
  - define the algorithmic complexity for main algorithms, see whether their implementation performs according to this complexity model. We can understand how many operations we need to perform the specific task, and see how many operations with ended up needing in order to execute it (maybe)
  - we need to find and show a single (or multiple) implementation inefficiency in one of the early methods, that other methods inherit and don't change
    - this could be extended with bugs, like if the early method has a bug that the later method inherits
  - there is a big assumption here: "... performance *decline* across successive patch-match MVS algorithms ..."
    - this we need to answer with the controlled benchmarking that we did.
- RQ2
  - having found inefficiencies, describe why are they inefficient with specifics
  - controlled benchmarking is one tool that we will use here
- RQ3
  - answer by showing
  - then controlled benchmarking to prove the point
- RQ4
  - main methodology: Mixed Methods / Qualitative (try to get this from existing research instead of providing something new as we don't have time for this!)
  - they should detail the complexity of their algorithm in their research paper, or have a section that focusing on runtime performance. They should also describe their hardware better. Today what they have is very superficial. They should also detail more how they were carrying out performance evaluations and comparing to other methods. Let's see the benchmarks but I think their measured performance is barely reproducible. Also they should detail the parameters they were using when carrying out the measurements, or if they are getting measurements for other methods then how did they gather those.
    - Maybe find some papers that are good in terms of describing their performance characteristics
  - software engineering:
    - clean specified interface design
    - modularize to fit into existing systems, e.g.,
      - CUMVS provides an OpenCV interface so it is easy to integrate into OpenCV projects
      - why having a separate Python converter? Why not parse the COLMAP immediately? (CUMVS does this as well)
    - why bury parameters inside the source code that are not exposed and can't be turned?
    - common software engineering smells: main.h, hardcoded variables, etc.
  - methodology (maybe):
    - Systematic Literature Reviews

the methodology section mainly contains the following in some way:
- benchmarking
- selected method deep analysis
- own implementation that shows and demosntrates improvements

// TEXT COMES AFTER
#line(length: 100%)

== Benchmarking the state-of-the-art

The work starts with a comprehensive benchmarking of the selected methods. We have chosen 12 methods to evaluate in total. The selected methods contain the
- TSAR-MVS: a different approach than the ACM-family
- ACM-family (ACMH, ACMP, ACMM, ACMMP): core cited methods successors are building upon
- APD-MVS, HPM-MVS, and MP-MVS: three major work on top of the ACM-family, choosing different approach to improve the results
- APDe-MVS, DPE-MVS, DVP-MVS, TSAR-MVS: APD-MVS successors extending the lineage
- HPM-MVS++: HPM-MVS successors
- CUMVS: a reimplementation of the ACM-family, focusing on performance and production quality

These algorithms were chosen because of three important reasons. They are all:
- building on the same concepts of Patch-Match-based stereo reconstruction,
- top-performers on the ETH3D leaderboard and are highly cited by each other,
- providing access to an open-source implementation on Github.


=== Configurations

// author vs norm10, describe what each is, argue why we need both

All of these algorithm provide some level of quality and performance metrics in their papers. The algorithms are building on the same algorithmic blocks with the same or similar parameters to configure. However, each of them select different parameter settings when evaluating there own algorithms. It is unclear what they are comparing themselves against, when they are evaluating their algorithm to other algorithms. Thus the benchmark will consider two settings: _author_, and _norm10_.

#todo[table with the settings: for each algorithm what does author and what does norm10 mean?]

=== Benchmark metrics

what are we measuring?
- ETH3D metrics: accuracy, completeness, F1-score
- External measurements:
  - ...
- instrumentation for MVS algorithm phases
  - which phases?
    - 
  - what do these measure?
    - common `bench_timer.h`
    - 


=== Benchmark settings

- benchmarking hardware details
- variance measurements

// What are we measuring and why?
// variance (repeat=2)
// - hardware binding for the benchmarks, with locking the GPU clock

=== Deviations (open-source forks)

// fork deviations -> I made some forks, I had to patch many of them, so I have to describe what I patched. Generated deviations table into the appendix.
// separated timings for the common section
- injected `bench_timer.h` for phase-level measurements

== Runtime decomposition, algorithmic cost, and analysis



== Own implementation Quorum MVS...

focus on production implementation considerations, plus performance considerations

= Results & Discussion


/*
showing and analysing benchmarking results. showing selected method and some deep analyses results (e.g., cuda kernels occupancy etc.)
demonstrate our own implementation that fixes issues
*/

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

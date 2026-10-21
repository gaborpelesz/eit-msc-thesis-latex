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
- ACM-family (ACMH, ACMP, ACMM, ACMMP): core cited methods successors are building upon
- APD-MVS, HPM-MVS, and MP-MVS: three major work on top of the ACM-family, choosing different approach to improve the results
- APDe-MVS, DPE-MVS, DVP-MVS: APD-MVS successors extending the lineage
- HPM-MVS++: HPM-MVS successors
- TSAR-MVS: a different approach than the ACM-family
- CUMVS: a reimplementation of the ACM-family #todo("which ACM method exactly?"), focusing on performance and production quality

These algorithms were chosen because of three important reasons. They are all:
- building on the same concepts of Patch-Match-based stereo reconstruction,
- top-performers on the ETH3D leaderboard and are highly cited by each other,
- providing access to an open-source implementation on Github.


=== Configuration

// author vs norm10, describe what each is, argue why we need both

==== dataset & input resolution

All 13 scenes from the ETH3D high-resolution dataset are included in the benchmark. The dataset consists of indoor and outdoor scenes, with 7 scenes having uniform-sized images and 6 scenes includes mixed-sized images. The APD-MVS and DPE-MVS author implementations handle the mixed-sized images in the converter by zero-padding the images to a uniform size.

From an algorithm evaluation perspective, it is interesting to observe the behavior of the implementations at lower resolutions than native to see how they react to them. Generally, production-grade scanning systems produce a stream of images at lower resolutions than they are captured in ETH3D. Otherwise, 3D reconstruction softwares usually provide the ability (either implicitly or explicitly) to rescale the images to a lower resolution to make the MVS step faster. Thus, apart from the native resolution, the benchmark defines two downsampled variants at half (3200px width) and at quarter (1600px width) the resolution of the original images (around 6200px width). The benchmarking system handles the rescaling while preparing the ETH3D dataset, using a JPEG q100 4:4:4 re-encoding with Hamming windows for anti-aliasing.

==== repeats and order

randomized order, with 2 repeats #todo("why two repeats, provide reasoning ")

==== algorithm free-parameters

All of these algorithm provide some level of quality and performance metrics in their papers. The algorithms are building on the same algorithmic blocks with the same or similar parameters to configure. The thesis aims at a globally consistent setting for shared free-parameters, and aims to incorporate any values from the papers where those values has been explicitly stated by the authors. When selecting a global configuration for a fair benchmarking, the paper stated values has to be cross-verified with their implementations and any deviation from the implementation has to be stated for reproducibility. For the benchmarking, explicitly stated values in the papers will override any deviation in implementation defaults.

#todo[table with the free-parameters and their settings]

- resolution
- no methods states explicitly in its paper, but the maximum number of source views is set to 20 for all methods. Only a single method #todo("which one") states that they are using max source views to be 10 for their runtime measurements. It is not stated why.
-

==== measurement hardware

When selecting hardware for the benchmarking, the most important component for MVS evaluations is the GPU. DVP-MVS paper claims that a mainstream GPU has 24GB VRAM. This thesis does not agree with this statement. All methods are built using CUDA kernels so they vendor lock NVidia hardware. The only GPUs that have at least 24GB VRAM are the top consumer GPUs (3090, 4090, 5090) or workstation-grade alternatives. Most companies favor more affordable consumer GPUs for example 5070, or 5080 for production grade company clusters with 12GB-16GB VRAM. Especially for MVS, where for the traditional algorithms more compute can outweigh more VRAM, companies would probably choose two 5070 cards instead of a single 5080 #todo("lot of claims, any sources?"). 

The benchmarking system uses Nvidia 5070 GPU with 12GB VRAM. The benchmark explicitly states out-of-memory crash states. For CPU, the system uses an AMD Ryzen 9 9950X3D 16-Core Processor and a Samsung SSD 990 EVO Plus 4TB for storage. The machine has 192GB DDR5 RAM.

- variance measurements

// What are we measuring and why?
// variance (repeat=2)
// - hardware binding for the benchmarks, with locking the GPU clock



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


=== Deviations (open-source forks)

// fork deviations -> I made some forks, I had to patch many of them, so I have to describe what I patched. Generated deviations table into the appendix.
// separated timings for the common section
- injected `bench_timer.h` for phase-level measurements
- Added synchronization to CUMVS after every kernel call, measured that it only adds \~0.9sec to the whole runtime so it is negligible

== Runtime decomposition, algorithmic cost, and analysis



== Own implementation Quorum MVS...

focus on production implementation considerations, plus performance considerations

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

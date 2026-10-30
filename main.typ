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

= Introduction



- photogrammetry, image-based 3d reconstruction, is very popular and hot topic
  - 3D reconstruction and perception is a foundational problem in computer vision driving multiple industries and problem spaces such as robotics, manufacturing, healthcare, automotive, logistics and warehousing, agriculture, and more recently construction, surveying, and geomatics. In the recent years, photogrammetry (image-based 3D reconstruction and measurements) has been gaining interest. Regular colored images contain vast amount of information, are very accessible and cheap, easy to understand by humans.
- Multi-View Stereo (MVS) produces highly accurate and dense point clouds
- the problem of MVS is the amount of data it has to process
- this is a problem in highly accurate and/or large-scale 3D reconstruction (with faster algorithms, 3D models could become higher quality because the reconstruction could use higher resolution images or more sophisticated algorithms to improve point accuracy)
- early 3D reconstruction algorithms were inefficient because they were using large cost-volumes to store costs for the optimization problem. Grid-based (Voxel-based) 3D reconstruction can work in large-scale but it produces low quality results. Also MVS problems require going through all pixels in all images and matching that with other pixels in other images which is a really compute-intensive task. with the huge leaps in GPU technology in the last decade there has been a great demand for highly parallel MVS algorithms that can map to GPUs efficiently. But GPUs generally have limitations on the amount of memory that they can utilize thus limiting the scale of the 3D reconstruction problem.
- in year X, Y introduced the PatchMatch algorithm, then they implemented a parallel version of this algorithm that could paralellize across 1 axis of images at the time, doing sweeps.
- Then Gipuma, a paper with great focus on PatchMatch efficiency, introduced the checkerboard propagation which created a highly efficient MVS algorithm.
- Another important event was that they introduced ETH3D dataset which created an easy way to measure algorithmic performance and with it, and with this dataset, dozens of algorithms were released with papers competing with each other on the benchmarks.
- The benchmarks doesn't measure and score algorithmic or implementation efficiency so the contenders started to tweak the original Gipuma algorithm further and further with introducing more and more constraints into the algorithm, leading to higher quality in the benchmarks but also making them infeasible in production-grade large-scale photogrammetry problems.
- The thesis claims that many of the algorithms slowness comes from implementation inefficiency inherited from the lineage of the developing algorithm family.

----------------------------------------

problem formulation, claims, RQs, contributions from thesis itself and how the thesis is structured

(budget 4 pages)

==== RQ1
To what extent is the performance decline across successive patch-match MVS algorithms attributable to genuine algorithmic complexity versus inherited implementation inefficiency?

==== RQ2
Which implementation-level factors (memory access patterns, GPU occupancy, redundant computation, data layout, host-device transfers) contribute most to the performance gap in existing reference implementations?

==== RQ3
Can a systematically engineered, production-grade reimplementation of a recent state-of-the-art method recover a substantial fraction of the runtime and memory cost while preserving its benchmark accuracy?

==== RQ4
What software engineering and performance optimization practices should the MVS research community adopt to prevent the continued accumulation of avoidable overhead in future methods?


= Background

// | Background (MVS, PatchMatch, GPU model, ETH3D metrics) | 7 |

/*
short 3D reconstruction and Dense MVS intro, contains the formulation of patch match algorithm and focuses on early patch match implementaion. Also intros the general structure of MVS programs and ETH3D as a benchmarking target.

make sure we include enough GPU and performance optimization background to cover methodology and results sections. Especially considering the deep analysis.

(budget 7 pages)
*/

The goal of 3D reconstruction is to recover consistent 3D structural information of a scene or a 3D model of specific objects, from multiple 2D sources such as images, depth maps, and active sensing approaches such as structured light, time-of-flight sensors, or directly from range measurements (LiDAR).

Photogrammetry defines the approach to recover 3D information and measurements mainly from imagery. A traditional photogrammetry-based 3D reconstruction pipeline obtains a 3D representation from multiple images captured by a set of uncalibrated imaging devices and consists of two major steps:
- Pose estimation: finding the instrinsic and extrinsic (relative position and orientation) calibration of the imaging devices from a set of images. @hartley_zisserman_mvg
- Dense reconstruction: creating a dense representation of the scene, such as point clouds, mesh models, and volumetric representations (voxel grids).

In this work we are focusing on _Multi-View Stereo_ (MVS) dense reconstruction. Given a set of calibrated cameras and images observing the same scene from different view points, use stereopsis to find 3D depth information for image pixels.





--- notes:
- Multi-view Stereo (MVS) problem formulation, approaches, depth map estimation, point cloud fusion
- the Patch-Match algorithm description, sweeping, acceleration with checkerboard pattern


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

/*
showing and analysing benchmarking results. showing selected method and some deep analyses results (e.g., cuda kernels occupancy etc.)
demonstrate our own implementation that fixes issues
*/
#include "chapters/results.typ"


= Conclusion

/*
should answer the RQs directly, say what the work can't claim and list of future work
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

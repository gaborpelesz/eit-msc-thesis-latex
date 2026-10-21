#import "../template/elteikthesis.typ": *

= Methodology

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

==== dataset & input resolution

There are many influential benchmarks in the field of 3D reconstruction all of them serving a different purpose. The Middlebury dataset @middleburry_dataset has been the foundational work in creating a structured framework for evaulating two-view stereo algorithm. Middleburry is dataset for the initial patch-match work and was published for two-view stereo problems to calculate disparity maps #todo[cite reference]. DTU MVS dataset @dtu_dataset was established for robotics and it provides no leaderboard to find MVS algorithms and their performance. ETH3D @eth3d_dataset is dataset with natural, large-scale scenes, high-resolution images, and provided ground-truth image poses to directly evaluate Multi-View stereo algorithms for pointcloud reconstruction. It has a good leaderboard, showing many SOTA MVS methods. Tanks and Temples @tanks_and_temples_dataset focuses on full 3D pipeline evaluation thus an evaluation requires camera pose estimation as the first step. It also provides a good leaderboard with many SOTA MVS methods.

ETH3D has been selected as the evaluation dataset for this thesis because
- it focuses directly on MVS
- many algorithm choose this dataset as their primary target for benchmarking
- convenient evaluation scripts are available

All 13 scenes from the ETH3D high-resolution dataset are included in the benchmark. The dataset consists of indoor and outdoor scenes, with 7 scenes having uniform-sized images and 6 scenes includes mixed-sized images. The APD-MVS and DPE-MVS author implementations handle the mixed-sized images in the converter by zero-padding the images to a uniform size.

From an algorithm evaluation perspective, it is interesting to observe the behavior of the implementations at lower resolutions than native to see how they react to them. Generally, production-grade scanning systems produce a stream of images at lower resolutions than they are captured in ETH3D. Otherwise, 3D reconstruction softwares usually provide the ability (either implicitly or explicitly) to rescale the images to a lower resolution to make the MVS step faster. Thus, apart from the native resolution, the benchmark defines two downsampled variants at half (3200px width) and at quarter (1600px width) the resolution of the original images (around 6200px width). The benchmarking system handles the rescaling while preparing the ETH3D dataset, using a JPEG q100 4:4:4 re-encoding with Hamming windows for anti-aliasing.

==== repeats and order

randomized order, with 2 repeats #todo("why two repeats, provide reasoning ")
- variance measurements

==== algorithm free-parameters

All of these algorithm provide some level of quality and performance metrics in their papers. The algorithms are building on the same algorithmic blocks with the same or similar parameters to configure. The thesis aims at a globally consistent setting for shared free-parameters, and aims to incorporate any values from the papers where those values has been explicitly stated by the authors. When selecting a global configuration for a fair benchmarking, the paper stated values has to be cross-verified with their implementations and any deviation from the implementation has to be stated for reproducibility. For the benchmarking, explicitly stated values in the papers will override any deviation in implementation defaults.

#todo("table with the free-parameters and their settings")

- no methods states explicitly in its paper, but the maximum number of source views is set to 20 for all methods. Only a single method #todo("which one") states that they are using max source views to be 10 for their runtime measurements. It is not stated why.
-

==== measurement hardware

When selecting hardware for the benchmarking, the most important component for MVS evaluations is the GPU. DVP-MVS paper claims that a mainstream GPU has 24GB VRAM. This thesis does not agree with this statement. All methods are built using CUDA kernels so they vendor lock NVidia hardware. The only GPUs that have at least 24GB VRAM are the top consumer GPUs (3090, 4090, 5090) or workstation-grade alternatives. Most companies favor more affordable consumer GPUs for example 5070, or 5080 for production grade company clusters with 12GB-16GB VRAM. Especially for MVS, where for the traditional algorithms more compute can outweigh more VRAM, companies would probably choose two 5070 cards instead of a single 5080 #todo("lot of claims, any sources?"). 

The benchmarking system uses Nvidia 5070 GPU with 12GB VRAM. The benchmark explicitly states out-of-memory crash states. For CPU, the system uses an AMD Ryzen 9 9950X3D 16-Core Processor and a Samsung SSD 990 EVO Plus 4TB for storage. The machine has 192GB DDR5 RAM.

For the experiments the 5070 GPU's clock is locked at 2700 MHz.


=== Benchmark metrics

The ETH3D dataset provides a small set of quality metrics for evaluating MVS algorithms. Given an evaluation threshold for the radius around points, the dataset defines two metrics:
- *Accuracy* defines the ratio of reconstructed points that have a ground truth point within a certain radius over all reconstructed.
- *Completeness* defines the ratio of ground truth pionts that have a reconstructed point within the same radius over all ground truth points.
- *F1 Score* is the harmonic mean of accuracy and completeness, combining the two metrics into a single measure.



// What are we measuring and why?
what are we measuring?
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


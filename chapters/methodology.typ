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

methodology / RQ:
- RQ1
  - main methodology: quantitative experimental (benchmarks) / deductive, math proofs (time complexity math maybe)
  - define the algorithmic complexity for main algorithms, see whether their implementation performs according to this complexity model. We can understand how many operations we need to perform the specific task, and see how many operations we ended up needing in order to execute it (maybe)
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
*/

== Benchmarking the state-of-the-art

To showcase the claim that the lineage of MVS algorithms improve quality while they also increase running time, the work starts with a comprehensive benchmarking of the selected methods. The benchmarking analyses all phases of the algorithms to gather as much information as possible without significant modifications to the implementation.

We have chosen 13 methods to evaluate in total. The selected methods contain the
- ACM-family (ACMH, ACMP, ACMM, ACMMP): core cited methods successors are building upon
- APD-MVS, HPM-MVS, and MP-MVS: three major work on top of the ACM-family, choosing different approach to improve the results
- APDe-MVS, DPE-MVS, DVP-MVS: APD-MVS successors extending the lineage
- HPM-MVS++: HPM-MVS successors
- TSAR-MVS: a different approach than the ACM-family
- CUMVS: a simplification and reimplementation of the ACMH/ACMM released by Fixstars, focusing on performance and production quality

These algorithms were chosen because of three important reasons. They are all
- building on the same concepts of Patch-Match-based stereo reconstruction,
- top-performers on the ETH3D leaderboard and are highly cited by each other,
- providing access to an open-source implementation on Github.

=== Configuration

==== dataset, selected scenes, and input resolution

There are many influential benchmarks in the field of 3D reconstruction all of them serving a different purpose. The Middlebury dataset @middleburry_dataset has been the foundational work in creating a structured framework for evaulating two-view stereo algorithm. DTU MVS dataset @dtu_dataset was established for robotics and it provides no leaderboard to find MVS algorithms and their performance. ETH3D @eth3d_dataset is dataset with natural, large-scale scenes, high-resolution images, and provided ground-truth image poses to directly evaluate Multi-View stereo algorithms for pointcloud reconstruction. It has a good leaderboard, showing many SOTA MVS methods. Tanks and Temples @tanks_and_temples_dataset focuses on full 3D pipeline evaluation thus an evaluation requires camera pose estimation as the first step. It also provides a good leaderboard with many SOTA MVS methods.

The ETH3D dataset has been selected as the evaluation dataset for the following reasons
- it focuses directly on MVS
- many algorithm choose this dataset as their primary target for benchmarking
- convenient evaluation scripts are available

The dataset contains 13 scenes with ground-truth as a training set with a wide-variety of indoor and outdoor scenes. The algorithms can react very differently to scene differences thus including all scenes in the benchmarking is crucial. The dataset consists of 7 scenes that have uniform-sized images and 6 scenes which have mixed-sized images. The APD-MVS and DPE-MVS author implementations handle the mixed-sized images in the converter by zero-padding the images to a uniform size.

From an algorithm evaluation perspective, it is interesting to observe the behavior of the implementations at different resolutions than native. Generally, production-grade scanning systems produce a stream of images at lower resolutions than they are captured in ETH3D. Otherwise, 3D reconstruction software usually provide the ability (either implicitly or explicitly) to rescale the images to a lower resolution to make the MVS step faster. Many papers also state that they have run at least part of their evaulations on lower resolutions. Thus, apart from the native resolution, the benchmark defines two downsampled variants at half (3200px width) and at quarter (1600px width) the resolution of the original images (around 6200px width). To minimize loss of image quality, the benchmarking system handles the rescaling using a JPEG q100 4:4:4 re-encoding with Hamming windows for anti-aliasing while preparing the ETH3D dataset.

==== quality metrics

The ETH3D dataset provides a small set of quality metrics for evaluating MVS algorithms. Given an evaluation threshold for the radius around points, the dataset defines
- *Accuracy*: the ratio of reconstructed points that have a ground truth point within a certain radius over all reconstructed.
- *Completeness*: the ratio of ground truth points that have a reconstructed point within the same radius over all ground truth points.
- *F1 Score*: the harmonic mean of accuracy and completeness, combining the two metrics into a single measure.

The quality is measured at 1, 2, 5, 10, 20 cm radius evaluation thresholds, with 2 cm being the primary (the ETH3D default on their leaderboard).

==== runtime metrics

#todo[make table]
- what the benchmarking system measures for each Run
  - timings
    - method wall time (includes 0.1-0.9 second container startup time)
    - converter time (preprocessing)
    - phase timings
      - problem list - parsing the view-selection file into reference problem data structures
      - scene scan - ?
      - device init - selecting device, creating CUDA context
      - scale - ?
      - upsample - coarser level's depth and normal upsampling to a finer level, either joint-bilateral upsampling or resizing
      - confidence eval - HPM-MVS++ host-side confidence sweep
      - edge prior - calculating HPM-MVS++ Canny edge, or DPE-MVS edge segmentation
      - image pass - one patch match pass for a reference image
      - input load - host-side reading of the inputs that a single pass needs
      - device upload - allocating and copying inputs to device memory
      - prior build - building planar prior for next patch match iteration
      - patchmatch - one patch match call #todo[what is the difference between this and image pass]
        - patchmatch.init - hypothesis and cost initialization
        - patchmatch.propagate - one propagation/refinement iteration
        - patchmatch.finalize - to depth-map and filters
        - patchmatch.readback - device->host copy
      - result_readback - host-side reshaping the results
      - depthmap_write - host writing depth to disk
      - fusion - fusing into point cloud
        - fusion.load - reading images, cameras, maps again for fusion
        - fusion.consistency - consistency checking and point generation
      - output_write - final PLY
  - resources
    - peak GPU memory
    - peak host memory
    - GPU utilisation
    - GPU power draw
    - GPU SM clock (to verify that we are not deviating from the locked MHz)
    - GPU Temperature
    - disk read/write
    - disk usage (file sizes after run)

==== algorithm free-parameters

All of these algorithm provide some level of quality and performance metrics in their papers. The algorithms are building on the same algorithmic blocks with the same or similar parameters to configure. The thesis aims at a globally consistent setting for shared free-parameters, and aims to incorporate any values from the papers where those values has been explicitly stated by the authors. When selecting a global configuration for a fair benchmarking, the paper stated values has to be cross-verified with their implementations and any deviation from the implementation has to be stated for reproducibility. For the benchmarking, explicitly stated values in the papers will override any deviation in implementation defaults. Apart from these, the benchmarking runs the implementation's own shipped converters and parameters.

No reconstruction method states the number of source images explicitly in its paper. Some define 10 source images for only their memory and runtime comparison for unexplained reasons @apd @tsar @dvp. The implementations all agree on a maximum 20 sources per reference image, with the converters view selection doing the rest. The shipped converter and thus the produced number of views are generally byte-identical because it was copied from implementation to implementation.

==== repeats and order of execution

The MVS algorithms are non-deterministic thus the benchmarking requires repeated execution to combat variance in results. To determine the number of necessary repeats during benchmarking prior work has to find the randomness factors, make sure that runs are independent, and estimate the variance @kalibera_rigorous_benchmarking.

*Randomness factors*: in all methods the GPU clock cycle counter seeds the random number generator. No method implementation allows for changing this. The random number generator drives the PatchMatch random initialization, the pixel-level view sampling, the depth refinement and RANSAC iterations, and indirectly everything else downstream such as the selected planar priors. Even if the work would fix the seed as a deviation from the original implementation, most algorithms would stay non-deterministic due to bugs and inattention to concurrency issues. The ACM-family PatchMatch kernel implementations have race conditions in the near sampling reads. DPE-MVS has the same type of race in its the edge-aware sampling. Furthermore, it reads uninitialized memory past the end of the image buffer. APD-MVS (and DPE-MVS due to copy-pasted code) leaves an uninitialized border row and column on odd image sizes. Meanwhile, HPM-MVS++ has multiple uninitialized values in the kernel. These are the types of bugs that the thesis claims as inherited problems.

*Run independence and variance estimation*: for proving the independence of runs and finding out the variance to calculate the number of repeats, a dimensioning @kalibera_rigorous_benchmarking on three factor configurations has been run 15 times per method. The configurations include two selected datasets both running at 1600px downscaled resolution: `pipes` and `meadow` and `office`.

#figure(
  image("../generated/figures/dimensioning_run_statistics.png", width: 100%),
  caption: [Run statistics of the dimensioning campaign.],
) <fig-dimensioning-run-statistics>

#todo[we still need to select the number of reruns]

*Variance estimation*:
- wall-time noise does not dpeend on the scene
- F1 noise depends on the scene

The builds and the environment is controlled through

Other randomness factors

randomized order, with 2 repeats #todo("why two repeats, provide reasoning ")
- variance measurements


=== Measurement system

A measurement bench is defined by a host system, a GPU and it's driver, and a docker image containing a pinned evaluator and forked methods with pinned commits.

==== environment

- Docker image that builds all algorithm implementations
- CUDA 12.8 toolkit, clang-18, static OpenCV 4.12, every methods kernel embeds sm_120 machine code
- All lineage methods keep their `-O3` `--use_fast_math`, and `--maxrregcount=128` compile flags for device code.

===== deviations (open-source forks)

A byte-identical bench timer that times different phases of the algorithms is commited and compiled into every measured fork. It is enabled by an environment variable that the docker image sets. The forks in the ACM lineage already synchronise after every CUDA kernel launch, so no commit was required for measuring kernel timings. CUMVS is asynchronous by default for its initialization kernels, so a commit was required to make these synchronous. The effects are negligible and they only added a measured 0.9 seconds to the wall runtime.

Furthermore, all forks are compiled directly to native  NVidia `sm_120`.

==== hardware

When selecting hardware for the benchmarking, the most important component for MVS evaluations is the GPU. DVP-MVS paper claims that a mainstream GPU has 24GB VRAM. This thesis does not agree with this statement. All methods are built using CUDA kernels so they vendor lock NVidia hardware. The only GPUs that have at least 24GB VRAM are the top consumer GPUs (3090, 4090, 5090) or workstation-grade alternatives. Most companies favor more affordable consumer GPUs for example 5070, or 5080 for production grade company clusters with 12GB-16GB VRAM. Especially for MVS, where for the traditional algorithms more compute can outweigh more VRAM, companies would probably choose two 5070 cards instead of a single 5080 #todo("lot of claims, any sources?"). 

The benchmarking system uses Nvidia 5070 GPU with 12GB VRAM. The benchmark explicitly states out-of-memory crash states. For CPU, the system uses an AMD Ryzen 9 9950X3D 16-Core Processor and a Samsung SSD 990 EVO Plus 4TB for storage. The machine has 192GB DDR5 RAM.

For controlling the experiments the 5070 GPU's streaming multiprocessor (SM) clock is locked at the card's base frequency: 2317 MHz. The card has a much higher boost frequency which it might not be able to sustained under changing temperatures and fluctuating power over the long benchmarking session and could negatively affect the results. No other processes running on the GPU is a requirement for the benchmarking.

Controlling the host requires us to pin the containers to use CPU threads 0-7,16-23 because of the 9950X3D dual CCD design having 96 MB L3 cache for these 16 threads, while having only 32 MB for the other 16. A method that is only running on the latter would be in disadvantage compared to the others that run only on the former. Apart from this, the benchmark sets the CPU governor and the Energy Performance Preference (EPP) to performance mode, and turns off boost.

#todo[host boost is turned off, explain why.]


== Runtime decomposition, algorithmic cost, and analysis



== Own implementation...

Itt van az algoritmus leirasa es kidolgozasa

claude: mik azok amik érdekesek lehetnek más szemszögéből, mik azok az angle-ök

/*
instead of Quorum MVS, do an ablation study based on the selected algorithm (for example APD-MVS or MP-MVS). Change only a single component at a time, for example remove the JPEG re-encoding and measure how it affects the system, and move component by component to show how we are slowly improving the system. Move in small iterations and do the same when making the system into a production system. Make sure we stay bit-identical for performance improvements, and make sure we measure as ablation when we are deviating from the original implementation.
*/
#todo[ablation study]

focus on production implementation considerations, plus performance considerations


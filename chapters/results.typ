#import "../template/elteikthesis.typ": *


= Results & Discussion

3. Can a systematically engineered, production-grade reimplementation of a recent state-of-the-art method recover a substantial fraction of the runtime and memory cost while preserving its benchmark accuracy?
  - can we find a single change in a lineage shared kernel part (for example in the ACM family) that if we improve, it would improve the perf of all lineage items?

== Preparing for the benchmarking, Findings

1. all nine methods (ACM-family, two HPM, APD, DPE) ship converters that look for `.jpg` images in a case-sensitive manner while ETH3D downloaded images are `*.JPG` with upper-case. Because of this, the converter decodes and re-encodes every image using OpenCV's default JPEG quality, 95. The re-encode changes 46-59% of pixels at 46-50 dB PSNR.
  - CUMVS reads original images and it doesn't re-encode


== Benchmarking

// put the full benchmark result tables in the appendix

- MP-MVS claims in it's paper that it is 17% faster in depth estimation than ACMMP. I don't know what they measured but for me it seems like not true!
  - ACMH -> PatchMatch 26.2%; Fusion 41.8%; I/O 13.8%; Preprocessing 11.5%
  - ACMMP -> PatchMatch 39.4%; Fusion 20.1%; I/O 25.6%; Preprocessing 6.3%
    - --> (patch match is $381 * 39.4% = $ *150 sec*)
  - MP-MVS PatchMatch 59.6%; Fusion 16.8%; I/O 10.8%; Preprocessing 7.5%
    - --> (patch match is $307 * 59.6% = $ *182,9 sec*)


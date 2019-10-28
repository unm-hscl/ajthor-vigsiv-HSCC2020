# Plots

The following code generates the plots and figures presented in [1]. Figure 1 is a drawing that is generated using an online drawing tool, and so is not included here. Use the following code to generate figures 2-6.

## Figure 2

Figure 2 shows the results of the two algorithms, as well as the comparison to
the dynamic programming results. The first plot shows the dynamic programming
results, the second shows the results from the `KernelDistributionEmbeddings`
algorithm. The third shows the absolute error between the dynamic programming
results and the results from `KernelDistributionEmbeddings`. The fourth shows
the results from `KernelDistributionEmbeddingsRFF`. The fifth shows the absolute
error between the dynamic programming results and the results from
`KernelDistributionEmbeddingsRFF`.

## Figure 3

Figure 3 shows This figure shows the results of the
`KernelDistributionEmbeddingsRFF`  algorithm. The plots show the run of the
`KernelDistributionEmbeddingsRFF` for a double integrator with a gaussian
disturbance at varying number of frequency samples.

## Figure 4

Figure 4 shows the errors of the `KernelDistributionEmbeddingsRFF` algorithm at
various numbers of frequency samples, D.

## Figure 5

Figure 5 shows the results of the `KernelDistributionEmbeddings`
algorithm. Specifically, for the double integrator system with affine
disturbance and no input. The the results are shown for exponential and
beta disturbances.

## Figure 6

Figure 6 shows the results of the `KernelDistributionEmbeddings`  algorithm.
Specifically, for the planar quadcopter system with affine disturbance and
stationary policy. The the results are shown for  gaussian and beta
disturbances.

## References

> [1] Adam J. Thorpe, Vignesh Sivaramakrishnan, Meeko M. K. Oishi. "Stochastic
> Reachability for Systems up to a Million Dimensions."  23rd ACM International
> Conference on Hybrid Systems: Computation and Control (submitted)

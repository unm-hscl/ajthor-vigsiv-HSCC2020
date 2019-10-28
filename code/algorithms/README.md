# Algorithms

## Table of Contents

* [Kernel Distribution Embeddings](#kernel_distribution_embeddings)
* [Kernel Distribution Embeddings (RFF)](#kernel_distribution_embeddings_RFF)

## Kernel Distribution Embeddings

The constructor for the algorithm takes name/value parameters that specify the parameters sigma and lambda. These define the kernel bandwidth and regularization parameter, respectively.

The algorithm can be run using the `ComputeSafetyProbabilities` function.

### Usage

In the code below, we assume the `problem`, `samples`, `Xtest`, and `Utest` have been defined elsewhere.

```matlab
% Define the algorithm Kernel Distribution Embeddings
algorithm = KernelDistributionEmbeddings('Sigma', 0.1, 'Lambda', 1);

% Compute the safety probabilities at the points in '(Xtest, Utest)'.
algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);
```

## Kernel Distribution Embeddings RFF

The constructor for the algorithm takes name/value parameters that specify the parameters sigma and lambda. These define the kernel bandwidth and regularization parameter, respectively. Additionally, the RFF algorithm takes a parameter `D`, which specifies the number of frequency samples.

The algorithm can be run using the `ComputeSafetyProbabilities` function.

### Usage

In the code below, we assume the `problem`, `samples`, `Xtest`, and `Utest` have been defined elsewhere.

```matlab
% Define the algorithm Kernel Distribution Embeddings (RFF)
algorithm = KernelDistributionEmbeddingsRFF('Sigma', 0.1, 'Lambda', 1, 'D', 1000);

% Compute the safety probabilities at the points in '(Xtest, Utest)'.
algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);
```

## The difference between `X` and `Xtest`

There is a difference between the samples we use to build the approximation, and
the points we want to evaluate the safety probabilities at. The variable `X`,
which is passed to the `SystemSamples` class, corresponds to the samples which
we are using to build the approximation. These samples should be chosen so that
they characterize the space as well as possible. The variable `Xtest`
corresponds to the initial conditions we want to evaluate the safety
probabilities at. These should be chosen to be near the `X` samples, otherwise
the safety probabilities will tend to zero.

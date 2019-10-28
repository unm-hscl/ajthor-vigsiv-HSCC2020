# Code

The code is organized into folders by the code's purpose.

## Algorithms

The algorithm classes and the corresponding implementations are located in the [algorithms](algorithms/) folder.

An implementation of the `KernelDistributionEmbeddings` algorithm is located
[here](algorithms/@KernelDistributionEmbeddings/ComputeSafetyProbabilities.m),
while the implementation of the `KernelDistributionEmbeddingsRFF` algorithm is
located
[here](algorithms/@KernelDistributionEmbeddingsRFF/ComputeSafetyProbabilities.m).

## Problems

The [problems](problems/) directory contains the code for the [first-hitting time
problem](problems/@FirstHittingTimeProblem/FirstHittingTimeProblem.m) and the
[terminal-hitting time
problem](problems/@TerminalHittingTimeProblem/TerminalHittingTimeProblem.m).
These are passed to the algorithm at runtime.

## Samples

The class to store the samples, which is passed to the algorithm at runtime, is
located in the [samples](samples/) directory.

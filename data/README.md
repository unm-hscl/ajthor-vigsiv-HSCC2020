# Data

The only data file that is included with the repo are the results of the dynamic
programming algorithm computed using
[SReachTools](https://sreachtools.github.io). The data corresponds to solving
the 2-D stochastic chain of integrators with a safe set of `[-1, 1]x[-1, 1]` and
target set of `[-0.5, 0.5]x[-0.5, 0.5]`.

The data file contains a variable `PrDP` containing the safety probabilities.
The probabilities are contained in a `5x1000x1000` matrix, where the first index
corresponds to the time index, and for each index, the `1000x1000` matrix are
the safety probabilities computed over a uniform grid for the 2-D stochastic
chain of integrators.

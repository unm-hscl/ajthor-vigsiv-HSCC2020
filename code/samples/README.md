# Samples

## Table of Contents

* [System Samples](#system_samples)
* [generateUniformSamples](#generateUniformSamples)

## System Samples

The samples generated for use in the algorithm are stored in a class called
`SystemSamples`. This class verifies the sizes of the sample matrices to make
sure they are consistent.

The class takes the dimensions of the state and input spaces as the first
argument, and then accepts name/value pairs corresponding to the `X`, `U`, and
`Y` samples, where `Y ~ Q(.|X, U)`.

The samples should be organized in a matrix such that the columns of the matrix
are the samples.

### Usage

```matlab
% We start by generating samples via simulation.

% The system matrices for a 2-D stochastic chain of integrators.
A = [1, 0.25; 0, 1];
B = [0.03125; 0.25];

% Generate a uniform set of samples that are from [-1.1, 1.1]x[-1.1, 1.1].
s = linspace(-1.1, 1.1, 50);
X = generateUniformSamples(s);

% We choose zero inputs for the chain of integrators example. These can be any
% valid input for the system if they are non-zero.
U = zeros(1, size(X, 2));

% Generate the Gaussian disturbances.
W = 0.01.*randn(size(X));

% Compute the outputs using the dynamics.
Y = A*X + B*U + W;

% Store the samples in the 'SystemSamples' class.
samples = SystemSamples([2 1], 'X', X, 'U', U, 'Y', Y);
```

## generateUniformSamples

As a helper utility, the function `generateUniformSamples` is provided, which
takes a range, e.g. `1:10`, and produces a mesh of samples organized into a
sample vector.

For example, the following code will produce a matrix with pairs `(1, 1)`, `(1,
2)`, `(1, 3)` until `(10, 10)` in the columns.
```matlab
X = generateUniformSamples(1:10);
```

This is equivalent to using `meshgrid`, and subsequently reshaping and
concatenating the resulting matrices.

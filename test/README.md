# Testing

Unit tests for the main components of the algorithm are provided here, as well
as performance tests to measure the computation time of the algorithms.

The tests take advantage of matlab's Unit Testing Framework and the Performance
Testing Framework. The unit tests are organized into classes, labeled according
to the components they test. The performance tests are labeled with the prefix
`Profile`.

## Unit Tests

The unit tests are designed to test the atomic components of the algorithm,
including the code contained within the algorithm itself.

These tests can be run using `run_unit_tests.m`, located in the root folder.

> WARNING: The unit tests can take a significant amount of time to run.
> The high-dimensional repeated quadrotor example takes approx. 1.5 hours to
> run.

The estimated runtime for all unit tests is approximately 1.5 hours.

## Performance Tests

The performance tests are used to generate the computation times for the
algorithm on three examples: the 2-D stochastic chain of integrators, the single
planar quadrotor, and the million-dimensional repeated planar quadrotor.

> WARNING: The performance tests can take a significant amount of time to run.
> The high-dimensional repeated quadrotor example takes approx. 1.5 hours to
> run, and the performance testing framework will run this about seven times.

The estimated runtime for all performance tests is approximately 11 hours.

# Stochastic Reachability for Systems up to a Million Dimensions

* [ ] Platform Information
* [ ] Code Instructions
* [ ] Code Documentation
* [ ] Code Examples
* [ ] Code Tests

## Table of Contents

* [Documentation](#documentation)
* [Instructions](#instructions)
  * [Requirements](#requirements)
  * [Repeatability Instructions](#repeatability-instructions)
* [References](#references)

## Description

* **What is this repository?** This repository contains the repeatability code and documentation for the algorithms and plots presented in [1]. It contains an implementation of two algorithms called _conditional distribution embeddings for stochastic reachability_ (CDE, for short), and CDE using _random Fourier features_ (RFF), to solve the terminal-hitting and first-hitting stochastic reachability problems.
* **How does it work?** The entry points for the code are found in the root directory. See the [documentation](docs/documentation.pdf) for specific examples of how to use the code, and information about the specific functions, classes, and design decisions.
* **Who should use this code?** Anyone who would like to utilize an implementation of the algorithms presented in [1], as well as anyone who would like to perform a repeatability evaluation or generate the accompanying plots.
* **What is the goal of this repository?** This repository is meant to serve as a formally-documented and complete implementation of the algorithms presented in [1]. In the future, further development and implementation details will be found in [SReachTools](https://sreachtools.github.io), a Matlab toolbox for stochastic reachability.

## Documentation

Documentation for the code is provided throughout. The documentation is
formatted as easily-readable
[Markdown](https://guides.github.com/features/mastering-markdown/). Each folder
contains a top-level description of the folder contents and the purpose of the
code contained inside, each file also contains comments and documentation to
describe the code purpose and usasge, and finally a
[PDF](docs/documentation.pdf) describing the overall methodology and
instructions for the code is provided in the `docs` directory that should
accompany the code. More information and updates can be found on the [GitHub
repository](https://github.com/unm-hscl/ajthor-vigsiv-HSCC2020-FHT).

Future documentation and implementation details will be found at [SReachTools](https://sreachtools.github.io).

## Instructions

* **How do I get the code?** The code can be cloned using [git](https://git-scm.com) from the GitHub repository page [ajthor-vigsiv-HSCC2020-FHT](https://github.com/unm-hscl/ajthor-vigsiv-HSCC2020-FHT) using the following command, or downloaded directly using the following link: https://github.com/unm-hscl/ajthor-vigsiv-HSCC2020-FHT/archive/master.zip
```shell
git clone https://github.com/unm-hscl/ajthor-vigsiv-HSCC2020-FHT.git
```
* **How do I use the code?** In order to use the code, open the repository in Matlab and use the Matlab scripts in the root directory of the repository as a starting point. In order to adapt the code for your own purposes, see the [documentation](docs/documentation.pdf) accompanying the code.
* **How do I test the code?** Unit tests written using Matlab's testing framework are provided with the code. In order to run the tests, use the `run_all_tests.m` script located in the root directory of the repository, or use the [`runtests`](https://www.mathworks.com/help/matlab/ref/runtests.html) command provided by Matlab.
* **How do I run performance test?** Performance tests are included as part of the unit testing framework. Running all tests will also perform the relevant performance tests.

Instructions are also provided in the accompanying
[documentation](docs/documentation.pdf).

### Requirements

This code has been tested and run on macOS 10.14.6 (Mojave), as well as Ubuntu 18.04.3 (Bionic Beaver) using Matlab 9.6.0.1174912 (R2019a) Update 5. It should also run in any newer version of Matlab.

* **Do I need any Matlab toolboxes?** The code requires the Statistics and Machine Learning Toolbox to be installed in order to use the non-Gaussian disturbances for the system.
* **Do I need any external toolboxes?** No, there are no external dependencies.

### Repeatability Instructions



## References

> [1] Adam J. Thorpe, Vignesh Sivaramakrishnan, Meeko M. K. Oishi. "Stochastic
> Reachability for Systems up to a Million Dimensions."  23rd ACM International
> Conference on Hybrid Systems: Computation and Control (submitted)

# Problems

## Table of Contents

* [First-Hitting Time Problem](#first-hitting-time-problem)
* [Terminal-Hitting Time Problem](#terminal-hitting-time-problem)
* [References](#references)

## First-Hitting Time Problem

The first-hitting time problem is defined in [1] as the probability that a
system will reach a target set at some time during the time horizon, while
remaining safe for the time up until it reaches the target set.

### Usage

```matlab
% The time horizon for the problem.
TimeHorizon = 5;

% The constraint set for the problem.
ConstraintSet = @(x) (-1 < x < 1);

% The target set for the problem.
TargetSet = @(x) (-0.5 < x < 0.5);

problem = TerminalHittingTimeProblem('ConstraintSet', ConstraintSet, ...
                                     'TargetSet', TargetSet, ...
                                     'TimeHorizon', TimeHorizon);
```

## Terminal-Hitting Time Problem

The first-hitting time problem is defined in [1] as the probability that a
system will reach a target set at the final time of the time horizon, while
remaining safe for the entire horizon.

### Usage

```matlab
% The time horizon for the problem.
TimeHorizon = 5;

% The constraint set for the problem.
ConstraintSet = @(x) (-1 < x < 1);

% The target set for the problem.
TargetSet = @(x) (-0.5 < x < 0.5);

problem = FirstHittingTimeProblem('ConstraintSet', ConstraintSet, ...
                                  'TargetSet', TargetSet, ...
                                  'TimeHorizon', TimeHorizon);
```

## References

> [1] Summers, Sean, and John Lygeros. "Verification of discrete time stochastic hybrid systems: A stochastic reach-avoid decision problem." Automatica 46.12 (2010): 1951-1961.

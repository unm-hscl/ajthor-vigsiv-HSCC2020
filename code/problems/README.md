# Problems

## Table of Contents

* [First-Hitting Time Problem](#first-hitting_time_problem)
* [Terminal-Hitting Time Problem](#terminal-hitting_time_problem)
* [References](#references)

## First-Hitting Time Problem

The first-hitting time problem is defined in [1] as

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

The first-hitting time problem is defined in [1] as

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

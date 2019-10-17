%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ProblemBaseClass
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) ProblemBaseClass < handle
% ProblemBaseClass The abstract base class for all problems. All problem classes
% inherit from the problem base class, inheriting its properties and methods.
% This class is mainly used for validation and error checking.

properties (Hidden, Access = protected)
    % The privately stored variable corresponding to the constraint set.
    ConstraintSet_  function_handle = function_handle.empty
    % The privately stored variable corresponding to the target set.
    TargetSet_      function_handle = function_handle.empty

    % The privately stored variable corresponding to the time horizon. The time
    % horizon is often denoted as `N`, and is defined as a positive integer
    % value.
    TimeHorizon_    (1, 1) {mustBeInteger, mustBePositive} = 1
end

properties (Dependent)
    % ConstraintSet The constraint set for the problem.
    ConstraintSet

    % TargetSet The target set for the problem.
    TargetSet

    % TimeHorizon The time horizon for the problem.
    %
    % Note that because of the way Matlab handles indexing, the time horizon is
    % specified to be from 1 to TimeHorizon, which may not coincide with the
    % expected horizon length.
    TimeHorizon
end

methods
    function obj = ProblemBaseClass(varargin)
        % ProblemBaseClass The parent class constructor for all problems.

        % Create an inputParser to parse `varargin` and store the parameters.
        p = inputParser;

        % Allow the inputParser to accept values that are not explicitly defined
        % by `addRequired`, `addOptional`, or `addParameter`.
        p.KeepUnmatched = true;

        % Specify the parameter validation functions.
        validateConstraintSet = ...
            @(arg) validateattributes(arg, {'function_handle'}, {'nonempty'});

        validateTargetSet = ...
            @(arg) validateattributes(arg, {'function_handle'}, {'nonempty'});

        validateTimeHorizon = ...
            @(arg) validateattributes(arg, {'numeric'}, {'positive'});

        % Specify the parameter defaults.
        defaultConstraintSet = function_handle.empty;

        defaultTargetSet = function_handle.empty;

        defaultTimeHorizon = 1;

        % Add name/value parameters that are passed to the class constructor.
        addParameter(p, 'ConstraintSet', defaultConstraintSet, ...
            validateConstraintSet);

        addParameter(p, 'TargetSet', defaultTargetSet, ...
            validateTargetSet);

        addParameter(p, 'TimeHorizon', defaultTimeHorizon, ...
            validateTimeHorizon);

        % Parse the parameters. These are stored in the p.Results struct after
        % parsing.
        parse(p, varargin{:});

        % Store the parameters in private variables.
        obj.ConstraintSet_ = p.Results.ConstraintSet;

        obj.TargetSet_ = p.Results.TargetSet;

        obj.TimeHorizon_ = p.Results.TimeHorizon;

    end

    function Set = get.ConstraintSet(obj)
        % ConstraintSet Returns the constraint set for the problem.
        Set = obj.ConstraintSet_;
    end

    function set.ConstraintSet(obj, Set)
        % ConstraintSet Sets the constraint set for the problem.
        obj.ConstraintSet_ = Set;
    end

    function Set = get.TargetSet(obj)
        % TargetSet Returns the target set for the problem.
        Set = obj.TargetSet_;
    end

    function set.TargetSet(obj, Set)
        % TargetSet Sets the target set for the problem.
        obj.TargetSet_ = Set;
    end

    function N = get.TimeHorizon(obj)
        % TimeHorizon Returns the time horizon for the problem.
        N = obj.TimeHorizon_;
    end

    function set.TimeHorizon(obj, N)
        % TimeHorizon Sets the time horizon for the problem.
        obj.TimeHorizon_ = N;
    end
end

end

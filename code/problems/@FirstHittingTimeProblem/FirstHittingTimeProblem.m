%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FirstHittingTimeProblem Algorithm
%
% The first-hitting time problem is defined as the probability that a system
% will reach a target set at some point during the time horizon while remaining
% safe until it reaches the target set.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FirstHittingTimeProblem < ProblemBaseClass
% FirstHittingTimeProblem A problem description class for the first-hitting time
% problem.

methods
    function obj = FirstHittingTimeProblem(varargin)
        % FirstHittingTimeProblem Constructs an instance of the
        % FirstHittingTimeProblem class.

        % Call the parent class constructor, and pass along all parameters. This
        % must be done before anything else.
        obj = obj@ProblemBaseClass(varargin{:});

    end
end

end

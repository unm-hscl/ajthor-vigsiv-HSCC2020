%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TerminalHittingTimeProblem Algorithm
%
% The terminal-hitting time problem is defined as the probability that a system
% will reach a target set at the final time of the time horizon while remaining
% safe until it reaches the target set.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef TerminalHittingTimeProblem < ProblemBaseClass
% TerminalHittingTimeProblem A problem description class for the first-hitting
% time problem.

methods
    function obj = TerminalHittingTimeProblem(varargin)
        % TerminalHittingTimeProblem Constructs an instance of the
        % TerminalHittingTimeProblem class.

        % Call the parent class constructor, and pass along all parameters. This
        % must be done before anything else.
        obj = obj@ProblemBaseClass(varargin{:});

    end
end

end

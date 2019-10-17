%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TerminalHittingTimeProblem Algorithm
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

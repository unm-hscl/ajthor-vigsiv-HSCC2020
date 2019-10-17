%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FirstHittingTimeProblem Algorithm
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

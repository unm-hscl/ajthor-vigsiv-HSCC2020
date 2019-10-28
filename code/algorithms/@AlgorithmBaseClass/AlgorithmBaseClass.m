%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AlgorithmBaseClass
%
% The AlgorithmBaseClass is an abstract parent class for all algorithms. The
% primary purpose of the AlgorithmBaseClass is to ensure that all algorithms
% implement the same function, `ComputeSafetyProbabilities`.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) AlgorithmBaseClass < handle
% AlgorithmBaseClass The abstract base class for all algorithms. All algorithm
% classes inherit from the algorithm base class, inheriting its properties and
% methods. This class is mainly used for validation and error checking.

methods
    function obj = AlgorithmBaseClass(varargin)
        % AlgorithmBaseClass The parent class constructor for all problems.

        % Empty

    end
end

methods (Abstract)
    % All classes inheriting from AlgorithmBaseClass are required to implement
    % the abstract method `ComputeSafetyProbabilities`.
    ComputeSafetyProbabilities()
end

end

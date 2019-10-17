%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AlgorithmBaseClass
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Abstract) AlgorithmBaseClass < handle
% AlgorithmBaseClass The abstract base class for all algorithms. All algorithm
% classes inherit from the algorithm base class, inheriting its properties and
% methods. This class is mainly used for validation and error checking.

methods
    function obj = AlgorithmBaseClass(varargin)
        % AlgorithmBaseClass The parent class constructor for all problems.

    end
end

methods (Abstract)
    % All classes inheriting from AlgorithmBaseClass are required to implement
    % the abstract method `implementation`.
    implementation()
end

end

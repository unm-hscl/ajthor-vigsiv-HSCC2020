%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SystemSamples
%
% A system samples class is a container that stores the samples from a
% stochastic kernel used by the KernelDistributionEmbeddings and
% KernelDistributionEmbeddingsRFF algorithms.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Sealed) SystemSamples < handle
% SystemSamples A container that holds samples from a stochastic kernel.

properties (Hidden, Access = private)
    %
    Dimensions_

    %
    StateSamplesX_

    %
    InputSamplesU_

    %
    StateSamplesY_
end

properties (Dependent)
    %
    n
    %
    m

    %
    StateSamplesX

    %
    InputSamplesU

    %
    StateSamplesY
end

methods
    function obj = SystemSamples(Dimensions, varargin)
        % SystemSamples Constructs an instance of the SystemSamples class.

        % Create an inputParser to parse `varargin` and store the parameters.
        p = inputParser;

        % Allow the inputParser to accept values that are not explicitly defined
        % by `addRequired`, `addOptional`, or `addParameter`.
        p.KeepUnmatched = true;

        % Specify the parameter validation functions.
        validateDimensions = ...
            @(arg) validateattributes(arg, {'numeric'}, {'row', 'numel', 2});

        validateStateSamplesX = ...
            @(arg) validateattributes(arg, {'numeric'}, {'nonempty'});

        validateInputSamplesU = ...
            @(arg) validateattributes(arg, {'numeric'}, {'nonempty'});

        validateStateSamplesY = ...
            @(arg) validateattributes(arg, {'numeric'}, {'nonempty'});

        % Specify the parameter defaults.
        defaultStateSamplesX = function_handle.empty;

        defaultInputSamplesU = function_handle.empty;

        defaultStateSamplesY = 1;

        % Add required parameters that must be passed to the class constructor.
        addRequired(p, 'Dimensions', validateDimensions);

        % Add name/value parameters that are passed to the class constructor.
        addParameter(p, 'X', defaultStateSamplesX, ...
            validateStateSamplesX);

        addParameter(p, 'U', defaultInputSamplesU, ...
            validateInputSamplesU);

        addParameter(p, 'Y', defaultStateSamplesY, ...
            validateStateSamplesY);

        % Parse the parameters. These are stored in the p.Results struct after
        % parsing.
        parse(p, Dimensions, varargin{:});

        % Store the parameters in private variables.
        obj.Dimensions_ = p.Results.Dimensions;

        obj.StateSamplesX_ = p.Results.X;

        obj.InputSamplesU_ = p.Results.U;

        obj.StateSamplesY_ = p.Results.Y;
    end

    function n = get.n(obj)
        n = obj.Dimensions_(1);
    end

    function m = get.m(obj)
        m = obj.Dimensions_(1);
    end

    function samples = get.StateSamplesX(obj)
        % StateSamplesX Returns the regularization parameter for the algorithm.
        samples = obj.StateSamplesX_;
    end

    function set.StateSamplesX(obj, samples)
        % StateSamplesX Sets the regularization parameter for the algorithm.
        obj.StateSamplesX_ = samples;
    end

    function samples = get.InputSamplesU(obj)
        % InputSamplesU Returns the regularization parameter for the algorithm.
        samples = obj.InputSamplesU_;
    end

    function set.InputSamplesU(obj, samples)
        % InputSamplesU Sets the regularization parameter for the algorithm.
        obj.InputSamplesU_ = samples;
    end

    function samples = get.StateSamplesY(obj)
        % StateSamplesY Returns the regularization parameter for the algorithm.
        samples = obj.StateSamplesY_;
    end

    function set.StateSamplesY(obj, samples)
        % StateSamplesY Sets the regularization parameter for the algorithm.
        obj.StateSamplesY_ = samples;
    end

end

end

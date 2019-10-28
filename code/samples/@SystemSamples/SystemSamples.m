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
    % The privately stored variable corresponding to the dimensions of the
    % system.
    Dimensions_

    % The privately stored variable corresponding to the state input samples X.
    StateSamplesX_

    % The privately stored variable corresponding to the control input samples
    % U.
    InputSamplesU_

    % The privately stored variable corresponding to the state output samples Y.
    StateSamplesY_
end

properties (Dependent)
    % n The dimension of the state space samples.
    n
    % m The dimension of the input samples.
    m

    % StateSamplesX The state input samples X.
    StateSamplesX

    % InputSamplesU The control input samples U.
    InputSamplesU

    % StateSamplesY The state output samples Y.
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
        defaultStateSamplesX = zeros(Dimensions(1), 1);

        defaultInputSamplesU = zeros(Dimensions(2), 1);

        defaultStateSamplesY = zeros(Dimensions(1), 1);

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

        validateattributes(p.Results.X, {'numeric'}, {'nrows', obj.n});
        validateattributes(p.Results.U, {'numeric'}, {'nrows', obj.m});
        validateattributes(p.Results.Y, {'numeric'}, {'nrows', obj.n});

        obj.StateSamplesX_ = p.Results.X;

        obj.InputSamplesU_ = p.Results.U;

        obj.StateSamplesY_ = p.Results.Y;
    end

    function n = get.n(obj)
        % n Returns the state space dimensionality for the algorithm.
        n = obj.Dimensions_(1);
    end

    function m = get.m(obj)
        % m Returns the input space dimensionality for the algorithm.
        m = obj.Dimensions_(2);
    end

    function samples = get.StateSamplesX(obj)
        % StateSamplesX Returns the state space input samples for the algorithm.
        samples = obj.StateSamplesX_;
    end

    function set.StateSamplesX(obj, samples)
        % StateSamplesX Sets the state space input samples for the algorithm.
        validateattributes(samples, {'numeric'}, {'nrows', obj.n});
        obj.StateSamplesX_ = samples;
    end

    function samples = get.InputSamplesU(obj)
        % InputSamplesU Returns the control input samples for the algorithm.
        samples = obj.InputSamplesU_;
    end

    function set.InputSamplesU(obj, samples)
        % InputSamplesU Sets the control input samples for the algorithm.
        validateattributes(samples, {'numeric'}, {'nrows', obj.m});
        obj.InputSamplesU_ = samples;
    end

    function samples = get.StateSamplesY(obj)
        % StateSamplesY Returns the state space output samples for the
        % algorithm.
        samples = obj.StateSamplesY_;
    end

    function set.StateSamplesY(obj, samples)
        % StateSamplesY Sets the state space output samples for the algorithm.
        validateattributes(samples, {'numeric'}, {'nrows', obj.n});
        obj.StateSamplesY_ = samples;
    end

end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddingsRFF Algorithm
%
% This class sets up and validates the algorithm parameters for the
% ComputeSafetyProbabilities function. For KernelDistributionEmbeddingsRFF, it
% manages three parameters, sigma, lambda, and D.
%
% Sigma is the kernel bandwidth parameter for the Gaussian kernel. By default,
% the Gaussian kernel is the only available kernel for the code. It is
% hard-coded into the ComputeKernel function, and must be changed in the source
% if you wish to use a different kernel function.
%
% Lambda is the regularization parameter, which determines how smooth the
% approximation is. In theory, the lambda parameter should decrease to zero as
% the number of samples is increased. However, in paractice, lambda is left as
% the default, 1.
%
% D is the number of frequency samples used by the kernel approximation via RFF.
% Increasing the number of frequency samples should increase the quality of the
% approximation computed via the KernelDistributionEmbeddingsRFF algorithm.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Sealed) KernelDistributionEmbeddingsRFF < AlgorithmBaseClass
% KernelDistributionEmbeddingsRFF An implementation of the kernel distribution
% embeddings algorithm for stochastic reachability using random Fourier features
% (RFF).

properties (Access = private)
    % The privately stored variable corresponding to the regularization
    % parameter lambda. Lambda is defined as a numeric, scalar value that must
    % be strictly positive.
    Lambda_ (1, 1) {mustBeNumeric, mustBePositive} = 1

    % The privately stored variable corresponding to the kernel bandwidth
    % parameter sigma. Sigma is defined as a numeric, scalar value that must
    % be strictly positive.
    Sigma_  (1, 1) {mustBeNumeric, mustBePositive} = 0.1

    % The privately stored variable corresponding to the number of frequency
    % samples D. D is defined as a numeric, scalar value that must be strictly
    % positive.
    D_  (1, 1) {mustBeNumeric, mustBePositive} = 0.1
end

properties (Dependent)
    % Lambda The regularization parameter for the algorithm.
    Lambda

    % Sigma The kernel bandwidth parameter for the algorithm.
    Sigma

    % D The number of frequency samples for the algorithm.
    D
end

methods
    function obj = KernelDistributionEmbeddingsRFF(varargin)
        % KernelDistributionEmbeddingsRFF Constructs an instance of the
        % KernelDistributionEmbeddingsRFF algorithm class.

        % Call the parent class constructor, and pass along all parameters. This
        % must be done before anything else.
        obj = obj@AlgorithmBaseClass(varargin{:});

        % Create an inputParser to parse `varargin` and store the parameters.
        p = inputParser;

        % Allow the inputParser to accept values that are not explicitly defined
        % by `addRequired`, `addOptional`, or `addParameter`.
        p.KeepUnmatched = true;

        % Specify the parameter validation functions.
        validateLambda = ...
            @(arg) validateattributes(arg, {'numeric'}, {'positive'});

        validateSigma = ...
            @(arg) validateattributes(arg, {'numeric'}, {'positive'});

        validateD = ...
            @(arg) validateattributes(arg, {'numeric'}, {'positive'});

        % Specify the parameter defaults.
        defaultLambda = 1;

        defaultSigma = 0.1;

        defaultD = 1;

        % Add name/value parameters that are passed to the class constructor.
        addParameter(p, 'Lambda', defaultLambda, validateLambda);

        addParameter(p, 'Sigma',  defaultSigma,  validateSigma);

        addParameter(p, 'D',  defaultD,  validateD);

        % Parse the parameters. These are stored in the p.Results struct after
        % parsing.
        parse(p, varargin{:});

        % Store the parameters in private variables.
        obj.Lambda_ = p.Results.Lambda;

        obj.Sigma_ = p.Results.Sigma;

        obj.D_ = p.Results.D;

    end

    function lambda = get.Lambda(obj)
        % Lambda Returns the regularization parameter for the algorithm.
        lambda = obj.Lambda_;
    end

    function set.Lambda(obj, lambda)
        % Lambda Sets the regularization parameter for the algorithm.
        obj.Lambda_ = lambda;
    end

    function sigma = get.Sigma(obj)
        % Sigma Returns the kernel bandwidth parameter for the algorithm.
        sigma = obj.Sigma_;
    end

    function set.Sigma(obj, sigma)
        % Sigma Sets the kernel bandwidth parameter for the algorithm.
        obj.Sigma_ = sigma;
    end

    function d = get.D(obj)
        % D Returns the number of frequency samples parameter for the algorithm.
        d = obj.D_;
    end

    function set.D(obj, d)
        % D Sets the number of frequency samples parameter for the algorithm.
        obj.D_ = d;
    end
end

end

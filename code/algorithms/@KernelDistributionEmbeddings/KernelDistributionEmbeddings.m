%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddings Algorithm
%
% Implementation of the kernel distribution embeddings for stochastic
% reachability algorithm.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef (Sealed) KernelDistributionEmbeddings < AlgorithmBaseClass
% KernelDistributionEmbeddings An implementation of the kernel distribution
% embeddings algorithm for stochastic reachability.

properties (Access = private)
    % The privately stored variable corresponding to the regularization
    % parameter lambda. Lambda is defined as a numeric, scalar value that must
    % be strictly positive.
    Lambda_ (1, 1) {mustBeNumeric, mustBePositive} = 1

    % The privately stored variable corresponding to the kernel bandwidth
    % parameter sigma. Sigma is defined as a numeric, scalar value that must
    % be strictly positive.
    Sigma_  (1, 1) {mustBeNumeric, mustBePositive} = 0.1
end

properties (Dependent)
    % Lambda The regularization parameter for the algorithm.
    %
    % Lambda is defined as a numeric, scalar value that must be strictly
    % positive.
    Lambda

    % Sigma The kernel bandwidth parameter for the algorithm.
    %
    % Sigma is defined as a numeric, scalar value that must be strictly
    % positive.
    Sigma
end

methods
    function obj = KernelDistributionEmbeddings(varargin)
        % KernelDistributionEmbeddings Constructs an instance of the
        % KernelDistributionEmbeddings algorithm class.

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

        % Specify the parameter defaults.
        defaultLambda = 1;

        defaultSigma = 0.1;

        % Add name/value parameters that are passed to the class constructor.
        addParameter(p, 'Lambda', defaultLambda, validateLambda);

        addParameter(p, 'Sigma',  defaultSigma,  validateSigma);

        % Parse the parameters. These are stored in the p.Results struct after
        % parsing.
        parse(p, varargin{:});

        % Store the parameters in private variables.
        obj.Lambda_ = p.Results.Lambda;

        obj.Sigma_ = p.Results.Sigma;

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

    function C = ComputeKernel(obj, X, Y)

        M = size(X, 2);
        T = size(Y, 2);

        C = zeros(M, T);

        for k = 1:size(X, 1)
            C = C + (repmat(Y(k, :), [M, 1]) - repmat(X(k, :)', [1, T])).^2;
        end

        C = exp(-C/(2*obj.Sigma^2));

    end

end

end

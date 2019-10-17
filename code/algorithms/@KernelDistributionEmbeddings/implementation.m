%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddings implementation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Pr = implementation(obj, problem, samples, x, varargin)
% implementation of the KernelDistributionEmbeddings algorithm.

% Create an inputParser to parse `varargin` and store the parameters.
p = inputParser;

% Allow the inputParser to accept values that are not explicitly defined
% by `addRequired`, `addOptional`, or `addParameter`.
p.KeepUnmatched = true;

% Specify the parameter validation functions.
validateProblem = ...
    @(arg) validateattributes(arg, {'ProblemBaseClass'}, {'nonempty'});

validateSamples = ...
    @(arg) validateattributes(arg, {'SystemSamples'}, {'nonempty'});

validateTestPoints = ...
    @(arg) validateattributes(arg, {'numeric'}, {'nrows', samples.n});

addRequired(p, 'problem', validateProblem);
addRequired(p, 'samples', validateSamples);
addRequired(p, 'x', validateTestPoints);
addOptional(p, 'u', zeros(samples.m, size(x, 2)));

parse(p, problem, samples, x, varargin{:});

end

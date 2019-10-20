%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddings implementation
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Pr = ComputeSafetyProbabilities(algorithm, problem, samples, Xtest, varargin)
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
addRequired(p, 'Xtest', validateTestPoints);
addOptional(p, 'Utest', zeros(samples.m, size(Xtest, 2)));

parse(p, problem, samples, Xtest, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define Constants

Utest = p.Results.Utest;

% The final time for the problem.
N = problem.TimeHorizon;

% Samples from the SystemSamples class.
X = samples.StateSamplesX;
U = samples.InputSamplesU;
Y = samples.StateSamplesY;


M  = size(X, 2);
Mt = size(Xtest, 2);

t_start = tic;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weight matrix.

Gx = algorithm.ComputeKernel(X, X);
Gu = algorithm.ComputeKernel(U, U);

G = Gx.*Gu;

W = inv(G + algorithm.Lambda*M*eye(M));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute value functions.

Vk = zeros(N, M);

cxy = algorithm.ComputeKernel(X, Y);
cuv = algorithm.ComputeKernel(U, U);
beta = cxy.*cuv;
beta = W*beta; %#ok<*MINV>
beta = beta./sum(abs(beta), 1);

switch class(problem)

    case 'FirstHittingTimeProblem'

        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.TargetSet(Y) + ...
                       (problem.ConstraintSet(Y) & ...
                        ~problem.TargetSet(Y)).*(Vk(k+1, :)*beta);
        end

    case 'TerminalHittingTimeProblem'

        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.ConstraintSet(Y).*(Vk(k+1, :)*beta);
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute probabilities for point.

Pr = zeros(N, Mt);

cxt = algorithm.ComputeKernel(X, Xtest);
cut = algorithm.ComputeKernel(U, Utest);
beta = cxt.*cut;
beta = W*beta;
beta = beta./sum(abs(beta), 1);

switch class(problem)

    case 'FirstHittingTimeProblem'

        Pr(N, :) = problem.TargetSet(Xtest);

        for k = N-1:-1:1
            Pr(k, :) = problem.TargetSet(Xtest) + ...
                       (problem.ConstraintSet(Xtest) & ...
                        ~problem.TargetSet(Xtest)).*(Vk(k+1, :)*beta);
        end

    case 'TerminalHittingTimeProblem'

        Pr(N, :) = problem.TargetSet(Xtest);

        for k = N-1:-1:1
            Pr(k, :) = problem.ConstraintSet(Xtest).*(Vk(k+1, :)*beta);
        end

end

end

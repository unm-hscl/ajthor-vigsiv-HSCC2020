%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddings implementation
%
% Implementation of the kernel distribution embeddings for stochastic
% reachability algorithm.
% 
% The ComputeSafetyProbabilities function is the main implementation of the
% algorithm. It usually takes a problem, some samples, and test points, and
% computes the point-based safety probabilities for a particular stochastic
% reachability problem.
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

% Add parameters that are passed to the function.
addRequired(p, 'problem', validateProblem);
addRequired(p, 'samples', validateSamples);
addRequired(p, 'Xtest', validateTestPoints);
addOptional(p, 'Utest', zeros(samples.m, size(Xtest, 2)));

% Parse the parameters. These are stored in the p.Results struct after parsing.
parse(p, problem, samples, Xtest, varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define Constants

% Utest are the inputs corresponding to the Xtest evaluation points.
Utest = p.Results.Utest;

% The final time for the problem.
N = problem.TimeHorizon;

% Samples from the SystemSamples class.
X = samples.StateSamplesX;
U = samples.InputSamplesU;
Y = samples.StateSamplesY;

% The number of samples.
M  = size(X, 2);
% The number of evaluation points.
Mt = size(Xtest, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute weight matrix.

% The Gram matrix for the state samples.
Gx = algorithm.ComputeKernel(X, X);
% The Gram matrix for the input samples.
Gu = algorithm.ComputeKernel(U, U);

% The composite Gram matrix.
G = Gx.*Gu;

% In order to ease computation, we formulate an intermediary 'weight' matrix,
% which is inverted here once, instead of inverting twice later.
W = inv(G + algorithm.Lambda*M*eye(M));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute value functions.

% The value function evaluations at all of the test points.
Vk = zeros(N, M);

% We compute the kernel function between the state input samples and the output
% samples, and the control input samples and itself.
cxy = algorithm.ComputeKernel(X, Y);
cuv = algorithm.ComputeKernel(U, U);

% Then, we compute the coefficients for each sample point.
beta = cxy.*cuv;
beta = W*beta; %#ok<*MINV>

% And normalize the coefficient vector.
beta = beta./sum(abs(beta), 1);

switch class(problem)

    case 'FirstHittingTimeProblem'

        % We compute the terminal value function using the target set. This
        % function is known, while the others need to be estimated.
        Vk(N, :) = problem.TargetSet(Y);

        % For the entire time horizon from [1, N-1] (using the canonical
        % zero-indexing), we compute the value functions for the sample points.
        for k = N-1:-1:2
            Vk(k, :) = problem.TargetSet(Y) + ...
                       (problem.ConstraintSet(Y) & ...
                        ~problem.TargetSet(Y)).*(Vk(k+1, :)*beta);
        end

    case 'TerminalHittingTimeProblem'

        % We compute the terminal value function using the target set. This
        % function is known, while the others need to be estimated.
        Vk(N, :) = problem.TargetSet(Y);

        % For the entire time horizon from [1, N-1] (using the canonical
        % zero-indexing), we compute the value functions for the sample points.
        for k = N-1:-1:2
            Vk(k, :) = problem.ConstraintSet(Y).*(Vk(k+1, :)*beta);
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute probabilities for point.

% Create a matrix to hold the probability values computed using the algorithm.
Pr = zeros(N, Mt);

% Compute the kernel function between the state input samples and the state test
% points, and the control input samples and the input test points.
cxt = algorithm.ComputeKernel(X, Xtest);
cut = algorithm.ComputeKernel(U, Utest);
% Then, we compute the coefficients for each test point.
beta = cxt.*cut;
beta = W*beta;

% And normalize the coefficient vector.
beta = beta./sum(abs(beta), 1);

switch class(problem)

    case 'FirstHittingTimeProblem'

        % We compute the terminal probabilities using the target set. This
        % function is known, while the others need to be estimated.
        Pr(N, :) = problem.TargetSet(Xtest);

        % For the entire time horizon from [0, N-1] (using the canonical
        % zero-indexing), we compute the safety probabilities for the test
        % points.
        for k = N-1:-1:1
            Pr(k, :) = problem.TargetSet(Xtest) + ...
                       (problem.ConstraintSet(Xtest) & ...
                        ~problem.TargetSet(Xtest)).*(Vk(k+1, :)*beta);
        end

    case 'TerminalHittingTimeProblem'

        % We compute the terminal probabilities using the target set. This
        % function is known, while the others need to be estimated.
        Pr(N, :) = problem.TargetSet(Xtest);

        % For the entire time horizon from [0, N-1] (using the canonical
        % zero-indexing), we compute the safety probabilities for the test
        % points.
        for k = N-1:-1:1
            Pr(k, :) = problem.ConstraintSet(Xtest).*(Vk(k+1, :)*beta);
        end

end

% The probabilities Pr are subsequently returned from the function.

end

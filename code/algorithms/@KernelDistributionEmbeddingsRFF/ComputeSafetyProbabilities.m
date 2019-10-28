%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddingsRFF implementation
%
% Implementation of the kernel distribution embeddings for stochastic
% reachability using random Fourier features (RFF) algorithm.
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

addRequired(p, 'problem', validateProblem);
addRequired(p, 'samples', validateSamples);
addRequired(p, 'Xtest', validateTestPoints);
addOptional(p, 'Utest', zeros(samples.m, size(Xtest, 2)));

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
% Compute random fourier features.

% We start with samples from the Gaussian distribution, which is the Fourier
% transform of the Gaussian kernel.
wx = (1/algorithm.Sigma)*randn(algorithm.D, size(X, 1));
wu = (1/algorithm.Sigma)*randn(algorithm.D, size(U, 1));

% We also compute uniform samples from [-2pi 2pi].
bx = (2*pi)*rand(algorithm.D, 1);
bu = (2*pi)*rand(algorithm.D, 1);

% Then, we compute the random Fourier features, which are cosines scaled by a
% constant value.
Zx = (sqrt(2)/sqrt(algorithm.D))*cos(wx*X + bx);
Zu = (sqrt(2)/sqrt(algorithm.D))*cos(wu*U + bu);
Zy = (sqrt(2)/sqrt(algorithm.D))*cos(wx*Y + bx);

% Compute the composite feature vector.
Z = Zx;

% We then compute the feture matrix and the coefficient vector using the
% random Fourier features.
W = Z*Z.' + algorithm.Lambda*M*eye(algorithm.D); %#ok<*MINV>

beta = W\Z;
gamma = beta.'*Zy;

% And normalize the coefficient vector.
gamma = gamma./sum(gamma, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute value functions.
Vk = zeros(N, M);

switch class(problem)

    case 'FirstHittingTimeProblem'

        % We compute the terminal value function using the target set. This
        % function is known, while the others need to be estimated.
        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.TargetSet(Y) + ...
                       (problem.ConstraintSet(Y) & ...
                        ~problem.TargetSet(Y)).* ...
                            (Vk(k+1, :)*gamma);
        end

    case 'TerminalHittingTimeProblem'

        % We compute the terminal value function using the target set. This
        % function is known, while the others need to be estimated.
        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.ConstraintSet(Y).* ...
                (Vk(k+1, :)*gamma);
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute probabilities for point.

% Create a matrix to hold the probability values computed using the algorithm.
Pr = zeros(N, Mt);

% Compute the random Fourier features for the state test points and the input
% test points.
ZXtest = (sqrt(2)/sqrt(algorithm.D))*cos(wx*Xtest + bx);
ZUtest = (sqrt(2)/sqrt(algorithm.D))*cos(wu*Utest + bu);

% Then, we compute the coefficient vector for each test point.
gamma = beta.'*ZXtest;

% And normalize the coefficient vector.
gamma = gamma./sum(gamma, 1);

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
                        ~problem.TargetSet(Xtest)).* ...
                            (Vk(k+1, :)*gamma);
        end

    case 'TerminalHittingTimeProblem'

        % We compute the terminal probabilities using the target set. This
        % function is known, while the others need to be estimated.
        Pr(N, :) = problem.TargetSet(Xtest);

        % For the entire time horizon from [0, N-1] (using the canonical
        % zero-indexing), we compute the safety probabilities for the test
        % points.
        for k = N-1:-1:1
            Pr(k, :) = problem.ConstraintSet(Xtest).* ...
                (Vk(k+1, :)*gamma);
        end

end

% The probabilities Pr are subsequently returned from the function.

end

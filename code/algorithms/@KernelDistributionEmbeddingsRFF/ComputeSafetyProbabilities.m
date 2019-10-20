%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KernelDistributionEmbeddingsRFF implementation
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
% Compute random fourier features.
wx = (1/algorithm.Sigma)*randn(algorithm.D, size(X, 1));
wu = (1/algorithm.Sigma)*randn(algorithm.D, size(U, 1));

bx = (2*pi)*rand(algorithm.D, 1);
bu = (2*pi)*rand(algorithm.D, 1);

Zx = (sqrt(2)/sqrt(algorithm.D))*cos(wx*X + bx);
Zu = (sqrt(2)/sqrt(algorithm.D))*cos(wu*U + bu);
Zy = (sqrt(2)/sqrt(algorithm.D))*cos(wx*Y + bx);

Z = Zx;

H = Z*Z.';
W = H + algorithm.Lambda*M*eye(algorithm.D); %#ok<*MINV>

beta = W\Z;
gamma = beta.'*Zy;

gamma = gamma./sum(gamma, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute value functions.
Vk = zeros(N, M);

switch class(problem)

    case 'FirstHittingTimeProblem'

        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.TargetSet(Y) + ...
                       (problem.ConstraintSet(Y) & ...
                        ~problem.TargetSet(Y)).* ...
                            (Vk(k+1, :)*gamma);
        end

    case 'TerminalHittingTimeProblem'

        Vk(N, :) = problem.TargetSet(Y);

        for k = N-1:-1:2
            Vk(k, :) = problem.ConstraintSet(Y).* ...
                (Vk(k+1, :)*gamma);
        end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute probabilities for point.
Pr = zeros(N, Mt);

% wXtest = (1/algorithm.Sigma)*randn(algorithm.D, size(Xtest, 1));
%
% bXtest = (2*pi)*rand(algorithm.D, 1);

ZXtest = (sqrt(2)/sqrt(algorithm.D))*cos(wx*Xtest + bx);
ZUtest = (sqrt(2)/sqrt(algorithm.D))*cos(wu*Utest + bu);

gamma = beta.'*ZXtest;

gamma = gamma./sum(gamma, 1);

switch class(problem)

    case 'FirstHittingTimeProblem'

        Pr(N, :) = problem.TargetSet(Xtest);

        for k = N-1:-1:1
            Pr(k, :) = problem.TargetSet(Xtest) + ...
                       (problem.ConstraintSet(Xtest) & ...
                        ~problem.TargetSet(Xtest)).* ...
                            (Vk(k+1, :)*gamma);
        end

    case 'TerminalHittingTimeProblem'

        Pr(N, :) = problem.TargetSet(Xtest);

        for k = N-1:-1:1
            Pr(k, :) = problem.ConstraintSet(Xtest).* ...
                (Vk(k+1, :)*gamma);
        end

end

end

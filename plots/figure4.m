%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure4.m
%
% This figure shows the errors of the KernelDistributionEmbeddingsRFF 
% algorithm at various numbers of frequency samples, D. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We start by defining the problem. This means specifying the time horizon, the
% constraint set, or "safe set", and the target set.

% We define the time horizon as N=5.
N = 5;

% For the stochastic chain of integrators example, the safe set is defined as
% |x| <= 1 and the target set is defined as |x| <= 0.5.
K = @(x) all(abs(x) <= 1);
T = @(x) all(abs(x) <= 0.5);

args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
problem = FirstHittingTimeProblem(args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the samples of the system via simulation.
s = linspace(-1.1, 1.1, 50);
X = generateUniformSamples(s);
U = zeros(1, size(X, 2));
W = 0.01.*randn(size(X));

A = [1, 0.25; 0, 1];
B = [0.03125; 0.25];

Y = A*X + B*U + W;

samples = SystemSamples([2 1], 'X', X, 'U', U, 'Y', Y);

% Generate test points.
s = linspace(-1, 1, 100);
Xtest = generateUniformSamples(s);
Utest = zeros(1, size(Xtest, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the algorithm.
args = {'Sigma', 0.1, 'Lambda', 1};
algorithm = KernelDistributionEmbeddingsRFF(args{:});

% Compute the safety probabilities.
n = 4;
Ds = [2000:1000:10000, 20000];
acc = zeros(n, length(Ds));
args = {problem, samples, Xtest, Utest};

for p = 1:length(Ds)

    algorithm.D = Ds(p);

    for q = 1:n

        rng(q);

        Pr = algorithm.ComputeSafetyProbabilities(args{:});

        data = abs(reshape(Pr(1, :), 100, 100) - squeeze(PrDP(1, :, :)));
        acc(q, p) = sum(sum(data))/2500;

    end
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results.
width = 180;
height = 51;

figure('Units', 'points', ...
       'Position', [0, 0, 243, 86])

ax = axes;
ax.Units = 'points';

min_err = min(acc) - mean(acc);
max_err = max(acc) - mean(acc);
ph = errorbar(ax, Ds, mean(acc), min_err, max_err);
% data = reshape(PrBeta(1, :), 100, 100);
% ph = surf(ax, s, s, data);
% ph.EdgeColor = 'none';
% view([0 90]);

ax.XScale = 'log';
ylim([0 1])
yticks([1]);
xticks([5000, 10000, 20000]);

ax.Position = [30, 25, width, height];
ax.XLabel.Interpreter = 'latex';
ax.XLabel.String = 'Number of Frequency Samples';
ax.YLabel.Interpreter = 'latex';
ax.YLabel.String = 'Mean Abs. Error';
set(ax, 'FontSize', 8);

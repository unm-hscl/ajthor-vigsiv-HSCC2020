%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure2.m
%
% This figure shows the results of the two algorithms, as well as the comparison
% to the dynamic programming results. The first plot shows the dynamic
% programming results, the second shows the results from the
% KernelDistributionEmbeddings algorithm. The third shows the absolute error
% between the dynamic programming results and the results from
% KernelDistributionEmbeddings. The fourth shows the results from
% KernelDistributionEmbeddingsRFF. The fifth shows the absolute error between
% the dynamic programming results and the results from
% KernelDistributionEmbeddingsRFF.
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

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samples = SystemSamples(args{:});

% Generate test points.
s = linspace(-1, 1, 100);
Xtest = generateUniformSamples(s);
Utest = zeros(1, size(Xtest, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the algorithm.
args = {'Sigma', 0.1, 'Lambda', 1};
algorithm = KernelDistributionEmbeddings(args{:});

% Compute the safety probabilities.
Pr = algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the algorithm.
args = {'Sigma', 0.1, 'Lambda', 1, 'D', 15000};
algorithm = KernelDistributionEmbeddingsRFF(args{:});

% Compute the safety probabilities.
PrRFF = algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results.

% Load the dynamic programming results for the comparison plots.
load('DynamicProgrammingFHT.mat')

width = 80;
height = 137;

figure('Units', 'points', ...
       'Position', [0, 0, 510, 172])

ax1 = subplot(1, 5, 1, 'Units', 'points');
data = squeeze(PrDP(1, :, :));
ph = surf(ax1, s, s, data);
ph.EdgeColor = 'none';
caxis([0 1]);
view([0 90]);

colorbar(ax1, 'off');
ax1.Position = [30, 25, width, 137];
ax1.YLabel.Interpreter = 'latex';
ax1.YLabel.String = '$x_{2}$';
set(ax1, 'FontSize', 8);

ax2 = subplot(1, 5, 2, 'Units', 'points');
data = reshape(Pr(1, :), 100, 100);
ph = surf(ax2, s, s, data);
ph.EdgeColor = 'none';
caxis([0 1]);
view([0 90]);

colorbar(ax2, 'off');
ax2.YAxis.Visible = 'off';
ax2.Position = [30 + 90, 25, width, 137];
ax2.YLabel.Interpreter = 'latex';
ax2.YLabel.String = '$x_{2}$';
set(ax2, 'FontSize', 8);

ax3 = subplot(1, 5, 3, 'Units', 'points');
data = abs(reshape(Pr(1, :), 100, 100) - squeeze(PrDP(1, :, :)));
ph = surf(ax3, s, s, data);
ph.EdgeColor = 'none';
caxis([0 1]);
view([0 90]);

colorbar(ax3, 'off');
ax3.YAxis.Visible = 'off';
ax3.Position = [30 + 180, 25, width, 137];
ax3.XLabel.Interpreter = 'latex';
ax3.XLabel.String = '$x_{1}$';
ax3.YLabel.Interpreter = 'latex';
ax3.YLabel.String = '$x_{2}$';
set(ax3, 'FontSize', 8);

ax4 = subplot(1, 5, 4, 'Units', 'points');
data = reshape(PrRFF(1, :), 100, 100);
ph = surf(ax4, s, s, data);
ph.EdgeColor = 'none';
caxis([0 1]);
view([0 90]);

colorbar(ax4, 'off');
ax4.YAxis.Visible = 'off';
ax4.Position = [30 + 270, 25, width, 137];
ax4.YLabel.Interpreter = 'latex';
ax4.YLabel.String = '$x_{2}$';
set(ax4, 'FontSize', 8);

ax5 = subplot(1, 5, 5, 'Units', 'points');
data = abs(reshape(PrRFF(1, :), 100, 100) - squeeze(PrDP(1, :, :)));
ph = surf(ax5, s, s, data);
ph.EdgeColor = 'none';
caxis([0 1]);
view([0 90]);

colorbar(ax5);
ax5.YAxis.Visible = 'off';
ax5.Position = [30 + 360, 25, width, 137];
ax5.YLabel.Interpreter = 'latex';
ax5.YLabel.String = '$x_{2}$';
set(ax5, 'FontSize', 8);

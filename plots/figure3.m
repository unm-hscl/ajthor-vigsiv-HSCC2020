%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure3.m
%
% This figure shows the results of the KernelDistributionEmbeddingsRFF 
% algorithm. The plots show the run of the KernelDistributionEmbeddingsRFF
% for a double integrator with a gaussian disturbance at varying number of
% frequency samples. 
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

A = [1, 0.25; 0, 1];
B = [0.03125; 0.25];

s = linspace(-1.1, 1.1, 50);
X = generateUniformSamples(s);
U = zeros(1, size(X, 2));

W = 0.01.*randn(size(X));

Y = A*X + B*U + W;

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samplesWithGauss1Disturbance = SystemSamples(args{:});

W = 0.01.*randn(size(X));

Y = A*X + B*U + W;

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samplesWithGauss2Disturbance = SystemSamples(args{:});

% Generate test points.
s = linspace(-1, 1, 100);
Xtest = generateUniformSamples(s);
Utest = zeros(1, size(Xtest, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the algorithm.
algorithm = KernelDistributionEmbeddingsRFF('Sigma', 0.1, 'Lambda', 1, ...
                                            'D', 10000);

% Compute the safety probabilities.
args = {problem, samplesWithGauss1Disturbance, Xtest, Utest};
PrGauss1 = algorithm.ComputeSafetyProbabilities(args{:});

% Define the algorithm.
algorithm = KernelDistributionEmbeddingsRFF('Sigma', 0.1, 'Lambda', 1, ...
                                            'D', 12500);

% Compute the safety probabilities.
args = {problem, samplesWithGauss2Disturbance, Xtest, Utest};
PrGauss2 = algorithm.ComputeSafetyProbabilities(args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results.
width = 80;
height = 137;

figure('Units', 'points', ...
       'Position', [0, 0, 243, 172])

ax1 = subplot(1, 2, 1, 'Units', 'points');
data = reshape(PrGauss1(1, :), 100, 100);
ph = surf(ax1, s, s, data);
ph.EdgeColor = 'none';
view([0 90]);

colorbar(ax1, 'off');
ax1.Position = [30, 25, width, 137];
ax1.XLabel.Interpreter = 'latex';
ax1.XLabel.String = '$x_{1}$';
ax1.YLabel.Interpreter = 'latex';
ax1.YLabel.String = '$x_{2}$';
set(ax1, 'FontSize', 8);

ax2 = subplot(1, 2, 2, 'Units', 'points');
data = reshape(PrGauss2(1, :), 100, 100);
ph = surf(ax2, s, s, data);
ph.EdgeColor = 'none';
view([0 90]);

colorbar(ax2);
ax2.YAxis.Visible = 'off';
ax2.Position = [30 + 90, 25, width, 137];
ax2.XLabel.Interpreter = 'latex';
ax2.XLabel.String = '$x_{1}$';
ax2.YLabel.Interpreter = 'latex';
ax2.YLabel.String = '$x_{2}$';
set(ax2, 'FontSize', 8);

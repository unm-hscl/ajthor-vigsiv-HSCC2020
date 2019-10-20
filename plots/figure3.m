%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We start by defining the problem. This means specifying the time horizon, the
% constraint set, or "safe set", and the target set.

% We define the time horizon as N=5.
N = 50;

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

W = 0.1.*betarnd(2, 0.5, size(X));

Y = A*X + B*U + W;

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samplesWithBetaDisturbance = SystemSamples(args{:});

W = 0.01.*exprnd(3, size(X));

Y = A*X + B*U + W;

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samplesWithExponentialDisturbance = SystemSamples(args{:});

% Generate test points.
s = linspace(-1, 1, 100);
Xtest = generateUniformSamples(s);
Utest = zeros(1, size(Xtest, 2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the algorithm.
args = {'Sigma', 0.1, 'Lambda', 1};
algorithm = KernelDistributionEmbeddings(args{:});

% Compute the safety probabilities.
args = {problem, samplesWithBetaDisturbance, Xtest, Utest};
PrBeta = algorithm.ComputeSafetyProbabilities(args{:});

% Compute the safety probabilities.
args = {problem, samplesWithExponentialDisturbance, Xtest, Utest};
PrExp = algorithm.ComputeSafetyProbabilities(args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results.
width = 80;
height = 137;

figure('Units', 'points', ...
       'Position', [0, 0, 243, 172])

ax1 = subplot(1, 2, 1, 'Units', 'points');
data = reshape(PrBeta(1, :), 100, 100);
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
data = reshape(PrExp(1, :), 100, 100);
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

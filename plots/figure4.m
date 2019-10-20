%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We start by defining the problem. This means specifying the time horizon, the
% constraint set, or "safe set", and the target set.

% We define the time horizon as N=5.
N = 5;

% Number of quadcopters 
nq = 10

% For the stochastic chain of integrators example, the safe set is defined as
% |x| <= 1 and the target set is defined as |x| <= 0.5.
K = @(x) all(abs(x) <= 1);
T = @(x) all(abs(x) <= 0.5);

args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
problem = FirstHittingTimeProblem(args{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate the samples of the system via simulation.

params.n_copters = 1;
params.N = 5;
params.Ts = 0.25;
params.X_d = [0 0 1 0 0 0]';
params.Xmin = -2.5;
params.Xmax = 2.5;
params.dXmin = 0;
params.dXmax = -0.1;
params.Ymin = -0.1;
params.Ymax = 1;
params.dYmin = -0.1;
params.dYmax = 0.1;
params.Tmin = -pi;
params.Tmax = pi;
params.dTmin = -0.1;
params.dTmax = 0.1;
params.el = [10, 2, 10, 2, 4, 2];
params.Umin = -1;
params.Umax = 1;

[X,Y] = generate_samples_quad(params);

args = {[2 1], 'X', X, 'U', U, 'Y', Y};
samplesWithBetaDisturbance = SystemSamples(args{:});

% Generate test points.
s = linspace(-1, 1, 100);
[X1, X2] = meshgrid(s);
Xtest = [reshape(X1, 1, []); reshape(X2, 1, [])];
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
surf(ax1, s, s, reshape(PrBeta(1, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax1, 'off');
ax1.Position = [30, 25, width, 137];
ax1.XLabel.Interpreter = 'latex';
ax1.XLabel.String = '$x_{1}$';
ax1.YLabel.Interpreter = 'latex';
ax1.YLabel.String = '$x_{2}$';
set(ax1, 'FontSize', 8);

ax2 = subplot(1, 2, 2, 'Units', 'points');
surf(ax2, s, s, reshape(PrExp(1, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax2);
ax2.YAxis.Visible = 'off';
ax2.Position = [30 + 90, 25, width, 137];
ax2.XLabel.Interpreter = 'latex';
ax2.XLabel.String = '$x_{1}$';
ax2.YLabel.Interpreter = 'latex';
ax2.YLabel.String = '$x_{2}$';
set(ax2, 'FontSize', 8);

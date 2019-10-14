
N = 5;
K = srt.Tube(N, Polyhedron('lb', [-10; 0; -5; -100;-100;-100], 'ub', [10; 1000; 5;100;100;100]));
T = srt.Tube(N, Polyhedron('lb', [-5; 0.8; -2; -100;-100;-100], 'ub', [10; 1000; 2;100;100;100]));

prb = srt.problems.FirstHitting('ConstraintTube', K, 'TargetTube', T);

Xmin = -10;
Xmax = 10; 
Ymin = -10; 
Ymax = 10;
Tmin = -1; 
Tmax = 1;
dXmin = 0;
dXmax = 1;
dYmin = 0;
dYmax = 1;
dTmin = 0;
dTmax = 1;

el = [7, 3, 10, 3, 5, 3];
fprintf('Number of elements: %d\n', prod(el));

X = linspace(Xmin, Xmax, el(1));
dX = linspace(dXmin, dXmax, el(2));
Y = linspace(Ymin, Ymax, el(3));
dY = linspace(dYmin, dYmax, el(4));
T = linspace(Tmin, Tmax, el(5));
dT = linspace(dTmin, dTmax, el(6));

[dTdT, TT, dYdY, YY, dXdX, XX] = ndgrid(dT, T, dY, Y, dX, X);

X = reshape(XX, 1, []);
dX = reshape(dXdX, 1, []);
Y = reshape(YY, 1, []);
dY = reshape(dYdY, 1, []);
T = reshape(TT, 1, []);
dT = reshape(dTdT, 1, []);

% Generate input samples.
U = [5; 5];

%% Generate sample vectors.
% Subscript 's' means sample vector.
X = [X; dX; Y; dY; T; dT];

% Covariance matrix. 
% Each element along the diagonal is the disturbance of a particular
% variable. I arbitrarily set the disturbance on X/Y/T to 1E-3.
S = [ 1E-3, 5E-8, 1E-3, 5E-8, 1E-3, 5E-8];

m = 5; 
r = 2;
I = 2;
Ts = 0.25;



Y(1,:) = X(1,:) + Ts*X(4,:)+ S(1)*randn(1, prod(el));
Y(2,:) = X(2,:) + Ts*X(5,:)+ S(2)*randn(1, prod(el));
Y(3,:) = X(3,:) + Ts*X(6,:)+ S(3)*randn(1, prod(el));
Y(4,:) = -Ts*m*sin(X(3,:))*(U(1)+U(2)) + X(4,:) + S(4)*randn(1, prod(el));
Y(5,:) = Ts*m*cos(X(3,:))*(U(1)+U(2)) + X(5,:) + S(5)*randn(1, prod(el));
Y(6,:) = Ts*r/I*(U(1)-U(2)) + X(6,:) + S(6)*randn(1, prod(el));

sys = srt.systems.SampledSystem('X', X, 'U', U, 'Y', Y);

alg = srt.algorithms.KernelEmbeddings('sigma', 0.1, 'lambda', 1);

el = [7, 3, 10, 3, 5, 3];
fprintf('Number of elements: %d\n', prod(el));

X = linspace(Xmin, Xmax, el(1));
dX = linspace(dXmin, dXmax, el(2));
Y = linspace(Ymin, Ymax, el(3));
dY = linspace(dYmin, dYmax, el(4));
T = linspace(Tmin, Tmax, el(5));
dT = linspace(dTmin, dTmax, el(6));

[dTdT, TT, dYdY, YY, dXdX, XX] = ndgrid(dT, T, dY, Y, dX, X);

X = reshape(XX, 1, []);
dX = reshape(dXdX, 1, []);
Y = reshape(YY, 1, []);
dY = reshape(dYdY, 1, []);
T = reshape(TT, 1, []);
dT = reshape(dTdT, 1, []);

% Generate input samples.
U = [5; 5];

%% Generate sample vectors.
% Subscript 's' means sample vector.
X = [X; dX; Y; dY; T; dT];

U = [5;5;];

results = SReachPoint(prb, alg, sys, X, U);

%%

width = 80;
height = 137;

figure('Units', 'points', ...
       'Position', [0, 0, 510, 172])
   
ax1 = subplot(1, 5, 1, 'Units', 'points');
surf(ax1, s, s, reshape(results.Pr(5, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax1, 'off');
ax1.Position = [30, 25, width, 137];
% ax1.XLabel.Interpreter = 'latex';
% ax1.XLabel.String = '$x_{1}$';
ax1.YLabel.Interpreter = 'latex';
ax1.YLabel.String = '$x_{2}$';
set(ax1, 'FontSize', 8);

ax2 = subplot(1, 5, 2, 'Units', 'points');
surf(ax2, s, s, reshape(results.Pr(4, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax2, 'off');
ax2.YAxis.Visible = 'off';
ax2.Position = [30 + 90, 25, width, 137];
% ax2.XLabel.Interpreter = 'latex';
% ax2.XLabel.String = '$x_{1}$';
ax2.YLabel.Interpreter = 'latex';
ax2.YLabel.String = '$x_{2}$';
set(ax2, 'FontSize', 8);

ax3 = subplot(1, 5, 3, 'Units', 'points');
surf(ax3, s, s, reshape(results.Pr(3, :), 100, 100), 'EdgeColor', 'none');
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
surf(ax4, s, s, reshape(results.Pr(2, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax4, 'off');
ax4.YAxis.Visible = 'off';
ax4.Position = [30 + 270, 25, width, 137];
% ax4.XLabel.Interpreter = 'latex';
% ax4.XLabel.String = '$x_{1}$';
ax4.YLabel.Interpreter = 'latex';
ax4.YLabel.String = '$x_{2}$';
set(ax4, 'FontSize', 8);

ax5 = subplot(1, 5, 5, 'Units', 'points');
surf(ax5, s, s, reshape(results.Pr(1, :), 100, 100), 'EdgeColor', 'none');
view([0 90]);

colorbar(ax5);
ax5.YAxis.Visible = 'off';
ax5.Position = [30 + 360, 25, width, 137];
% ax5.XLabel.Interpreter = 'latex';
% ax5.XLabel.String = '$x_{1}$';
ax5.YLabel.Interpreter = 'latex';
ax5.YLabel.String = '$x_{2}$';
set(ax5, 'FontSize', 8);
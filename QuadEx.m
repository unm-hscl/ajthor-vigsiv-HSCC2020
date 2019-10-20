%% ACC20-FHT: Hovering Planar Quadcopter
% This code runs a planar quadcopter which is linearized about a hover
% point. The goal is to come up with a deterministic, open loop control
% input which is applied to the quadcopter with an updraft. The goal is to
% determine the first hitting time probability in the prescence of such a 
% disturbance. 
% REQUIRED DEPENDENCIES: 
%                        - SReachTools
%                          (https://unm-hscl.github.io/SReachTools/)

%% Housekeeping: 

clc, clear, close all

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
params.dtype = 1;

[Ys,Xs] = generate_samples_quad(params);
Xt = generate_samples_quad(params);


% load('quadGaussianSamples.mat');

figure
hold on
scatter(Ys(1, :), Ys(3, :));


% Replicate  the target and safe-set for all quadcopters: 

target_set_x = [-1 1]';

for k = 1:(params.n_copters-1)
    
    target_set_x(2*(k)+1:2*(k+1),:)  = target_set_x(2*(k-1)+1:2*k,:)+params.Xmax; 
    
end

safe_set_x = [-2 2]';

for k = 1:(params.n_copters-1)
    
    safe_set_x(2*(k)+1:2*(k+1),:)  = safe_set_x(2*(k-1)+1:2*k,:)+params.Xmax;

end


%% Generate samples of the dynamics.
%
% Bring in samples, computed for the concated quadcopter: 
m = size(Xs, 2);

%% Calculate the kernel matrix.
%
% The kernel (Gram) matrix is defined as K_ij = K(x, x'). Here, we use the
% Gaussian kernel with a bandwidth parameter sigma.


K = zeros(m);

% Iteratively calculate the norm for each pair of samples.
% I.e. (x_i1 - x_j1)^2 + (x_i2 - x_j2)^2 + ... + (x_iD - x_jD)^2
for p = 1:2
  K = K + (repmat(Xs(p, :), [m, 1]) - repmat(Xs(p, :)', [1, m])).^2;
end

% Element-wise kernel function.
K = exp(-K/(2*0.1^2));



%% Compute the weight matrix.
%
% The weight matrix is defined as (K + lambda*m*I)^-1.

% Here, we wait to invert the matrix to take advantage of Matlab's faster
% inversion using backslash.

lambda = 1;

W = K + lambda * m * eye(m);

%% Compute the value function for the output samples.
%
% Here, we compute the value function V_k(x') over the output samples. Since we
% assume that the value function is the same over the entire time horizon, we
% don't recompute this for each time step.

Vk = compute_value_functions(params.N, Xs, Ys, W,target_set_x,safe_set_x);

%% Generate test samples.
%
% Compute input samples for the test points.
% Xt = generate_samples_quad(params);
load('quadGaussianTestSamples.mat')

mt = size(Xt, 2);

%% Compute beta values.
Beta = zeros(m, mt);

for k = 1:mt
  Beta(:, k) = sum((Xs - Xt(:, k)).^2, 1)';
end

% Currently, Beta is K(X, Xt)
Beta = exp(-Beta/(2*0.1^2));

Beta = W\Beta;
Beta = Beta./sum(Beta, 1);

%% Compute the transition probabilities.
Pr = zeros(params.N, mt);


Pr(params.N, :) = prod(double(Xt(3:6:end, :) >= 0.8 & ...
                  Xt(1:6:end, :) >= target_set_x(1:2:end)& ...
                  Xt(1:6:end, :) <= target_set_x(2:2:end)),1);

for k = params.N-1:-1:1

    
  Pr(k, :) = prod(double(Xt(3:6:end, :) >= 0.8& ...
                  Xt(1:6:end, :) >= target_set_x(1:2:end)& ...
                  Xt(1:6:end, :) <= target_set_x(2:2:end)),1) + ...
               prod(double(Xt(3:6:end, :) >= 0 & ...
                  Xt(1:6:end, :) >= safe_set_x(1:2:end)& ...
                  Xt(1:6:end, :) <= safe_set_x(2:2:end)& ...
                  Xt(3:6:end, :) < 0.8),1).*(Vk(k+1, :)*Beta);

end



%% Plot the value function surface.

%Create regular grid across data space
x = Xt(1, :);
y = Xt(3, :);
n = 100;

[XX, YY] = meshgrid(linspace(min(x),max(x),n), linspace(min(y),max(y),n));

% % create contour plot
% contour(XX, YY, griddata(x, y, Pr(1, :), XX, YY));
% xlim([-1.1, 1.1]);
% ylim([-1.1, 1.1]);
% caxis([0 1]);

% figure('Units', 'points', ...
       % 'Position', [0, 0, 245, 172])
figure
surf(XX, YY, griddata(x, y, Pr(params.N, :), XX, YY), 'EdgeColor','none');
% xlim([-2, 2]);
% ylim([-2, 0]);
xlabel('$x_{1}$', 'Interpreter', 'latex')
ylabel('$x_{2}$', 'Interpreter', 'latex')
caxis([0 1]);
colorbar
view([0, 90]);
set(gca, 'FontSize', 8, 'FontName','Times');


%% Plot side-by-side value function surfaces. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

for k = params.N:-1:1
  subplot(1, params.N, k);
  ax = surf(XX, YY, griddata(x, y, Pr(k, :), XX, YY));
  ax.EdgeColor = 'none';
  xlabel('$x_{1}$', 'Interpreter', 'latex')
  ylabel('$x_{2}$', 'Interpreter', 'latex')
  caxis([0 1]);
  axis([-1.1 1.1 0.5 1])
  colorbar
  view([0, 90]);
  set(gca, 'FontSize', 8, 'FontName','Times');
end
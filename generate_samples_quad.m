function varargout = generate_samples_quad(m,params,varargin)
% GENERATE_SAMPLES_INT2D Generate samples for a 2-D integrator.
%
%   GENERATE_SAMPLES_INT2D(m) Generates m samples for a 2-D integrator.
%
%   GENERATE_SAMPLES_INT2D parameters:
%
%   SampleVariance      - The variance on the initial condition x_0.
%   DisturbanceVariance - The variance of the disturbance w_0.
%   DisturbanceMatrix   - The real-valued matrix G in the system equations.
%
%   x[k+1] = A*x[k] + G*w[k]

% Load the state matrix.
% data = load('cwh.mat');

rng(0);

% % Plot on?
% plot_on = true;

n_copters = params.n_copters;
N = params.N;
Xmin = params.Xmin;
Xmax = params.Xmax;
Ymin = params.Ymin;
Ymax = params.Ymax;
Tmin = params.Tmin;
Tmax = params.Tmax;

Umin = params.Umin;
Umax = params.Umax;

% Each element in this vector is the number of samples along each
% dimension. So the first element corresponds to X, the second dX, etc.
% Total number of samples is the product of this vector.
el = [10, 10, 10];
fprintf('Number of elements: %d\n', prod(el));

X = linspace(Xmin, Xmax, el(1));
Y = linspace(Ymin, Ymax, el(2));
T = linspace(Tmin, Tmax, el(3));

[TT, YY, XX] = ndgrid(T, Y, X);

X = reshape(XX, 1, []);
Y = reshape(YY, 1, []);
T = reshape(TT, 1, []);

% Generate input samples.
U = [5; 5];

%% Generate sample vectors.
% Subscript 's' means sample vector.
Xs = [X; Y; T;];
Us = U;

% Covariance matrix. 
% Each element along the diagonal is the disturbance of a particular
% variable. I arbitrarily set the disturbance on X/Y/T to 1E-3.
S = 10*[ 1E-3, 1E-3, 1E-3];
S = repmat(S, 1, n_copters);

Sigma = sparse(1:n_copters*3, 1:n_copters*3, S);

% if plot_on
%     % Show the nonzero elements of the covariance matrix.
%     figure
%     spy(Sigma);
% end


% Repeat for however many copters you have.
Xs = repmat(Xs, n_copters, 1);
Us = repmat(Us, n_copters, 1);

% Shift the X values for all copters.
for k = 4:3:n_copters*3
    Xs(k, :) = Xs(k-3, :) + Xmax;
end

%% Generate system matrices.

m = 5; 
r = 2;
I = 2;
Ts = 0.25;





% if plot_on
%     % Show the nonzero elements of the A matrix.
%     figure
%     spy(A);
% end

% if plot_on
%     % Show the nonzero elements of the B matrix.
%     figure
%     spy(B);
% end

%% Generate output samples.

for i = 1:N
    
    if i == 1

        Ys(1,:) = -Ts*m*sin(Xs(3,:))*(U(1)+U(2)) + Xs(1,:) + Sigma(1,1)*randn(1, prod(el));
        Ys(2,:) = Ts*m*cos(Xs(3,:))*(U(1)+U(2)) + Xs(2,:) + Sigma(2,2)*randn(1, prod(el));
        Ys(3,:) = Ts*r/I*(U(1)-U(2)) + Xs(3,:) + Sigma(3,3)*randn(1, prod(el));
        
        
        
    else
        Xs = Ys;
        Ys(1,:) = -Ts*m*sin(Xs(3,:))*(U(1)+U(2)) + Xs(1,:);
        Ys(2,:) = Ts*m*cos(Xs(3,:))*(U(1)+U(2)) + Xs(2,:);
        Ys(3,:) = Ts*r/I*(U(1)-U(2)) + Xs(3,:);
        
    end
    
end
    

switch nargout
case 1
  % varargout{1} = [Xs; Ys; dXs; dYs];
  varargout{1} = Ys;
case 2
  varargout{1} = Ys;
  varargout{2} = Xs;
end

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
dXmin = params.dXmin;
dXmax = params.dXmax;
Ymin = params.Ymin;
Ymax = params.Ymax;
dYmin = params.dYmin;
dYmax = params.dYmax;
Tmin = params.Tmin;
Tmax = params.Tmax;
dTmin = params.dTmin;
dTmax = params.dTmax;

Umin = params.Umin;
Umax = params.Umax;

% Each element in this vector is the number of samples along each
% dimension. So the first element corresponds to X, the second dX, etc.
% Total number of samples is the product of this vector.
el = [10, 3, 10, 3, 3, 3];
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
Xs = [X; dX; Y; dY; T; dT];
Us = U;

% Covariance matrix. 
% Each element along the diagonal is the disturbance of a particular
% variable. I arbitrarily set the disturbance on X/Y/T to 1E-3.
S = [ 1E-3, 5E-8, 1E-3, 5E-8, 1E-5, 5E-8];
S = repmat(S, 1, n_copters);

Sigma = sparse(1:n_copters*6, 1:n_copters*6, S);

% if plot_on
%     % Show the nonzero elements of the covariance matrix.
%     figure
%     spy(Sigma);
% end


% Repeat for however many copters you have.
Xs = repmat(Xs, n_copters, 1);
Us = repmat(Us, n_copters, 1);

% Shift the X values for all copters.
for k = 7:6:n_copters*6
    Xs(k, :) = Xs(k-6, :) + Xmax;
end

%% Generate system matrices.

m = 5; 
r = 2;
I = 2;
g = 9.81;
Ts = 0.25;

A = [0 1 0 0   0 0;
     0 0 0 0   0 0;
     0 0 0 1   0 0;
     0 0 0 0   0 0;
     0 0 0 0   0 1;
     0 0 0 0   0 0;];
 
B = [0     0;
     0     0;
     0     0;
     1/m 1/m;
     0     0;
     r/I -r/I;];
 
sys = ss(A,B,eye(1,size(A,2)),0);

sysd = c2d(sys,Ts);

A = sysd.A;
B = sysd.B;
         
A = kron(speye(n_copters),A);


% if plot_on
%     % Show the nonzero elements of the A matrix.
%     figure
%     spy(A);
% end

B = kron(speye(n_copters),B);

% if plot_on
%     % Show the nonzero elements of the B matrix.
%     figure
%     spy(B);
% end

%% Generate output samples.

for i = 1:N
    
    if i == 1

        Ys(1,:) = Xs(1,:) + Ts*Xs(2,:) + S(1)*randn(1, prod(el));
        Ys(2,:) = -Ts/m*sin(Xs(3,:))*(U(1)+U(2)) + Xs(2,:) + S(2)*randn(1, prod(el));
        Ys(3,:) = Xs(3,:) + Ts*Xs(4,:)+ S(3)*randn(1, prod(el));
        Ys(4,:) = Ts/m*cos(Xs(3,:))*(U(1)+U(2)) - Ts/g + Xs(4,:) + S(4)*randn(1, prod(el));
        Ys(5,:) = Xs(5,:) + Ts*Xs(6,:)+ S(5)*randn(1, prod(el));
        Ys(6,:) = Ts*r/I*(U(1)-U(2)) + Xs(6,:) + S(6)*randn(1, prod(el));
        
        
        
    else
        Xs = Ys;
        Ys = A*Xs + B*Us + Sigma*randn(6*n_copters, prod(el));
        
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

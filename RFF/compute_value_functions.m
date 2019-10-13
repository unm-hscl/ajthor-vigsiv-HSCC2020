function varargout = compute_value_functions(N, X, Y, W,target_set_x,safe_set_x, varargin)
% COMPUTE_VALUE_FUNCTIONS_CWH Compute value functions for a CWH system.
%
%   COMPUTE_VALUE_FUNCTIONS_CWH(N, X, Y, W) Computes the value functions for
%   data in X and Y. X is input data, Y is output data. We assume there is no
%   control input (it is already incorporated into the samples) such that
%
%   y ~ Q(.|x)
%
%   COMPUTE_VALUE_FUNCTIONS_CWH parameters:
%
%   X - Input data in column format. The vectors should be stored in each column
%   so that for a D-dimensional system, X is [DxM], where M is the number of
%   sample points.
%   Y - Output data in column format. The vectors should be stored in each
%   column so that for a D-dimensional system, Y is [DxM], where M is the number
%   of sample points.
%   W - The (non-inverted) weight matrix.

D = 1000;
Vk = zeros(N, size(X, 2));

% for k = 1:m
%   Beta(:, k) = sum((X - Y(:, k)).^2, 1)';
% end
% 
% Beta = exp(-Beta/(2*0.1^2));

%% RFF kernel approximation: 




Beta = zeros(D);
sigma = 1; 
omega_x = sigma^2.*randn(size(X, 1), D);
z_x = exp(1i*omega_x.'*X);

omega_y = sigma^2.*randn(size(Y, 1), D);
z_y = exp(1i*omega_y.'*Y);


Beta = z_x;


Beta = W\Beta;

Beta = Beta'*z_y;

% Compute the terminal value function on Y.
Vk(N, :) = prod(double(Y(3:6:end, :) >= 0.8 - eps& ...
                  Y(1:6:end, :) >= target_set_x(1:2:end) - eps & ...
                  Y(1:6:end, :) <= target_set_x(2:2:end)-eps) ,1); 


for k = N-1:-1:1

    Vk(k, :) = prod(double(Y(3:6:end, :) >= 0.8 - eps & ...
                  Y(1:6:end, :) >= target_set_x(1:2:end) - eps & ...
                  Y(1:6:end, :) <= target_set_x(2:2:end)) - eps,1)+ ...
               prod(double(Y(3:6:end, :) >= 0 & ...
                  Y(1:6:end, :) >= safe_set_x(1:2:end) - eps & ...
                  Y(1:6:end, :) <= safe_set_x(2:2:end) - eps),1).*(Vk(k+1, :)*Beta); 
end

varargout{1} = Vk;
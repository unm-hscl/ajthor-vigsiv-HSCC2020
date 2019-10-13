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

m = size(X, 2);
Vk = zeros(N, m);

Beta = zeros(m);

for k = 1:m
  Beta(:, k) = sum((X - Y(:, k)).^2, 1)';
end

Beta = exp(-Beta/(2*0.1^2));
Beta = W\Beta;
Beta = Beta./(sum(abs(Beta), 1) + eps);

% Compute the terminal value function on Y.
Vk(N, :) = prod(double(Y(2:3:end, :) >= 0.8 - eps& ...
                  Y(1:3:end, :) >= target_set_x(1:2:end) - eps & ...
                  Y(1:3:end, :) <= target_set_x(2:2:end)) - eps ,1); 


for k = N-1:-1:1

    Vk(k, :) = prod(double(Y(2:3:end, :) >= 0.8 - eps & ...
                  Y(1:3:end, :) >= target_set_x(1:2:end) - eps & ...
                  Y(1:3:end, :) <= target_set_x(2:2:end)) - eps,1)+ ...
               prod(double(Y(2:6:end, :) >= 0 & ...
                  Y(1:3:end, :) >= safe_set_x(1:2:end) - eps & ...
                  Y(1:3:end, :) <= safe_set_x(2:2:end) - eps),1).*(Vk(k+1, :)*Beta); 
end

varargout{1} = Vk;
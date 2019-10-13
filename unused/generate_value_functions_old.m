function varargout = generate_value_functions(N, X, Y, W, target_set_x,safe_set_x)
% GENERATE_VALUE_FUNCTIONS_CWH Generate value functions for a CWH system.
%
%   GENERATE_VALUE_FUNCTIONS_CWH(N, X)
%
%   x[k+1] = A*x[k] + G*w[k]

m = size(X, 2);

Vk = zeros(N, m);

Vk(N, :) = prod(double(Y(3:6:end, :) <= 1 & ...
                  Y(3:6:end, :) >= 0.8 & ...
                  X(1:6:end, :) >= target_set_x(1:2:end) & ...
                  X(1:6:end, :) <= target_set_x(2:2:end)),1); 
              

Beta = zeros(m);

for k = 1:m
  Beta(:, k) = sum((X - Y(:, k)).^2, 1)';
end

Beta = exp(-Beta/(2*0.1^2));
Beta = W\Beta;
Beta = Beta./(sum(abs(Beta), 1) + eps);

for k = N-1:-1:1
   
   Vk(k, :) = prod(double(Y(3:6:end, :) <= 1 & ...
                  Y(3:6:end, :) >= 0.8 & ...
                  X(1:6:end, :) >= target_set_x(1:2:end) & ...
                  X(1:6:end, :) <= target_set_x(2:2:end)),1)+ ...
              prod(double(Y(3:6:end, :) <= 1 & ...
                  Y(3:6:end, :) >= 0.8 & ...
                  X(1:6:end, :) >= safe_set_x(1:2:end) & ...
                  X(1:6:end, :) <= safe_set_x(2:2:end)),1).*(Vk(k+1, :)*Beta); 
  

end

switch nargout
case 1
  varargout{1} = Vk;
end
end
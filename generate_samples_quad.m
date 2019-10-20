function varargout = generate_samples_quad(params,varargin)

rng(0);

N = params.N;
Ts = params.Ts;
X_d = params.X_d; 
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
dtype = params.dtype;


% el  = [10, 2, 10, 2, 4, 2]; 
el = params.el;



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

%% System parameters: 

m = 5; 
r = 2;
I = 2;
g = 9.81;


%% Generate sample vectors.

XX = [];
YY = [];

% For the state
Xs = [X; dX; Y; dY; T; dT];

% For the disturbance: 

% For the output:

    for k = 1:size(Xs,2)
        k
        U = quadInputGen(60,Ts,Xs(:,k),X_d);  
        U = reshape(U, 2, []);

        if dtype == 1
            Ys(1,k) = Xs(1,k) + Ts*Xs(2,k) + 1E-3*randn(1);
            Ys(2,k) = -Ts/m*sin(Xs(3,k))*(U(1,1)+U(2,1)) + Xs(2,k) + 1E-5*randn(1);
            Ys(3,k) = Xs(3,k) + Ts*Xs(4,k)+ 1E-3*randn(1);
            Ys(4,k) = Ts/m*cos(Xs(3,k))*(U(1,1)+U(2,1)) - Ts/g + Xs(4,k) + 1E-5*randn(1);
            Ys(5,k) = Xs(5,k) + Ts*Xs(6,k) + 1E-3*randn(1);
            Ys(6,k) = Ts*r/I*(U(1,1)-U(2,1)) + Xs(6,k) + 1E-5*randn(1);
        elseif dtype == 2
            Ys(1,k) = Xs(1,k) + Ts*Xs(2,k) + 0.1*betarnd(1,0.5);
            Ys(2,k) = -Ts/m*sin(Xs(3,k))*(U(1,1)+U(2,1)) + Xs(2,k) + 0.1*betarnd(1,0.5);
            Ys(3,k) = Xs(3,k) + Ts*Xs(4,k)+ 0.1*betarnd(1,0.5);
            Ys(4,k) = Ts/m*cos(Xs(3,k))*(U(1,1)+U(2,1)) - Ts/g + Xs(4,k) + 0.1*betarnd(1,0.5);
            Ys(5,k) = Xs(5,k) + Ts*Xs(6,k) + 0.1*betarnd(1,0.5);
            Ys(6,k) = Ts*r/I*(U(1,1)-U(2,1)) + Xs(6,k) + 0.1*betarnd(1,0.5);
        end

    end

    
switch nargout
case 2
  varargout{1} = Ys;
  varargout{2} = Us;
case 3
  varargout{1} = Ys;
  varargout{2} = Xs;
  varargout{2} = Us;
end

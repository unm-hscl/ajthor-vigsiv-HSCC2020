clc, clear, close all

% Approximates Gaussian Process regression
%     with Gaussian kernel of variance gamma^2
% lambda: regularization parameter
% dataset: X is dxN, y is 1xN
% test: xtest is dx1
% D: dimensionality of random feature
d = 2; 
N = 1000; 
D = 100;
% training
X = rand(d,N);
y = rand(1,N);
w = randn(D,d);
gamma = 1;
lambda = 1;
b = 2 * pi * rand(D, 1);
Z = cos(gamma * w * X + b * ones(1,N));

alpha = (lambda * eye(D) +Z * Z') \ (Z * y);

xtest = rand(d,N);
% testing
ztest = alpha' * cos(gamma * w * xtest + b);
y(1)
ztest(1)
%% Multimodal distribution plot

%% Housekeeping
clc, clear, close all

mu = [5 3; 6 2];
sigma = cat(30,[0.1 0.5],[0.5 0.1]); % 1-by-2-by-2 array

gm = gmdistribution(mu,sigma);
fsurf(@(x,y)reshape(pdf(gm,[x(:) y(:)]),size(x)),[-10 10])
view([0 90]);
grid off
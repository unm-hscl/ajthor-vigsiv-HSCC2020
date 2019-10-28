%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generateUniformSamples
%
% Generates uniform samples is a helper utility which takes a range, e.g. 1:10,
% and produces a mesh of samples organized into a sample vector. This produces a
% grid of 2-D points.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = generateUniformSamples(varargin)

ni = nargin;

if nargin == 1

    s1 = varargin{1};
    s2 = varargin{1};

elseif nargin == 2

    s1 = varargin{1};
    s2 = varargin{2};

else

    error('Incorrect number of parameters.');

end

% Create a meshgrid of ranges.
[X1, X2] = meshgrid(s1, s2);

% Reshape and concatenate the meshes into a sample vector.
X = [
    reshape(X1, 1, []);
    reshape(X2, 1, [])
];

end

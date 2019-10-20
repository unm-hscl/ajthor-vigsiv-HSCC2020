%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
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

[X1, X2] = meshgrid(s1, s2);

X = [
    reshape(X1, 1, []);
    reshape(X2, 1, [])
];

end

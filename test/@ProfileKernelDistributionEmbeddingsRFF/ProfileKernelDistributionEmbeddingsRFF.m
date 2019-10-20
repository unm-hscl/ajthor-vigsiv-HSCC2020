%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Profile the KernelDistributionEmbeddings algorithm.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef ProfileKernelDistributionEmbeddingsRFF < matlab.perftest.TestCase
% KernelDistributionEmbeddingsProfiler profiles

properties
    problem

    samples
    Xtest
    Utest

    algorithm
end

methods (TestMethodSetup)
    function defineProblem(testCase)
        % We define the time horizon as N=5.
        N = 5;

        % For the stochastic chain of integrators example, the safe set is
        % defined as |x| <= 1 and the target set is defined as |x| <= 0.5.
        K = @(x) all(abs(x) <= 1);
        T = @(x) all(abs(x) <= 0.5);

        args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
        problem = FirstHittingTimeProblem(args{:});

        testCase.problem = problem;

    end

    function generateSamples(testCase)
        % Generate the samples of the system via simulation.
        s = linspace(-1.1, 1.1, 50);
        [X1, X2] = meshgrid(s);
        X = [reshape(X1, 1, []); reshape(X2, 1, [])];

        U = zeros(1, size(X, 2));

        W = 0.01.*randn(size(X));

        A = [1, 0.25; 0, 1];
        B = [0.03125; 0.25];

        Y = A*X + B*U + W;

        samples = SystemSamples([2 1], 'X', X, 'U', U, 'Y', Y);

        % Generate test points.
        s = linspace(-1, 1, 100);
        [X1, X2] = meshgrid(s);
        Xtest = [reshape(X1, 1, []); reshape(X2, 1, [])];
        Utest = zeros(1, size(Xtest, 2));

        testCase.samples = samples;
        testCase.Xtest = Xtest;
        testCase.Utest = Utest;
    end

    function defineAlgorithm(testCase)
        % Define the algorithm.

        args = {'Sigma', 0.1, 'Lambda', 1, 'D', 15000};
        algorithm = KernelDistributionEmbeddingsRFF(args{:});

        testCase.algorithm = algorithm;

    end
end

methods (Test)

    function profileChainOfIntegratorsWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileChainOfIntegratorsWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileChainOfIntegratorsWithExponentialDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profilePlanarQuadrotorWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profilePlanarQuadrotorWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileRepeatedPlanarQuadrotorWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileRepeatedPlanarQuadrotorWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.problem; %#ok<*PROP>

        samples     = testCase.samples;
        Xtest       = testCase.Xtest;
        Utest       = testCase.Utest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

end

end

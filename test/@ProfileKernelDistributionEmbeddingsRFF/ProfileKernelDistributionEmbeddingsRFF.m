%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Profile the KernelDistributionEmbeddings algorithm.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef ProfileKernelDistributionEmbeddingsRFF < matlab.perftest.TestCase
% KernelDistributionEmbeddingsProfiler profiles

properties
    IntegratorProblem
    QuadrotorProblem
    RepeatedQuadrotorProblem

    IntegratorSamplesWithGaussianDisturbance
    IntegratorSamplesWithBetaDisturbance
    IntegratorSamplesWithExponentialDisturbance

    QuadrotorSamplesWithGaussianDisturbance
    QuadrotorSamplesWithBetaDisturbance

    RepeatedQuadrotorSamplesWithGaussianDisturbance
    RepeatedQuadrotorSamplesWithBetaDisturbance

    IntegratorXtest
    IntegratorUtest

    QuadrotorXtest
    QuadrotorUtest

    RepeatedQuadrotorXtest
    RepeatedQuadrotorUtest

    algorithm
end

methods (TestMethodSetup)

    function defineProblemForIntegrator(testCase)
        % We define the time horizon as N=5.
        N = 5;

        % For the stochastic chain of integrators example, the safe set is
        % defined as |x| <= 1 and the target set is defined as |x| <= 0.5.
        K = @(x) all(abs(x) <= 1);
        T = @(x) all(abs(x) <= 0.5);

        args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
        problem = FirstHittingTimeProblem(args{:});

        testCase.IntegratorProblem = problem;

    end

    function defineProblemForQuadrotor(testCase)
        % We define the time horizon as N=5.
        N = 5;

        % For the stochastic chain of integrators example, the safe set is
        % defined as |x| <= 1 and the target set is defined as |x| <= 0.5.
        K = @(x) all(0 <= x(1) & x(1) <= 1 & x(2) >= 0);
        T = @(x) all(0 <= x(1) & x(1) <= 1 & x(2) >= 0.8);

        args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
        problem = FirstHittingTimeProblem(args{:});

        testCase.QuadrotorProblem = problem;

    end

    function defineProblemForRepeatedQuadrotor(testCase)
        % We define the time horizon as N=1.
        N = 1;

        % For the stochastic chain of integrators example, the safe set is
        % defined as |x| <= 1 and the target set is defined as |x| <= 0.5.
        K = @(x) all(0 <= x(1) & x(1) <= 1 & x(2) >= 0);
        T = @(x) all(0 <= x(1) & x(1) <= 1 & x(2) >= 0.8);

        args = {'TimeHorizon', N, 'ConstraintSet', K, 'TargetSet', T};
        problem = FirstHittingTimeProblem(args{:});

        testCase.RepeatedQuadrotorProblem = problem;

    end

    function generateIntegratorSamplesWithGaussianDisturbance(testCase)
        % Generate the samples of the system via simulation.

        A = [1, 0.25; 0, 1];
        B = [0.03125; 0.25];

        s = linspace(-1.1, 1.1, 50);
        X = generateUniformSamples(s);

        U = zeros(1, size(X, 2));

        W = 0.01.*randn(size(X));

        Y = A*X + B*U + W;

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.IntegratorSamplesWithGaussianDisturbance = samples;

    end

    function generateIntegratorSamplesWithBetaDisturbance(testCase)
        % Generate the samples of the system via simulation.

        A = [1, 0.25; 0, 1];
        B = [0.03125; 0.25];

        s = linspace(-1.1, 1.1, 50);
        X = generateUniformSamples(s);

        U = zeros(1, size(X, 2));

        W = 0.1.*betarnd(2, 0.5, size(X));

        Y = A*X + B*U + W;

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.IntegratorSamplesWithBetaDisturbance = samples;

    end

    function generateIntegratorSamplesWithExponentialDisturbance(testCase)
        % Generate the samples of the system via simulation.

        A = [1, 0.25; 0, 1];
        B = [0.03125; 0.25];

        s = linspace(-1.1, 1.1, 50);
        X = generateUniformSamples(s);

        U = zeros(1, size(X, 2));

        W = 0.01.*exprnd(3, size(X));

        Y = A*X + B*U + W;

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.IntegratorSamplesWithExponentialDisturbance = samples;

    end

    function generateQuadrotorSamplesWithGaussianDisturbance(testCase)
        % Generate the samples of the system via simulation.

        M = 2500;

        m = 5;
        r = 2;
        I = 2;
        g = 9.81;

        f = @(x, u) [
            x(1, :) + 0.25*x(2, :);
            -0.25/m*sin(x(3, :)).*(u(1, :) + u(2, :)) + x(2, :);
            x(3, :) + 0.25*x(4, :);
             0.25/m*cos(x(3, :)).*(u(1, :) + u(2, :)) - 0.25/g + x(4, :);
            x(5, :) + 0.25*x(6, :);
             0.25*r/I*(u(1, :) - u(2, :)) + x(6, :)
        ];

        X = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        U = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Y = f(X, U) + [1E-3 1E-5 1E-3 1E-5 1E-3 1E-5]*randn(6, M);

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.QuadrotorSamplesWithGaussianDisturbance = samples;

    end

    function generateQuadrotorSamplesWithBetaDisturbance(testCase)
        % Generate the samples of the system via simulation.

        M = 2500;

        m = 5;
        r = 2;
        I = 2;
        g = 9.81;

        f = @(x, u) [
            x(1, :) + 0.25*x(2, :);
            -0.25/m*sin(x(3, :)).*(u(1, :) + u(2, :)) + x(2, :);
            x(3, :) + 0.25*x(4, :);
             0.25/m*cos(x(3, :)).*(u(1, :) + u(2, :)) - 0.25/g + x(4, :);
            x(5, :) + 0.25*x(6, :);
             0.25*r/I*(u(1, :) - u(2, :)) + x(6, :)
        ];

        X = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        U = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Y = f(X, U) + [1E-3 1E-5 1E-3 1E-5 1E-3 1E-5]*betarnd(2, 0.5, 6, M);

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.QuadrotorSamplesWithBetaDisturbance = samples;

    end

    function generateRepeatedQuadrotorSamplesWithGaussianDisturbance(testCase)
        % Generate the samples of the system via simulation.

        M = 2500;

        Nq = 170000;

        m = 5;
        r = 2;
        I = 2;
        g = 9.81;

        f = @(x, u) [
            x(1, :) + 0.25*x(2, :);
            -0.25/m*sin(x(3, :)).*(u(1, :) + u(2, :)) + x(2, :);
            x(3, :) + 0.25*x(4, :);
             0.25/m*cos(x(3, :)).*(u(1, :) + u(2, :)) - 0.25/g + x(4, :);
            x(5, :) + 0.25*x(6, :);
             0.25*r/I*(u(1, :) - u(2, :)) + x(6, :)
        ];

        X = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        U = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Y = f(X, U);

        X = repmat(X, Nq, 1);
        U = repmat(U, Nq, 1);
        Y = repmat(Y, Nq, 1);

        Y = Y + repmat([1E-3 1E-5 1E-3 1E-5 1E-3 1E-5], 1, Nq)*rand(6*Nq, M);

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.RepeatedQuadrotorSamplesWithGaussianDisturbance = samples;

    end

    function generateRepeatedQuadrotorSamplesWithBetaDisturbance(testCase)
        % Generate the samples of the system via simulation.

        M = 2500;

        Nq = 170000;

        m = 5;
        r = 2;
        I = 2;
        g = 9.81;

        f = @(x, u) [
            x(1, :) + 0.25*x(2, :);
            -0.25/m*sin(x(3, :)).*(u(1, :) + u(2, :)) + x(2, :);
            x(3, :) + 0.25*x(4, :);
             0.25/m*cos(x(3, :)).*(u(1, :) + u(2, :)) - 0.25/g + x(4, :);
            x(5, :) + 0.25*x(6, :);
             0.25*r/I*(u(1, :) - u(2, :)) + x(6, :)
        ];

        X = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        U = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Y = f(X, U);

        X = repmat(X, Nq, 1);
        U = repmat(U, Nq, 1);
        Y = repmat(Y, Nq, 1);

        Y = Y + 0.1*betarnd(2, 0.5, 6*Nq, M);

        args = {[2 1], 'X', X, 'U', U, 'Y', Y};
        samples = SystemSamples(args{:});

        testCase.RepeatedQuadrotorSamplesWithBetaDisturbance = samples;

    end

    function generateIntegratorTestPoints(testCase)
        % Generate test points.

        s = linspace(-1, 1, 100);
        Xtest = generateUniformSamples(s);

        Utest = zeros(1, size(Xtest, 2));

        testCase.IntegratorXtest = Xtest;
        testCase.IntegratorUtest = Utest;

    end

    function generateQuadrotorTestPoints(testCase)
        % Generate test points.

        M = 10000;

        Xtest = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Utest = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        testCase.QuadrotorXtest = Xtest;
        testCase.QuadrotorUtest = Utest;

    end

    function generateRepeatedQuadrotorTestPoints(testCase)
        % Generate test points.

        M = 1;

        Nq = 170000;

        Xtest = [
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
                randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Utest = [
            0.1*randi([-1, 1], 1, M);
            0.1*randi([-1, 1], 1, M)
        ];

        Xtest = repmat(Xtest, Nq, 1);
        Utest = repmat(Utest, Nq, 1);

        testCase.RepeatedQuadrotorXtest = Xtest;
        testCase.RepeatedQuadrotorUtest = Utest;

    end

    function defineAlgorithm(testCase)
        % Define the algorithm.

        args = {'Sigma', 0.1, 'Lambda', 1, 'D', 15000};
        algorithm = KernelDistributionEmbeddingsRFF(args{:});

        testCase.algorithm = algorithm;

    end
end

methods (Test)

    function profileIntegratorWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.IntegratorProblem; %#ok<*PROP>

        samples     = testCase.IntegratorSamplesWithGaussianDisturbance;
        Xtest       = testCase.IntegratorXtest;
        Utest       = testCase.IntegratorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileIntegratorWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.IntegratorProblem; %#ok<*PROP>

        samples     = testCase.IntegratorSamplesWithBetaDisturbance;
        Xtest       = testCase.IntegratorXtest;
        Utest       = testCase.IntegratorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileIntegratorWithExponentialDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.IntegratorProblem; %#ok<*PROP>

        samples     = testCase.IntegratorSamplesWithExponentialDisturbance;
        Xtest       = testCase.IntegratorXtest;
        Utest       = testCase.IntegratorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileQuadrotorWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.QuadrotorProblem; %#ok<*PROP>

        samples     = testCase.QuadrotorSamplesWithGaussianDisturbance;
        Xtest       = testCase.QuadrotorXtest;
        Utest       = testCase.QuadrotorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileQuadrotorWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.QuadrotorProblem; %#ok<*PROP>

        samples     = testCase.QuadrotorSamplesWithBetaDisturbance;
        Xtest       = testCase.QuadrotorXtest;
        Utest       = testCase.QuadrotorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileRepeatedQuadrotorWithGaussianDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.RepeatedQuadrotorProblem; %#ok<*PROP>

        samples     = testCase.RepeatedQuadrotorSamplesWithGaussianDisturbance;
        Xtest       = testCase.RepeatedQuadrotorXtest;
        Utest       = testCase.RepeatedQuadrotorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

    function profileRepeatedQuadrotorWithBetaDisturbance(testCase)
        % Compute the safety probabilities.
        problem     = testCase.RepeatedQuadrotorProblem; %#ok<*PROP>

        samples     = testCase.RepeatedQuadrotorSamplesWithBetaDisturbance;
        Xtest       = testCase.RepeatedQuadrotorXtest;
        Utest       = testCase.RepeatedQuadrotorUtest;

        algorithm   = testCase.algorithm;

        testCase.startMeasuring();

        algorithm.ComputeSafetyProbabilities(problem, samples, Xtest, Utest);

        testCase.stopMeasuring();

    end

end

end

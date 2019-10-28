%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # KernelDistributionEmbeddingsRFFTest.m
%
% Unit tests for the KernelDistributionEmbeddingsRFF class.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef KernelDistributionEmbeddingsRFFTest < matlab.unittest.TestCase
% KernelDistributionEmbeddingsRFFTest A unit test class for
% KernelDistributionEmbeddingsRFF
%
% This code should be run using the script in the root directory of the
% repository, run_all_tests.m
%
% See also: run_all_tests, KernelDistributionEmbeddingsRFF

%% Test Methods
methods (Test)

    function testKernelDistributionEmbeddingsRFFConstruction(testCase)
        % testKernelDistributionEmbeddingsRFFConstruction Should be able to
        % construct an instance of the KernelDistributionEmbeddingsRFF class and
        % set parameters.

        algorithm = KernelDistributionEmbeddingsRFF();

        testCase.verifyInstanceOf(algorithm, 'KernelDistributionEmbeddingsRFF');

        algorithm = KernelDistributionEmbeddingsRFF('Lambda', 1, 'Sigma', 0.1);

        testCase.verifyInstanceOf(algorithm, 'KernelDistributionEmbeddingsRFF');

        testCase.verifyEqual(algorithm.Lambda, 1);

        testCase.verifyEqual(algorithm.Sigma, 0.1);

    end

    function testKernelDistributionEmbeddingsRFFLambdaParameter(testCase)
        % testKernelDistributionEmbeddingsRFFLambdaParameter Should be able to
        % construct an instance of the KernelDistributionEmbeddingsRFF class and
        % access the dependent Lambda parameter.

        algorithm = KernelDistributionEmbeddingsRFF();

        testCase.verifyEqual(algorithm.Lambda, 1);

        algorithm.Lambda = 2;

        testCase.verifyEqual(algorithm.Lambda, 2);

    end

    function testKernelDistributionEmbeddingsRFFSigmaParameter(testCase)
        % testKernelDistributionEmbeddingsRFFSigmaParameter Should be able to
        % construct an instance of the KernelDistributionEmbeddingsRFF class and
        % access the dependent Sigma parameter.

        algorithm = KernelDistributionEmbeddingsRFF();

        testCase.verifyEqual(algorithm.Sigma, 0.1);

        algorithm.Sigma = 2;

        testCase.verifyEqual(algorithm.Sigma, 2);

    end

    function testKernelDistributionEmbeddingsRFFConstructionErrors(testCase)
        % testKernelDistributionEmbeddingsRFFConstructionErrors The
        % KernelDistributionEmbeddingsRFF class should throw an error if negative
        % or zero valued parameter values are passed to the constructor.

        testCase.verifyError( ...
            @() KernelDistributionEmbeddingsRFF('Lambda', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddingsRFF('Lambda', 0), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddingsRFF('Sigma', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddingsRFF('Sigma', 0), ...
            'MATLAB:expectedPositive' ...
        );

    end

end

end

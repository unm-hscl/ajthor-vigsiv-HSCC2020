%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # KernelDistributionEmbeddingsTest.m
%
% Unit tests for the KernelDistributionEmbeddings class.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef KernelDistributionEmbeddingsTest < matlab.unittest.TestCase
% KernelDistributionEmbeddingsTest A unit test class for
% KernelDistributionEmbeddings
%
% This code should be run using the script in the root directory of the
% repository, run_all_tests.m
%
% See also: run_all_tests, KernelDistributionEmbeddings

%% Test Methods
methods (Test)

    function testKernelDistributionEmbeddingsConstruction(testCase)
        % testKernelDistributionEmbeddingsConstruction Should be able to
        % construct an instance of the KernelDistributionEmbeddings class and
        % set parameters.

        algorithm = KernelDistributionEmbeddings();

        testCase.verifyInstanceOf(algorithm, 'KernelDistributionEmbeddings');

        testCase.verifyInstanceOf(algorithm, 'AlgorithmBaseClass');

        algorithm = KernelDistributionEmbeddings('Lambda', 1, 'Sigma', 0.1);

        testCase.verifyInstanceOf(algorithm, 'KernelDistributionEmbeddings');

        testCase.verifyInstanceOf(algorithm, 'AlgorithmBaseClass');

        testCase.verifyEqual(algorithm.Lambda, 1);

        testCase.verifyEqual(algorithm.Sigma, 0.1);

    end

    function testKernelDistributionEmbeddingsConstructionErrors(testCase)
        % testKernelDistributionEmbeddingsConstructionErrors The
        % KernelDistributionEmbeddings class should throw an error if negative
        % or zero valued parameter values are passed to the constructor.

        testCase.verifyError( ...
            @() KernelDistributionEmbeddings('Lambda', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddings('Lambda', 0), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddings('Sigma', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() KernelDistributionEmbeddings('Sigma', 0), ...
            'MATLAB:expectedPositive' ...
        );

    end

    function testKernelDistributionEmbeddingsLambdaParameter(testCase)
        % testKernelDistributionEmbeddingsLambdaParameter Should be able to
        % construct an instance of the KernelDistributionEmbeddings class and
        % access the dependent Lambda parameter.

        algorithm = KernelDistributionEmbeddings();

        testCase.verifyEqual(algorithm.Lambda, 1);

        algorithm.Lambda = 2;

        testCase.verifyEqual(algorithm.Lambda, 2);

    end

    function testKernelDistributionEmbeddingsSigmaParameter(testCase)
        % testKernelDistributionEmbeddingsSigmaParameter Should be able to
        % construct an instance of the KernelDistributionEmbeddings class and
        % access the dependent Sigma parameter.

        algorithm = KernelDistributionEmbeddings();

        testCase.verifyEqual(algorithm.Sigma, 0.1);

        algorithm.Sigma = 2;

        testCase.verifyEqual(algorithm.Sigma, 2);

    end

end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # SystemSamplesTest.m
%
% Unit tests for the SystemSamples class.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef SystemSamplesTest < matlab.unittest.TestCase
% SystemSamplesTest A unit test class for SystemSamples
%
% This code should be run using the script in the root directory of the
% repository, run_all_tests.m
%
% See also: run_all_tests, SystemSamples

%% Test Methods
methods (Test)

    function testSystemSamplesCreation(testCase)
        % testSystemSamplesCreation Test the ability to construct an instance of
        % the SystemSamples class.

        sys = SystemSamples([2, 1]);

        testCase.verifyInstanceOf(sys, 'SystemSamples');

    end

    function testSystemSamplesConstructionErrors(testCase)
        % testSystemSamplesConstructionErrors The SystemSamples class should
        % throw an error if incorrect sample matrices are passed to the
        % constructor.

        testCase.verifyError( ...
            @() SystemSamples([2, 1], 'X', zeros(3, 1)), ...
            'MATLAB:incorrectNumrows' ...
        );

        testCase.verifyError( ...
            @() SystemSamples([2, 1], 'U', zeros(3, 1)), ...
            'MATLAB:incorrectNumrows' ...
        );

        testCase.verifyError( ...
            @() SystemSamples([2, 1], 'Y', zeros(3, 1)), ...
            'MATLAB:incorrectNumrows' ...
        );

    end

end

end

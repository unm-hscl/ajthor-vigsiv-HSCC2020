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

end

end

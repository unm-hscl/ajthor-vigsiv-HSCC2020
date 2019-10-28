%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% # FirstHittingTimeProblemTest.m
%
% Unit tests for the FirstHittingTimeProblem class.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef FirstHittingTimeProblemTest < matlab.unittest.TestCase
% FirstHittingTimeProblemTest A unit test class for FirstHittingTimeProblem
%
% This code should be run using the script in the root directory of the
% repository, run_all_tests.m
%
% See also: run_all_tests, FirstHittingTimeProblem

%% Test Methods
methods (Test)

    function testFirstHittingTimeProblemCreation(testCase)
        % testFirstHittingTimeProblemCreation Test the ability to construct an
        % instance of the FirstHittingTimeProblem class.

        problem = FirstHittingTimeProblem();

        testCase.verifyInstanceOf(problem, 'FirstHittingTimeProblem');

        testCase.verifyInstanceOf(problem, 'ProblemBaseClass');

    end

    function testFirstHittingTimeProblemConstructionErrors(testCase)
        % testFirstHittingTimeProblemConstructionErrors The
        % FirstHittingTimeProblem class should throw an error if negative,
        % non-integer, or zero valued time horizon values are passed to the
        % constructor.

        testCase.verifyError( ...
            @() FirstHittingTimeProblem('TimeHorizon', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() FirstHittingTimeProblem('TimeHorizon', 1.1), ...
            'MATLAB:validators:mustBeInteger' ...
        );

        testCase.verifyError( ...
            @() FirstHittingTimeProblem('TimeHorizon', 0), ...
            'MATLAB:expectedPositive' ...
        );

    end

end

end

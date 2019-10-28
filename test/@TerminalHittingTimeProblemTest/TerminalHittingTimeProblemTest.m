%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TerminalHittingTimeProblemTest.m
%
% Unit tests for the TerminalHittingTimeProblem class.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
classdef TerminalHittingTimeProblemTest < matlab.unittest.TestCase
% TerminalHittingTimeProblemTest A unit test class for the
% TerminalHittingTimeProblem code.
%
% This code should be run using the script in the root directory of the
% repository, run_all_tests.m
%
% See also: run_all_tests, TerminalHittingTimeProblem

%% Test Methods
methods (Test)

    function testTerminalHittingTimeProblemCreation(testCase)
        % testTerminalHittingTimeProblemCreation Test the ability to construct
        % an instance of the TerminalHittingTimeProblem class.

        problem = TerminalHittingTimeProblem();

        testCase.verifyInstanceOf(problem, 'TerminalHittingTimeProblem');

        testCase.verifyInstanceOf(problem, 'ProblemBaseClass');

    end

    function testTerminalHittingTimeProblemConstructionErrors(testCase)
        % testTerminalHittingTimeProblemConstructionErrors The
        % TerminalHittingTimeProblem class should throw an error if negative,
        % non-integer, or zero valued time horizon values are passed to the
        % constructor.

        testCase.verifyError( ...
            @() TerminalHittingTimeProblem('TimeHorizon', -1), ...
            'MATLAB:expectedPositive' ...
        );

        testCase.verifyError( ...
            @() TerminalHittingTimeProblem('TimeHorizon', 1.1), ...
            'MATLAB:validators:mustBeInteger' ...
        );

        testCase.verifyError( ...
            @() TerminalHittingTimeProblem('TimeHorizon', 0), ...
            'MATLAB:expectedPositive' ...
        );

    end

end

end

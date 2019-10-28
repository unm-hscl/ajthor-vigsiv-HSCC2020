%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run_perf_tests
%
% Runs the performance tests to benchmark the execution of the algorithms for
% different cases.
%
% WARNING: This code can take a long time to run. For the high-dimensional
% examples, this means the code can take over an hour to run.
%
% WARNING: This code takes a large amount of memory in order to run. Some
% systems may not be able to run the code without increasing the memory limits
% of Matlab.
%
% For help dealing with 'out of memory' issues, see:
% See https://www.mathworks.com/help/matlab/large-files-and-big-data.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imports the TestSuite class to the current namespace.
import matlab.unittest.TestSuite;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a TestSuite from the tests folder and run the unit tests.
suiteFolder = TestSuite.fromFolder(strcat(pwd, '/test'));
result = run(suiteFolder);

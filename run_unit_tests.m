%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Imports the TestSuite class to the current namespace.
import matlab.unittest.TestSuite;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a TestSuite from the tests folder and run the unit tests.
suiteFolder = TestSuite.fromFolder(strcat(pwd, '/test'));
result = run(suiteFolder);

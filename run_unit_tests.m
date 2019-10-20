% Imports the TestSuite class to the current namespace.
import matlab.unittest.TestSuite;

suiteFolder = TestSuite.fromFolder(strcat(pwd, '/test'));
result = run(suiteFolder);

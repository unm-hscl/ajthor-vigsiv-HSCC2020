%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run_perf_tests
%
% Runs the performance tests to benchmark the execution of the algorithms for
% different cases.
%
% WARNING: This code can take a long time to run. The perfromance testing
% framework in Matlab runs the algorithms several times to warm up the processor
% and to get a mean measurement of the computation time. For the
% high-dimensional examples, this means the code can take several hours to run.
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
% Run the profile tests to compute the run times of the algorithms.
Results     = runperf('ProfileKernelDistributionEmbeddings');
ResultsRFF  = runperf('ProfileKernelDistributionEmbeddingsRFF');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We construct the static data of the table.

Table = table;

Table.System = {
    'Chain of Integrators';
    'Chain of Integrators';
    'Chain of Integrators';
    'Planar Quadrotor';
    'Planar Quadrotor';
    'Planar Quadrotor';
    'Planar Quadrotor'
};

Table.Disturbance = {
    'Gaussian';
    'Beta';
    'Exponential';
    'Gaussian';
    'Beta';
    'Gaussian';
    'Beta'
};

Table.Dimensionality = {
    2;
    2;
    2;
    6;
    6;
    1000000;
    1000000
};

Table.NumberOfSamplePoints = {
    2500;
    2500;
    2500;
    1000;
    1000;
    1000;
    1000
};

Table.NumberOfEvaluationPoints = {
    10000;
    10000;
    10000;
    10000;
    10000;
    1;
    1
};

Table.NumberOfFrequencySamples = {
    15000;
    15000;
    15000;
    15000;
    15000;
    15000;
    15000
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Using the results from the profiler, we can construct the mean computation
% time for each algorithm.
Table.Algorithm1 = {
    mean(Results(1).Samples.MeasuredTime);
    mean(Results(2).Samples.MeasuredTime);
    mean(Results(3).Samples.MeasuredTime);
    mean(Results(4).Samples.MeasuredTime);
    mean(Results(5).Samples.MeasuredTime);
    mean(Results(6).Samples.MeasuredTime);
    mean(Results(7).Samples.MeasuredTime);
};

Table.Algorithm2 = {
    mean(ResultsRFF(1).Samples.MeasuredTime);
    mean(ResultsRFF(2).Samples.MeasuredTime);
    mean(ResultsRFF(3).Samples.MeasuredTime);
    mean(ResultsRFF(4).Samples.MeasuredTime);
    mean(ResultsRFF(5).Samples.MeasuredTime);
    mean(ResultsRFF(6).Samples.MeasuredTime);
    mean(ResultsRFF(7).Samples.MeasuredTime);
};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display the table.
openvar('Table')

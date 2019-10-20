%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run the profile tests to compute the run times of the algorithms.
Results     = runperf('ProfileKernelDistributionEmbeddings');
ResultsRFF  = runperf('ProfileKernelDistributionEmbeddingsRFF');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% We construct the static data of the table.

T = table;

T.System = {
    'Chain of Integrators';
    'Chain of Integrators';
    'Chain of Integrators';
    'Planar Quadrotor';
    'Planar Quadrotor';
    'Planar Quadrotor';
    'Planar Quadrotor'
};

T.Disturbance = {
    'Gaussian';
    'Beta';
    'Exponential';
    'Gaussian';
    'Beta';
    'Gaussian';
    'Beta'
};

T.Dimensionality = {
    2;
    2;
    2;
    6;
    6;
    1000000;
    1000000
};

T.NumberOfSamplePoints = {
    2500;
    2500;
    2500;
    2500;
    2500;
    2500;
    2500
};

T.NumberOfEvaluationPoints = {
    10000;
    10000;
    10000;
    10000;
    10000;
    1;
    1
};

T.NumberOfFrequencySamples = {
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
T.Algorithm1 = {
    mean(Results(1).Samples.MeasuredTime);
    mean(Results(2).Samples.MeasuredTime);
    mean(Results(3).Samples.MeasuredTime);
    mean(Results(4).Samples.MeasuredTime);
    mean(Results(5).Samples.MeasuredTime);
    mean(Results(6).Samples.MeasuredTime);
    mean(Results(7).Samples.MeasuredTime);
};

T.Algorithm2 = {
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
openvar('T')

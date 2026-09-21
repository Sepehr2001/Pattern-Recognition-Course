clear;
clc;
close all;

scriptDirectory = fileparts(mfilename('fullpath'));
projectDirectory = fileparts(scriptDirectory);

featureFile = fullfile( ...
    projectDirectory, ...
    'results', ...
    'features', ...
    'step05_fulltrial_wavelet_features.mat' ...
);

if ~isfile(featureFile)
    error('Step 05 feature file was not found.');
end

featureData = load(featureFile, 'featuresTable');
featuresTable = featureData.featuresTable;

requiredVariables = {
    'Group'
    'ClassLabel'
    'DominantFrequencyHz'
    'MaximumFFTAmplitude'
};

for k = 1:numel(requiredVariables)

    if ~ismember( ...
            requiredVariables{k}, ...
            featuresTable.Properties.VariableNames ...
        )

        error( ...
            'Required variable was not found: %s', ...
            requiredVariables{k} ...
        );
    end
end

selectedVariables = {
    'DominantFrequencyHz'
    'MaximumFFTAmplitude'
    'ClassLabel'
};

groupATwoFeatureData = featuresTable( ...
    featuresTable.Group == "A", ...
    selectedVariables ...
);

groupBTwoFeatureData = featuresTable( ...
    featuresTable.Group == "B", ...
    selectedVariables ...
);

if height(groupATwoFeatureData) ~= 240
    error('Group A must contain 240 observations.');
end

if height(groupBTwoFeatureData) ~= 432
    error('Group B must contain 432 observations.');
end

outputDirectory = fullfile( ...
    projectDirectory, ...
    'results', ...
    'classification_learner' ...
);

groupAFile = fullfile( ...
    outputDirectory, ...
    'GroupA_TwoFeatures_ClassificationLearner.xlsx' ...
);

groupBFile = fullfile( ...
    outputDirectory, ...
    'GroupB_TwoFeatures_ClassificationLearner.xlsx' ...
);

writetable(groupATwoFeatureData, groupAFile);
writetable(groupBTwoFeatureData, groupBFile);

fprintf('Two-feature files created successfully.\n\n');

fprintf('Predictors:\n');
fprintf('1. DominantFrequencyHz\n');
fprintf('2. MaximumFFTAmplitude\n');

fprintf('\nResponse:\n');
fprintf('ClassLabel\n');

fprintf('\nGroup A file:\n%s\n', groupAFile);
fprintf('\nGroup B file:\n%s\n', groupBFile);
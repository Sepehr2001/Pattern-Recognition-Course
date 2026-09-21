clear;
clc;
close all;

scriptDirectory = fileparts(mfilename('fullpath'));
projectDirectory = fileparts(scriptDirectory);

dataDirectory = fullfile(projectDirectory, 'data', 'benchmark');
resultsDirectory = fullfile(projectDirectory, 'results');

groupA = [
    10, 14, 15, 20, 22, ...
    25, 26, 31, 32, 35
];

groupB = [
    1, 2, 3, 5, 6, 7, 8, 9, 12, ...
    17, 18, 19, 21, 24, 27, 28, 30, 34
];

subjectIDs = [groupA, groupB];

targetFrequencies = [9, 10, 11, 12];

samplingFrequency = 250;

numberOfChannels = 64;
numberOfTargets = 40;
numberOfBlocks = 6;

trialDurationSeconds = 6;
stimulationDurationSeconds = 5;

if ~isfolder(dataDirectory)
    error('Dataset directory was not found: %s', dataDirectory);
end

generalFiles = {
    'Readme.txt'
    '64-channels.loc'
    'Freq_Phase.mat'
};

for fileIndex = 1:numel(generalFiles)
    currentFile = fullfile(dataDirectory, generalFiles{fileIndex});

    if ~isfile(currentFile)
        error('Required file was not found: %s', currentFile);
    end
end

for subjectIndex = 1:numel(subjectIDs)
    subjectID = subjectIDs(subjectIndex);

    subjectFile = fullfile( ...
        dataDirectory, ...
        sprintf('S%d.mat', subjectID) ...
    );

    if ~isfile(subjectFile)
        error('Subject file was not found: %s', subjectFile);
    end
end

frequencyPhaseFile = fullfile(dataDirectory, 'Freq_Phase.mat');
frequencyPhaseInformation = load(frequencyPhaseFile);

variableNames = fieldnames(frequencyPhaseInformation);

disp('Variables inside Freq_Phase.mat:');
disp(variableNames);

frequencyVector = [];

for variableIndex = 1:numel(variableNames)
    currentVariable = frequencyPhaseInformation.( ...
        variableNames{variableIndex} ...
    );

    if isnumeric(currentVariable) && numel(currentVariable) == 40
        candidateVector = double(currentVariable(:)');

        if all(candidateVector >= 8) && ...
           all(candidateVector <= 15.8)

            frequencyVector = candidateVector;
            break;
        end
    end
end

if isempty(frequencyVector)
    error('The 40 stimulation frequencies were not found.');
end

targetIndices = zeros(size(targetFrequencies));

for frequencyIndex = 1:numel(targetFrequencies)
    currentTargetFrequency = targetFrequencies(frequencyIndex);

    [frequencyDifference, matchedIndex] = min( ...
        abs(frequencyVector - currentTargetFrequency) ...
    );

    if frequencyDifference > 1e-6
        error( ...
            'Target frequency %.1f Hz was not found.', ...
            currentTargetFrequency ...
        );
    end

    targetIndices(frequencyIndex) = matchedIndex;
end

if ~isfolder(resultsDirectory)
    mkdir(resultsDirectory);
end

configurationFile = fullfile( ...
    projectDirectory, ...
    'article_configuration.mat' ...
);

save( ...
    configurationFile, ...
    'dataDirectory', ...
    'resultsDirectory', ...
    'groupA', ...
    'groupB', ...
    'subjectIDs', ...
    'targetFrequencies', ...
    'targetIndices', ...
    'frequencyVector', ...
    'samplingFrequency', ...
    'numberOfChannels', ...
    'numberOfTargets', ...
    'numberOfBlocks', ...
    'trialDurationSeconds', ...
    'stimulationDurationSeconds' ...
);

fprintf('\nArticle configuration created successfully.\n');
fprintf('Number of subjects: %d\n', numel(subjectIDs));
fprintf('Group A subjects: %d\n', numel(groupA));
fprintf('Group B subjects: %d\n', numel(groupB));

fprintf('\nSelected frequencies and target indices:\n');

for frequencyIndex = 1:numel(targetFrequencies)
    fprintf( ...
        '%.1f Hz -> target index %d\n', ...
        targetFrequencies(frequencyIndex), ...
        targetIndices(frequencyIndex) ...
    );
end

fprintf('\nConfiguration saved in:\n%s\n', configurationFile);
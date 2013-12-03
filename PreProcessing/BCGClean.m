function BCGClean(subj,run)
% BCGClean(subj,run)
% this is a wrapper function for cleaning the BCG artifact 
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

% prefix indicates the levels of processing the file has gone through
preFix = 'FiltSTGA';

subjId = EF_num2Sub(subj);

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath 'GAClean/r' num2str(run) '/'];
fileName        = [preFix 'CleanData.mat'];
        
display(sprintf('Filtering Subject %i Run # %i', subj, run));

%% load data and set parameters
load([rawPath, fileName]);

S.BCGCleanMethod  = 'ST';

%% settings
% pulse markers 
S.ignore_firstpulses = 5;
S.ignore_lastpulses = 5;

% 200 ms marker lag from pulse event
S.marker_lag = 0.2*S.SR;

S = ST_PA_Clean(S);

%% Save

savePath = [subjPath 'BCGClean/r' num2str(run) '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
save([savePath S.BCGCleanMethod 'BCG' fileName ],'S')


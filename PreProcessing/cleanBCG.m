function cleanBCG(subj,run)
% cleanBCG(subj,run)
% this is a wrapper function for cleaning the BCG artifact 
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

% prefix indicates the levels of processing the file has gone through
preFix = 'FiltFASTRGA';
%preFix = 'FiltSTGA';
BCGCleanMethod  = 'OBS';

subjId = EF_num2Sub(subj);

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath 'GAClean/r' num2str(run) '/'];
fileName        = [preFix 'CleanData.mat'];
        
display(sprintf('Filtering Subject %i Run # %i', subj, run));

addpath('/biac4/wagner/biac3/wagner5/alan/eegfmri/scripts/alexScripts/PreProcessing/fmrib/')

%% load data and set parameters
load([rawPath, fileName]);

%% settings

S.BCGCleanMethod = BCGCleanMethod; 

% pulse markers 
S.ignore_firstpulses = 5;
S.ignore_lastpulses = 5;

% total number of points
S.nSamps = size(S.signal,2);
% total numbers of channels
S.nChan = size(S.signal,1);

% 200 ms marker lag from pulse event
S.marker_lag = 0.2*S.SR;

% pulse marker
S.pulse_markers_orig = single(S.pulse_markers(S.ignore_firstpulses+1: ...
    end-S.ignore_lastpulses)- S.marker_lag);

% correct for pulse markers as in Niazy et al 2005:
ECG = zeros(1,S.nSamps);
ECG(S.pulse_markers) = 1;

S.pulse_markers = qrscorrect(S.pulse_markers_orig,ECG,S.SR); clear ECG;

%% clean PA artifact
switch S.BCGCleanMethod
    case 'ST'
        S = ST_PA_Clean(S);
    case 'OBS'
        % Based on niazy 2005 obs method
        S = fmrib_pas(S,S.pulse_markers,'obs',4);         
end

%% Save

savePath = [subjPath 'BCGClean/r' num2str(run) '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
save([savePath S.BCGCleanMethod 'BCG' fileName ],'S')


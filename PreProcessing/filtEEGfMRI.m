function filtEEGfMRI(subj,run)
% filtEEGfMRI(subj,run)
% this is a wrapper function for filtering EEG fMRI data
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

type = 'BCG'; 
% at what stage to filter;  GA  -> after GA cleaning
%                           BCG -> after BCG cleaning

%preFix = 'OBSBCGFiltFASTRGA'; % method use to clean
preFix = 'OBSBCGFiltSTGA'; % method use to clean
%preFix = 'FASTRGA'; % method use to clean

subjId = EF_num2Sub(subj);

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath type 'Clean/r' num2str(run) '/'];
fileName        = [preFix 'CleanData.mat'];
        
display(sprintf('Filtering Subject %i Run # %i', subj, run));

%% load data and set parameters
load([rawPath, fileName]);

% downsampling factor
if S.SR == 500
    S.comp = 5;
elseif S.SR == 100
    S.comp = 1;
end

S.lowPass   = 30;   % in Hz
S.highPass  = 1;    % in Hz
S.notch     = [];   
S.filtOrd   = 500;
S.filtWindow= 'hann';

%% Downsample
% downsample the signal and update markers

if S.comp > 1;
    % decimate the signal    
    nSamps      = size(S.signal,2);
    nCompSamps  = ceil(nSamps/S.comp);
    S.origSR    = S.SR;
    S.SR        = round(S.SR/S.comp);
    
    X = zeros(S.nChan,nCompSamps);
    for ch = 1:S.nChan
        X(ch,:) = resample(S.signal(ch,:),1,S.comp);
    end
    S.signal        = X; clear X;
    % update signal markers
    S.ev_markers    = ceil(S.ev_markers/S.comp);
    S.pulse_markers = ceil(S.pulse_markers/S.comp);
    S.MR_Pulses     = ceil(S.MR_Pulses/S.comp);    
end

%% Filter

S.filtCoef = fir1(S.filtOrd, [S.highPass S.lowPass]*2/S.SR, eval([S.filtWindow '(S.filtOrd + 1)' ]));

for ch = 1:S.nChan
    S.signal(ch,:) = filtfilt(S.filtCoef,1,S.signal(ch,:));
end

%% Save

savePath = [subjPath type 'Clean/r' num2str(run) '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
save([savePath 'Filt' fileName ],'S')


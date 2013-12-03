function cleanGA(subj,run)
% cleanGA(subj,run)
% this is a wrapper function for cleaning the gradient artifact.
% it also creates the data structure that will be used in further scripts.
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

subjId = EF_num2Sub(subj);

GAcleanMethod   = 'FASTR';
subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath  'raw/r' num2str(run) '/'];
fileName        =  'RawData.mat';

display(sprintf('Processing Subject %i Run # %i', subj, run));
%% load data and set parameters

load([rawPath fileName]);

S.GAcleanMethod = GAcleanMethod;

% how many slices per volume
S.slicespervolume = 35;

% Volume acquisition length (TR length in seconds)
S.TR_length = 2;

% samples per slice
S.SampsPerSlice = floor(S.SR/(S.slicespervolume/S.TR_length));

switch S.GAcleanMethod
    
    case 'ST'
        
        % Default Parameters:
        % how many epochs to for template
        S.NPulseEpochs = 15;
        
        % how much should the sliding window move
        S.sldwin_epochs = 5;%floor(S.NPulseEpochs/2);
        
        % clear the gradient artificat
        S = ST_GA_Clean(S);
        
    case 'FASTR'
        % use of Niazy's toolbox in EEGLAB, using default parameters,
        % except the lowpass filter
        addpath('/biac4/wagner/biac3/wagner5/alan/eegfmri/scripts/alexScripts/PreProcessing/fmrib/')
        
        % Default Parameters:
        % low pass filter
        S.FASTR.lpf = 30;
        
        % interpolation folds
        % no interpolation needed, slices are aligned
        S.FASTR.L = 1;
        
        % number of artifacts to include in the averaging
        S.FASTR.window = 30;
        
        
        S.FASTR.Trigs = S.MR_Pulses + 1;
        % slice triggers (true)
        S.FASTR.strig = 1;
        
        % adaptive noise canceling
        S.FASTR.anc_chk = 1;
        
        % correct for missing triggers (false);
        % triggers are aligned (hardware checked),
        S.FASTR.tc_chk  = 0;
        S.FASTR.Volumes = [];
        S.FASTR.Slices  = [];
        
        % relative location of slice triggers to recordings
        % again, this is synced
        S.FASTR.pre_frac = 0;
        
        % channels to exclude
        S.FASTR.exc = '';
        
        % number of principal components to fit residuals
        S.FASTR.NPC = 'auto';
        
        % clear the gradient artificat
        S = fmrib_fastr(S, S.FASTR.lpf, S.FASTR.L, S.FASTR.window, S.FASTR.Trigs, ...
             S.FASTR.strig, S.FASTR.anc_chk, S.FASTR.tc_chk, S.FASTR.Volumes,...
              S.FASTR.Slices,  S.FASTR.pre_frac,  S.FASTR.exc, S.FASTR.NPC);
        
end

%% Recording Information


savePath = [subjPath 'GAClean/r' num2str(run) '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
save([savePath S.GAcleanMethod 'GACleanData.mat'],'S')

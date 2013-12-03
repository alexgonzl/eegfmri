function CNRCalc(subj,run)

% this function epochs the signal in events of interest.
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

lockType    = 'RT'; % can be either stim or RT
% at what stage;    GA  -> after GA cleaning
%                   BCG -> after BCG cleaning
type        = 'BCG';

% processing stream
switch type
    case 'BCG'
        %processingSteps = 'FiltSTBCGFiltSTGA';
        %processingSteps = 'FiltOBSBCGFiltFASTRGA';
        processingSteps = 'FiltOBSBCGFiltSTGA';
    case 'GA'
        %processingSteps = 'FiltSTGA';
        processingSteps = 'FiltFASTRGA';
end

preFix = [lockType 'LockERPs' processingSteps]; 

subjId = EF_num2Sub(subj);

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/epoched/'];
rawPath         = [subjPath '/r' num2str(run) '/' lockType '/'];
fileName        = [preFix 'CleanData.mat'];
savePath        = [subjPath '/r' num2str(run) '/CNR/'];

display(sprintf('Epoching Subject %i Run # %i', subj, run));

%% load data and set parameters
load([rawPath, fileName]);

S.channelGroupings  = chanGroupings;
S.time              = S.trialDur(1):1/S.SR:(S.trialDur(2)-1/S.SR);
switch  S.lockType
    case 'stim'
        S.CNRtimes = [0.15 0.2];
        S.CNRchans = S.channelGroupings.COccChans;
    case 'RT'
        S.CNRtimes = [-0.1 0.2];        
        S.CNRchans = S.channelGroupings.LMotorChans;        
end

CNRidx  = S.time>=S.CNRtimes(1) & S.time<=S.CNRtimes(2);


%% Calc CNR

% trialWise CNR
%mean across the channel grouping CNR times
C = squeeze(mean(S.erp(S.CNRchans,:,CNRidx),1));

% take the peak amplitude during CNR time
C = abs(max(C,[],2));

% take the baseline as the mean of the standard deviation across channels
bsl = mean(S.baseLineStds(S.CNRchans,:),1);

S.tCNR = C./bsl(1:numel(C))';
S.metCNR = nanmedian(S.tCNR);

% BlockWise CNR
trials   = ~isnan(S.RTs);
bsl      = std(mean(squeeze(mean(S.baseLines(S.CNRchans,trials,:),1))));
S.mebCNR = nanmean(C)./bsl;

%% save

fileName = ['CNR' preFix];
if ~exist(savePath,'dir'), mkdir(savePath), end;
save([savePath fileName])







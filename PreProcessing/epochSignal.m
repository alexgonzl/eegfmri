function epochSignal(subj,run)
% this function epochs the signal in events of interest.
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

% at what stage;    GA  -> after GA cleaning
%                   BCG -> after BCG cleaning
type        = 'GA';

% processing stream
switch type
    case 'BCG'
        %preFix = 'FiltSTBCGFiltSTGA';
        preFix = 'FiltOBSBCGFiltFASTRGA';
        %preFix = 'FiltOBSBCGFiltSTGA';
    case 'GA'
        %preFix = 'FiltSTGA';
        %preFix = 'FiltFASTRGA';
        preFix = 'FiltIARGA';
end

for locks = {'stim', 'RT'}
    lockType    = locks{1};
    
    subjId = EF_num2Sub(subj);
    
    subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
    rawPath         = [subjPath type 'Clean/r' num2str(run) '/'];
    fileName        = [preFix 'CleanData.mat'];
    savePath        = [subjPath 'epoched/r' num2str(run) '/'];
    
    display(sprintf('Epoching Subject %i Run # %i: %s Locked', subj, run, lockType));
    
    %% load data and set parameters
    load([rawPath, fileName]);
    
    S.lockType  =  lockType; % stimulus locked or RT locked
    
    switch  S.lockType
        case 'stim'
            S.trialDur = [-0.2 1]; dur = S.trialDur;
            S.baseLine = [-0.2 0];
        case 'RT'
            S.trialDur = [-0.5 0.5]; dur = S.trialDur;
            % baseline period used from the stim locked data
    end
    S.RTs       = S.behavior.RT;
    evOnsets    = S.ev_markers;
    epochDur    = S.trialDur;
    
    
    %% epoch data
    epochTime   = linspace(epochDur(1),epochDur(2),ceil(diff(epochDur)*S.SR));
    nEpSamps    = numel(epochTime);
    nEvents     = numel(evOnsets);
    S.RTs_old   = S.RTs;
    S.RTs(nEvents+1:end) = [];
    epSamps     = floor(epochTime*S.SR);
    evIdx       = zeros(nEvents,nEpSamps);
    nTotalSamples  = size(S.signal,2);
    
    switch  S.lockType
        case 'stim'
            offset = zeros(nEvents,1);
        case 'RT'
            offset = round(S.RTs*S.SR);
    end
    
    for ev = 1:nEvents
        evIdx(ev,:) = epSamps+evOnsets(ev)+offset(ev);
        
        if max(evIdx(ev,:)) >= nTotalSamples
            nEvents         = ev-1;
            evIdx(ev:end,:) = [];
            S.RTs_old       = S.RTs;
            S.RTs(ev:end)   = [];
            offset(ev:end)  = [];
            break;
        end
    end
    
    validTrials = find(~isnan(offset))';
    
    % epoch the data
    X = S.signal;S.signal=[];
    erp = nan(S.nChan,nEvents,nEpSamps);
    for ch = 1:S.nChan
        x = X(ch,:);
        for tr = validTrials
            erp(ch,tr,:) = x(evIdx(tr,:));
        end
    end
    clear X;
    S.evIdx = evIdx;
    
    % Correct for baseline fluectuations before trial onset. In case of RT
    % locked analysis, it uses the baselines from the stim locked (loaded outside)
    if strcmp(S.lockType,'stim')
        baselineIdx = epochTime<=S.baseLine(2) & epochTime>= S.baseLine(1);
        S.baseLines     = squeeze(erp(:,:,baselineIdx));
        S.baseLineMeans = nanmean(S.baseLines,3);
        S.baseLineStds  = nanstd(S.baseLines,0,3);
    else
        load([savePath 'stim/stimLockERPsBaselines' fileName]);
        S.baseLines     = baseLines(:,1:nEvents,:);
        S.baseLineMeans = nanmean(S.baseLines,3);
        S.baseLineStds  = nanstd(S.baseLines,0,3);
    end
    
    S.erp = bsxfun(@minus,erp,S.baseLineMeans); clear erp;
    
    %% Save
    
    if ~exist([savePath S.lockType],'dir'), mkdir([savePath S.lockType]),end;
    save([savePath S.lockType '/' S.lockType 'LockERPs' fileName ],'S')
    
    if strcmp(S.lockType,'stim')
        baseLines   = S.baseLines;
        save([savePath  'stim/stimLockERPsBaselines' fileName ],'baseLines')
    end
end


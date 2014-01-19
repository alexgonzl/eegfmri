function CNRCalc(subj,run)

% this function epochs the signal in events of interest.
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

subjId      = EF_num2Sub(subj);
methods     = {'FiltFASTRGA','FiltSTGA','FiltSTBCGFiltSTGA', ...
    'FiltOBSBCGFiltFASTRGA', 'FiltOBSBCGFiltSTGA','FiltIARGA'};
nMethods    = numel(methods);

for locks = {'stim', 'RT'}
    lockType    = locks{1};
    for jj = 1:nMethods
        try
            processingSteps = methods{jj};
            
            preFix = [lockType 'LockERPs' processingSteps];
            
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
            C = squeeze(nanmedian(S.erp(S.CNRchans,:,CNRidx),1));
            
            % take the peak amplitude during CNR time
            C = max(abs(C),[],2);
            
            % take the baseline as the mean of the standard deviation across channels
            bsl = median(S.baseLineStds(S.CNRchans,:),1);
            
            S.tCNR      = C./bsl(1:numel(C))';
            S.nTrials   = sum(~isnan(S.tCNR));
            S.metCNR    = nanmedian(S.tCNR);
            S.setCNR    = nanstd(S.tCNR)/sqrt(S.nTrials-1);
            S.q25tCNR   = quantile(S.tCNR,0.25);
            S.q75tCNR   = quantile(S.tCNR,0.75);
            
            % BlockWise CNR
            trials   = ~isnan(S.RTs);
            bsl      = nanstd(nanmean(squeeze(nanmean(S.baseLines(S.CNRchans,trials,:),1))));
            S.mebCNR = nanmedian(C)./bsl;
            
            %% save
            
            fileName = ['CNR' preFix];
            if ~exist(savePath,'dir'), mkdir(savePath), end;
            save([savePath fileName],'S')
        catch
        end
    end
end



% this script is to average events by condition within a run and to put all
% runs together
% ZSCORE

clearvars

subjs = [15 16 17 18 19 20];
runs = 1:5;
nruns = numel(runs);
lock = 'RT';

savepath = '/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/';

conds = {'old','hits','HC_hits','Rem_hits','misses','new','cr','HC_cr', ...
    'LC_cr','LC_hits','FA'};

% data condition
datatype = {'NOBCGCleaning','STBCGClean','OBSBCGCleaning'};
datacondition = datatype{3};

trials_ind_start = 1:80:400;
eegfmri_ON_trialch_info

for s =  1:numel(subjs);
    
    display(sprintf('Processing Subject #%i',s));
    sub = subjs(s);
    mainpath = ['/Volumes/EXT_HD/ON_eegfmri/s' num2str(sub) '/clean_data2/'];
    
    % data and parameters
    data =[];
    data.subjs = sub;
    data.runs = runs;
    data.spv = 35; spv = 35;% slices per volume
    data.fs = 500;
    data.truncfirst_slices = 2*spv; tfslices = 2*spv;
    data.trunclast_samples = data.fs; tlsamps = data.fs;
    data.nbands = 6; nbands = 6;
    data.Nchan = 256; nchan = 256;
    data.badch = S(sub).badch;
    data.trialsperrun = 80; tpr = 80;
    data.goodtrials =  true(nruns*data.trialsperrun,1);
    data.goodtrials(S(sub).badtr) = false;
    data.LP = 30; data.HP=1; LP=data.LP;HP=data.HP;
    
    if strcmp(lock,'RT')
        data.dur = [-0.3 0.2]; % duration around response
        data.baseline_dur = [-0.7 -0.2]; % duration before event to calculate noise level
    elseif strcmp(lock,'evonset')
        data.dur = [-0.5 1.5];
    end
    
    data.samples =  data.dur(1)*data.fs:data.dur(2)*data.fs;
    data.baseline_samples = data.baseline_dur(1)*data.fs:data.baseline_dur(2)*data.fs;
    data.nsamples = numel(data.samples); spt =numel(data.samples); % samples per trial
    
    % preallocate variables
    ntrials = nruns*tpr;
    
    % preallocate fields for conditition trials
    for c =1:numel(conds)
        data.([conds{c} '_trials']) = false(ntrials,1);
    end
    
    % for every run
    trial_count =1;
    for r = runs
        
        display(sprintf('Processing run #%i',r));
        % load the data for that run
        datapath =['r' num2str(r)];
        temp1 = load([mainpath datapath '/data_' datacondition]);
        temp2 = load([mainpath datapath '/behdata.mat']);
        
        contdata = temp1.S; temp1 =[];
        behavdata = temp2.data; temp2 =[];
        
        %get rid of NaN RTs
        behavdata.RT(isnan(behavdata.RT)) = 3.1;
        
        for c =1:numel(conds)
            data.([conds{c} '_trials']) = behavdata.(conds{c});
        end
        
        % behavioral performance
        data.dP = behavdata.dP;
        data.RTs = behavdata.RT;
        
        % samples to calculate power average power in the run
        % using 2 TRs into the run and 2 TR before the run is over
        %signal_ind = contdata.MR_Pulses(2*spv):contdata.MR_Pulses(end-2*spv);
        
        % make sure that truncating the signal doesn't truncate the events
        first_event_ind = contdata.ev_markers(1);
        last_event_ind = contdata.ev_markers(end);
        
        % first event
        truncation_ok = 0;
        signal_pad = 0;
        while truncation_ok == 0
            if contdata.MR_Pulses(tfslices-signal_pad) < contdata.ev_markers(1)+data.samples(1)
                signal_ind(1) = contdata.MR_Pulses(tfslices-signal_pad);
                truncation_ok = 1;
            else
                signal_pad = signal_pad+1;
            end
            
            if signal_pad > 1e3
                display('truncating error ')
                break
            end
        end
        
        % last event
        signal_ind(2) = contdata.MR_Pulses(end)-tlsamps;
        
        % truncate signal
        truncdata = single(contdata.signal(:,signal_ind(1):signal_ind(2)));
        truncdata = single(eegfmri_filt_par_v5(double(truncdata),data.fs,LP,HP,[]));
        
        
        % re index events
        ev_markers = contdata.ev_markers - signal_ind(1);
        
        
        if strcmp(lock,'RT')
            data.goodtrials =  behavdata.RT<2;
            %xi =  ev_markers' + behavdata.RT +data.samples(1);
            xi =  ev_markers' + ceil(behavdata.RT*data.fs) + data.samples(1);
            yi = ev_markers' + data.baseline_samples(1)';
        elseif strcmp(lock,'evonset')
            xi =  ev_markers' + data.samples(1);
        end
        
        % create a matrix of the trial samples
        trial_samps = repmat(xi,1,spt)+repmat(1:spt,tpr,1);
        
        % create a matrix of the baseline prior to the events
        baseline_samps = repmat(yi,1,spt)+repmat(1:spt,tpr,1);
        
        % create matrix of trials
        data.trials = reshape(truncdata(:,trial_samps)...
            ,nchan,tpr,spt);
        
        data.baselines = reshape(truncdata(:,baseline_samps)...
            ,nchan,tpr,spt);
        
        data.mean_trial_channel = median(mean(data.trials(:,data.goodtrials,:),3),2);
        data.mean_baseline_channel = median(mean(data.baselines(:,data.goodtrials,:),3),2);
        data.std_baseline_channel = std(reshape(data.baselines(:,data.goodtrials,:),256,[]),[],2);
        
        data.CNR_channel = abs(data.mean_trial_channel-data.mean_baseline_channel)./data.std_baseline_channel;
        
        parsave( [mainpath datapath '/CNRdata_' datacondition],data,'data','-v7.3')
       
    end
    % save
%     resultsdir = [mainpath 'results'];
%     erpdir = [savepath foldernames{s} '/erpData'];
%     if ~exist(resultsdir)
%         mkdir(resultsdir);
%     end
%     if ~exist(erpdir)
%         mkdir(erpdir);
%     end
    %parsave([mainpath '/results/trial_data_LP30Hz_zscored_' lock ],data,'data','-v7.3')
    %parsave([savepath foldernames{s} '/erpData/spectraldata2_' lock],data,'data','-v7.3')
end
matlabpool close

clear all;
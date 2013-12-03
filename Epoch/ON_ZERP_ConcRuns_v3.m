
% this script is to average events by condition within a run and to put all
% runs together
% ZSCORE

clearvars

%ldSubs = load('/Users/alangordon/mounts/w5/alan/eegfmri/fmri_data/sa_all.mat');
%ldSubs = load('/Users/alangordon/mounts/w5/alan/eegfmri/fmri_data/sa_all.mat');

addpath(genpath('/Users/alexgonzalez/Documents/EEG_fMRI/Scripts/'))

subjects = 23:27;

%subjs = [15:21];
%runs = 1:2;


lock = 'evonset';

% isOpen = matlabpool('size') > 0;
% if ~isOpen
%     matlabpool('open',2)
% end


%foldernames = {'ef_040412'  'ef_040512' 'ef_040712' 'ef_040712_2' 'ef_041112' 'ef_042912' 'ef_050112'};
%foldernames = {'ef_050112'};
%foldernames = {'ef_091211' 'ef_091511' 'ef_092111' 'ef_092211' 'ef_092711' 'ef_092911' 'ef_100511' 'ef_101411'};
%foldernames = {'ef_091211' 'ef_091511' 'ef_092111' 'ef_092211' 'ef_092911' 'ef_100511' 'ef_101411'};
%foldernames = {'ef_092711'};

savepath = '/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/';

conds = {'old','hits','HC_hits','Rem_hits','misses','new','cr','HC_cr', ...
    'LC_cr','LC_hits','FA'};

%trials_ind_start = 1:80:400;
%eegfmri_ON_trialch_info

for s =  subjects;
    
    S = eeg_fmri_on_subject_info(s);
    curr_sub = EF_num2Sub(s);
    par = EF_Params_AG(curr_sub);
    
    runs = par.scans_to_include;
    nruns = numel(par.scans_to_include);
    
    display(sprintf('Processing Subject #%i',s));
    sub = par.subNo;
    RawDatapath = ['~/Documents/EEG_FMRI/RawData/s' num2str(sub) '/PreProccesedData/'];
    BehavDatapath = ['~/Documents/EEG_FMRI/BehavioralData/s' num2str(sub) '/'];
    %mainpath = ['/Volumes/EXT_HD/ON_eegfmri/s' num2str(sub) '/clean_data2/'];
    
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
    data.badch = S.r(1).badch;
    data.trialsperrun = 80; tpr = 80;
    data.goodtrials =  true(nruns*data.trialsperrun,1);
    %data.goodtrials(S(sub).badtr) = false;
    data.LP = 30; LP = 30;
    data.HP = 1.5; HP = 1.5;
    
    if strcmp(lock,'RT')
        data.dur = [-1 1];
    elseif strcmp(lock,'evonset')
        data.dur = [-.25 2];
    end
    
    data.samples =  data.dur(1)*data.fs:data.dur(2)*data.fs;
    data.nsamples = numel(data.samples); spt =numel(data.samples); % samples per trial
    
    % preallocate variables
    ntrials = nruns*tpr;
    
    % preallocate fields for conditition trials
    for c =1:numel(conds)
        data.([conds{c} '_trials']) = false(ntrials,1);
    end
    
    %data.ztrialdata = zeros(nchan,ntrials,spt,'single');
    data.trialdata = zeros(nchan,ntrials,spt,'single');
    
    % for every run
    trial_count =1;
    for r = runs
        
        display(sprintf('Processing run #%i',r));
        % load the data for that run
        datapath =['r' num2str(r)];
        temp1 = load([RawDatapath datapath '/data']);
        temp2 = load([BehavDatapath datapath '/behdata.mat']);
        contdata = temp1.S; temp1 =[];
        behavdata = temp2.data; temp2 =[];
        
        %get rid of NaN RTs
        behavdata.RT(isnan(behavdata.RT)) = 3.1;
        
        for c =1:numel(conds)
            data.([conds{c} '_trials'])(trial_count:trial_count+tpr-1) = ...
                behavdata.(conds{c});
        end
        % behavioral performance
        data.dP(r) = behavdata.dP;
        data.RTs(trial_count:trial_count+tpr-1) = behavdata.RT;
        
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
        truncdata = single(contdata.recons_signal(:,signal_ind(1):signal_ind(2)));
        % re index events
        ev_markers = contdata.ev_markers - signal_ind(1);
        
        % low pass remaining data
        display('Filtering data')
        filtdata = FIR_Filter(truncdata,data.fs,LP,HP);
        truncdata = [];
        % zscore data
        %zdata = zscore(filtdata,0,2);
        
        if strcmp(lock,'RT')
            data.goodtrials(trial_count:trial_count+tpr-1) = ...
                data.goodtrials(trial_count:trial_count+tpr-1)& behavdata.RT<2;
            %xi =  ev_markers' + behavdata.RT +data.samples(1);
            xi =  ev_markers' + ceil(behavdata.RT*data.fs) + data.samples(1);
        elseif strcmp(lock,'evonset')
            xi =  ev_markers' + data.samples(1);
        end
        
        % create a matrix of the trial samples
        
        trial_samps = repmat(xi,1,spt)+repmat(1:spt,tpr,1);
        
        % create matrix of trials
%         data.ztrialdata(:,trial_count:trial_count+tpr-1,:) = reshape(zdata(:,trial_samps)...
%             ,nchan,tpr,spt);
        data.trialdata(:,trial_count:trial_count+tpr-1,:) = reshape(filtdata(:,trial_samps)...
            ,nchan,tpr,spt);
        
        zdata=[];
        filtdata=[];
        contdata =[];
        trial_count = trial_count + tpr;
    end
    % save
    resultsdir = [savepath curr_sub '/erpData/results/'];
    erpdir = [savepath curr_sub '/erpData'];
    if ~exist(resultsdir)
        mkdir(resultsdir);
    end
    if ~exist(erpdir)
        mkdir(erpdir);
    end
    %parsave([mainpath '/results/trial_data_LP30Hz_zscored_' lock ],data,'data','-v7.3')
    save([savepath curr_sub '/erpData/results/trial_data_LP30Hz_' lock],'data','-v7.3')
end
matlabpool close

clear all;
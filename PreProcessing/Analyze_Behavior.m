% behavioral data analysis
% eeg_fmri_cni

clear;
clc


for subject = [17]
    
    
    fileinfo=1;
    eegfmri_ON_trialch_info
    eeg_fmri_on_subject_info
    
    
    mainpath1 = ['/Volumes/EXT_HD/ON_eegfmri/s' num2str(subject) '/clean_data2'];
    mainpath2 = ['/Volumes/EXT_HD2/ON_eegfmri/s' num2str(subject) '/clean_data'];
    
    if ~exist(mainpath1,'dir')
        mkdir(mainpath1)
%        mkdir(mainpath2)
    end
    
    for j = 1: length(runs)
        load([datapath filename{j}])
        
        data = [];
        data.subject = subject;
        data.run = j;
        data.path = [datapath filename{j}];
        
        data.condition = theData.oldNew'; % 1= new, 2 = old
        data.resp = zeros(numel(theData.item),1);
        data.RT = zeros(numel(theData.item),1);
        
        for i = 1: length (theData.item)
            try
                % made response in judge period
                if ~strcmp(theData.judgeResp(i),'noanswer')
                    data.resp(i) = str2num(theData.judgeResp{i}(1));
                    data.RT(i) = theData.judgeRT{i} +1;
                elseif ~strcmp(theData.stimresp(i),'noanswer')
                    % made response when the stim was on
                    data.resp(i) = str2num(theData.stimresp{i}(1));
                    data.RT(i) = theData.stimRT{i};
                else
                    % invalid trial
                    data.resp(i) = 0;
                    data.RT(i) = 3.1;
                end
                
            catch
                % invalid trial
                resp(i) = 0;
                data.RT(i) = 3.1;
            end
        end
        
        
        % HC hit trials: when R and HO match old condition (1)
        data.old = (data.condition == 1);
        data.hits = [(data.condition == 1) & (data.resp==R|data.resp==HCO|data.resp==LCO)==1];
        data.HC_hits = [(data.condition == 1) & (data.resp==HCO)==1];
        data.Rem_hits = [(data.condition == 1) & (data.resp==R)==1];
        
        data.LC_hits = data.hits & ~data.HC_hits & ~data.Rem_hits;
        data.misses = [(data.condition==1) & (data.resp==LCN|data.resp==HCN)==1];
        data.hit_trials = find(data.hits);
        data.HC_hit_trials = find(data.HC_hits);
        data.Rem_hit_trials = find(data.Rem_hits);
        data.LC_hit_trials = find(data.LC_hits);
        data.miss_trials = find(data.misses);
        
        % HC cr_trials: when HN and LN match new condition (2)
        data.new = (data.condition == 2);
        data.cr = [(data.condition==2) & (data.resp==HCN|data.resp==LCN)==1];
        data.HC_cr = [(data.condition==2) & (data.resp==HCN)==1];
        data.LC_cr = data.cr & ~data.HC_cr;
        data.FA = [(data.condition == 2) & (data.resp==R|data.resp==HCO|data.resp==LCO)==1];
        data.cr_trials = find(data.cr);
        data.HC_cr_trials = find(data.HC_cr);
        data.LC_cr_trials = find(data.LC_cr);
        data.FA_trials = find(data.FA);
        
        data.dP = calc_dPrime(sum(data.hits),sum(data.misses),sum(data.FA),sum(data.cr))
        
        
        if ~exist([mainpath1 '/r' num2str(j)'],'dir')
            mkdir([mainpath1 '/r' num2str(j)'])
%            mkdir([mainpath2 '/r' num2str(j)'])
        end
        save([mainpath1 '/r' num2str(j) '/behdata.mat'],'data')
        %save([mainpath2 '/r' num2str(j) '/behdata.mat'],'data')        
        
    end
end
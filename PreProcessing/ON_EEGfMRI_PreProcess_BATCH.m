% script that clears GA and PRA for multiple blocks and calculates the trials
% in each run for EEG/fMRI Old new experiment
% it saves each run individually in a struct with the behavioral info

clearvars
%close all

% subject number
subj = [22];
% runs
runs = [1 2 3 4 5];

% name of variable
prefix = 's';
suffix = 'mff';

addpath(genpath('/Users/alexgonzalez/Documents/MATLAB/Mylib/eeglab'))
addpath(genpath('/Users/alexgonzalez/Documents/MATLAB/Mylib/amri_eegfmri_toolbox'))

for sub = subj;
    varname = [prefix num2str(sub) 'r'];
    ext = '.mat';
    mainpath        = '/Users/alexgonzalez/Documents/EEG_fMRI';
    rawdatapath     = [mainpath '/RawData/s' num2str(sub) '/'];
    behaviordatapath = [mainpath '/BehavioralData/s' num2str(sub) '/'];

    for r = 1:5%runs
        %% load data and set parameters
        S=[];
        S.subj = sub;
        S.run = r;
        
        display(sprintf('Processing Subject %i Run # %i', S.subj, S.run));
        S.filename = [rawdatapath varname num2str(r) ext];
        
        % load data
        temp = load(S.filename);
        % signal
        S.signal = temp.([varname num2str(r) suffix]);
        % reference channel
        S.refchannel = 257;
        % exclude refchanel from further analysis
        S.signal(S.refchannel,:)=[];
        
        % Default Parameters:
        % how many epochs to for template
        S.NPulseEpochs = 15;
        
        % how much should the sliding window move
        S.sldwin_epochs = 5;%floor(S.NPulseEpochs/2);
        
        % how many slices per volume
        S.slicespervolume = 35;
        
        % Volume acquisition length (TR length in seconds)
        S.TR_length = 2;
        
        % filter settings
        S.lowpasscut = 30;
        S.highpasscut = 1;
        S.notch = 60;
        
        %% Recording Information
        
        % MR_Markers
        S.MR_Pulses_orig = single([temp.MR_Pulse{4,:}]);
        
        % event markers
        S.ev_markers = single([temp.ECI_TCPIP_55513{4,:}]);
        % event names
        S.ev_names = temp.ECI_TCPIP_55513(1,:);
        % old item trials
        S.old_stim = strcmp(S.ev_names,'STI1');
        % new item trials
        S.new_stim = strcmp(S.ev_names,'STI2');
        % null events
        S.null_stim = strcmp(S.ev_names,'STI0');
        % sampling rate
        S.fs = temp.samplingRate;
        % event duration in seconds
        S.duration_sec = [-0.2 1];
        % event duration in samples
        S.duration_samp = S.duration_sec*S.fs;
        
        % pulse markers for DIN_8
        %do not include the first 10
        S.ignore_firstpulses = 5;
        S.ignore_lastpulses = 5;
        % do not include the last 10
        % move the marker 200ms back
        S.pulse_markers_orig = single([temp.DIN_8{4,:}]);
        
        % 200 ms marker lag from pulse event
        S.marker_lag = 0.2*S.fs;
        clear temp
        
        % clear the gradient artificat
        S = ST_GA_Clean(S);
        
         % filter signal
         S.GAC_filt_signal = single(eegfmri_filt_v3(S.GAClean_signal, ...
             S.fs,S.lowpasscut,S.highpasscut,S.notch,0));
%         
%         % clean the pulse artifcat
%         S = ST_PA_Clean_v3(S);
%         
%         S.recons_signal = single(eegfmri_filt_v3(S.recons_signalpad, ...
%             S.fs,S.lowpasscut,S.highpasscut,S.notch,0));
%         
         S.signal = [];
         S.recons_signalpad =[];
%         S.GAC_filt_signal = [];
%         S.GAClean_signal = [];
        
        
        % clear unncessary fields
        %S.GAC_filt_signal = [];
        if ~exist([mainpath1 '/clean_data2/r' num2str(r)'],'dir')
            mkdir([mainpath1 '/clean_data2/r' num2str(r)'])
            %mkdir([mainpath2 '/clean_data2/r' num2str(r)'])
        end
        save([mainpath1 '/clean_data2/r' num2str(r) '/data_NOBCGCleaning'],'S','-v7.3')
        %save([mainpath2 '/clean_data2/r' num2str(r) '/data'],'S','-v7.3')
    end
end
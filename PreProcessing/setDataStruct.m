function setDataStruct(subj,run)
% setDataStruct(subj,run)
% this function creates the data structure that will be used in further scripts.
% inputs:
%   subj -> subject number
%   run  -> run number

%% directories and other settings

subjId = EF_num2Sub(subj);

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath  'raw/'];
behaviorPath    = [subjPath 'BehavioralData/r' num2str(run) '/'];
filename        = ['s' num2str(subj) 'r' num2str(run) '.mat'];

% name of variable
prefix  = 's';
suffix  = 'mff';
varname = [prefix num2str(subj) 'r' num2str(run) suffix];

display(sprintf('Processing Subject %i Run # %i', subj, run));

%% load data and set parameters
S=[];
S.subj = subj;
S.run = run;

% load behavioral data
temp = load([behaviorPath 'behdata.mat']);
S.behavior = temp.data;

% load data
temp    = load([rawPath filename]);
% signal
S.signal = temp.(varname);
% reference channel
S.refchannel = 257;
% exclude refchanel from further analysis
S.signal(S.refchannel,:)    =   [];
S.nChan     = size(S.signal,1);

% MR_Markers
S.MR_Pulses = single([temp.MR_Pulse{4,:}]);

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
S.SR = temp.samplingRate;

% do not include the last 10
% move the marker 200ms back
S.pulse_markers = single([temp.DIN_8{4,:}]);

clear temp

savePath = [subjPath 'raw/r' num2str(run) '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
save([savePath 'RawData.mat'],'S')

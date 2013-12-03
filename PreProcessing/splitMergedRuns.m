% split merged runs from exported mat file from netstation
% works for first 2 runs
function splitMergedRuns(subj)

prefix = 's';
suffix = 'mff';
mr1 = 1;
mr2 = 2;

subjId = EF_num2Sub(subj);
varname = [prefix num2str(subj) 'r' num2str(mr1) 'r' num2str(mr2) suffix];
rename1 = [prefix num2str(subj) 'r' num2str(mr1)];
rename2 = [prefix num2str(subj) 'r' num2str(mr2)];

datapath = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/raw/'];
%datapath = ['~/Documents/EEG_fMRI/RawData/s' num2str(subj) '/raw/'];
filename = [prefix num2str(subj) 'r' num2str(mr1) 'r' num2str(mr2) '.mat'];

full_filepath = [datapath filename];
y = load(full_filepath);

MRpulses = y.MR_Pulse;
DIN8 = y.DIN_8;
Events = y.ECI_TCPIP_55513;
signal1 = y.([varname '1']);
signal2 = y.([varname '2']);

[~,MRpulse_split_ind] = min(diff([MRpulses{4,:}]));
[~,DIN8_split_ind] = min(diff([DIN8{4,:}]));
[~,Events_split_ind] =  min(diff([Events{4,:}]));
samplingRate = y.samplingRate;

clear y
%% save run #1

ECI_TCPIP_55513 = reshape({Events{:,1:Events_split_ind}},4,[]);
DIN_8 = reshape({DIN8{:,1:DIN8_split_ind}},4,[]);
MR_Pulse = reshape({MRpulses{:,1:MRpulse_split_ind}},4,[]);

eval([rename1 suffix '= signal1;']);
save([datapath rename1],[rename1 suffix],'ECI_TCPIP_55513', 'DIN_8', 'MR_Pulse', 'samplingRate')

%% save run #2

ECI_TCPIP_55513 = reshape({Events{:,Events_split_ind+1:end}},4,[]);
DIN_8 = reshape({DIN8{:,DIN8_split_ind+1:end}},4,[]);
MR_Pulse = reshape({MRpulses{:,MRpulse_split_ind+1:end}},4,[]);

eval([rename2 suffix '= signal2;']);
save([datapath rename2],[rename2 suffix],'ECI_TCPIP_55513', 'DIN_8', 'MR_Pulse','samplingRate')



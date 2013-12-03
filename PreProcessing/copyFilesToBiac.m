
biacPath =  '/mnt/biac3/wagner5/alan/eegfmri/fmri_data/';
localPath = '~/Documents/EEG_fMRI/RawData/';

for s = 4:27
    subjNum = ['s' num2str(s)];
    subjName = EF_num2Sub(s);
    targetDir = [biacPath subjName '/eeg/'];   
    evalStr = ['!cp -r ' localPath subjNum '/* ' targetDir ];
    eval(evalStr)    
end

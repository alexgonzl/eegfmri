function PlotRaw(subj, run, ch)

addpath ../PreProcessing/
subjId = EF_num2Sub(subj);

%% directories

SampRange       = 10e4:10.2e4;

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath  'raw/'];
filename        = ['s' num2str(subj) 'r' num2str(run) '.mat'];

% name of variable
prefix  = 's';
suffix  = 'mff';
varname = [prefix num2str(subj) 'r' num2str(run) suffix];

temp        = load([rawPath filename]);
savePath    = '~/Documents/EEG_fMRI/Results/Plots/ProcessingSteps/Raw/';

signal  = temp.(varname)(ch,:);
MRSamps = [temp.MR_Pulse{4,:}];
SR      = temp.samplingRate;

if SR==500, comp=1; elseif SR==100, comp = 5; end

SampRange       = unique(ceil((SampRange)/comp));
nSamps          = size(signal,2);
TotalTime       = nSamps/SR;
t               = linspace(0,TotalTime,nSamps);
MRTimes         = t(MRSamps+1);
MRTimes         = MRTimes(ismember(MRSamps,SampRange));

%%
close all

figure(1);clf; hold on;
filename1   = ['Raw_S' num2str(subj) 'R' num2str(run) 'CH' num2str(ch)];

set(gcf,'position',[100 500 1000 200],'paperPositionMode','auto')
plot(t(SampRange),signal(SampRange),'k');axis tight

YLim = ylim;
for i = 1:numel(MRTimes)
    plot([MRTimes(i) MRTimes(i)],[YLim(1),YLim(1)+diff(YLim)/10],'r','linewidth',2)
end

j = MRSamps(ismember(MRSamps,SampRange));
for i = [4 39]
    plot(t(j(i):j(i+1)),signal(j(i):j(i+1)),'b','linewidth',1)
    plot([MRTimes(i) MRTimes(i)],[YLim(1),YLim(1)+diff(YLim)/10],'b','linewidth',2)
end

set(gca,'FontSize',16)
xlabel(' Time (s) ')
ylabel(' \muV ')
set(gca,'box','off')
set(gca,'lineWidth',1.5)
print(gcf,'-depsc2','-loose',[savePath filename1])
hold off

%% 
figure(2); clf; hold on;
filename2   = ['PSDRaw_S' num2str(subj) 'R' num2str(run) 'CH' num2str(ch)];

set(gcf,'position',[100 500 600 400],'paperPositionMode','auto')
H = spectrum.welch('han',2000,90);
Ho= psd(H,signal,'FS',SR,'nfft',1024*4);
h=plot(Ho);
xlim([0 50])
ylim([-10 50])
set(h(1),'color',[0 0 0],'linewidth',2)
set(legend,'box','off','location','best')

set(gca,'box','off')
set(gca,'lineWidth',1.5)
set(gca,'FontSize',16)
set(get(gca,'xlabel'),'FontSize',16)
set(get(gca,'ylabel'),'FontSize',16)
set(get(gca,'title'),'visible','off')

print(gcf,'-depsc2','-loose',[savePath filename2])
hold off
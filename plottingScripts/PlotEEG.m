function PlotEEG(subj, run, ch, type, preFix)
% PlotEEG(subj, run, ch, type)
% subj  -> subject number
% run   -> run number
% ch    -> channel number
% type  -> string indicating raw, GA clean, PRA clean or others.

subjId = EF_num2Sub(subj);
%% directories

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
SampRange       = 10e4:10.2e4;

switch type
    case 'raw'
        rawPath         = [subjPath  type '/r' num2str(run) '/'];
        filename        = 'RawData.mat';        
    otherwise        
        rawPath         = [subjPath  type 'Clean/r' num2str(run) '/'];
        filename        = [preFix 'CleanData.mat'];                           
end

load([rawPath filename]);

savePath = ['~/Documents/EEG_fMRI/Results/Plots/ProcessingSteps/' type '/'];
if ~exist(savePath,'dir'), mkdir(savePath),end;
filename1 = [preFix '_S' num2str(subj) 'R' num2str(run) 'CH' num2str(ch)];
filename2 = ['PSD' preFix  '_S' num2str(subj) 'R' num2str(run) 'CH' num2str(ch)];

signal          = S.signal(ch,:);
SR              = S.SR;
if SR==500, comp=1; elseif SR==100, comp = 5; end

MRSamps         = S.MR_Pulses;
BCGSamps        = S.pulse_markers;

SampRange       = unique(ceil((SampRange)/comp));
nSamps          = size(signal,2);
TotalTime       = nSamps/SR;
t               = linspace(0,TotalTime,nSamps);
MRTimes         = t(MRSamps+1);
MRTimes         = MRTimes(ismember(MRSamps,SampRange));
BCGTimes        = t(BCGSamps);
BCGTimes        = BCGTimes(ismember(BCGSamps,SampRange));


%%
close all

figure(1);clf; hold on;
set(gcf,'position',[100 500 1600 200],'paperPositionMode','auto')
plot(t(SampRange),signal(SampRange),'k');axis tight

YLim = ylim;
for i = 1:numel(MRTimes)
    plot([MRTimes(i) MRTimes(i)],[YLim(1),YLim(1)+diff(YLim)/10],'r','linewidth',2)
end
for i = 1:numel(BCGTimes)
    plot([BCGTimes(i) BCGTimes(i)],[YLim(1),YLim(1)+diff(YLim)/10],'b','linewidth',2)
end

set(gca,'FontSize',16)
xlabel(' Time (s) ')
ylabel(' uV ')
set(gca,'box','off')
set(gca,'lineWidth',1.5)
print(gcf,'-depsc2','-loose',[savePath filename1])
hold off

%%
figure(2); clf; hold on;
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
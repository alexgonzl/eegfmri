function PlotRaw(subj, run, ch)

subjId = EF_num2Sub(subj);
%% directories

subjPath        = ['/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/' subjId '/eeg/'];
rawPath         = [subjPath  'raw/'];
filename        = ['s' num2str(subj) 'r' num2str(run) '.mat'];

% name of variable
prefix  = 's';
suffix  = 'mff';
varname = [prefix num2str(subj) 'r' num2str(run) suffix];

temp    = load([rawPath filename]);

x       = temp.(varname)(ch,:);
SR      = temp.samplingRate;
%%
nSamps = size(x,2);
TotalTime = nSamps/SR;
t=linspace(0,TotalTime,nSamps);
samps = 1:nSamps;
y = [temp.MR_Pulse{4,:}];
D8 = t(ismember(samps,y));

savepath = '~/Documents/EEG_fMRI/Results/Plots/ProcessingSteps/';
%%
close all
SampRange = 10e4:10.2e4;
timeD8 = D8(D8 >= min(t(SampRange)) & D8 <= max(t(SampRange)));

figure(1);clf; hold on;
set(gcf,'position',[100 500 1600 200],'paperPositionMode','auto')
plot(t(SampRange),x(SampRange),'k');axis tight

for i = 1:numel(timeD8)
    plot([timeD8(i) timeD8(i)],ylim,'r','linewidth',2)
end
set(gca,'FontSize',16)
xlabel(' Time (s) ')
ylabel(' uV ')
set(gca,'box','off')
set(gca,'lineWidth',1.5)
filename = ['RAWs' num2str(subj) 'r' num2str(run) 'CH' num2str(ch)];
print(gcf,'-depsc2','-loose',[savepath filename])
hold off

%% 
figure(2); clf; hold on;
set(gcf,'position',[100 500 1600 200],'paperPositionMode','auto')
H = spectrum.welch('han',1000,90);
Ho= psd(H,x,'FS',SR,'nfft',1024,'ConfLevel',0.99);
h=plot(Ho);
set(h(1),'color',[0 0 0],'linewidth',2)
set(h(2),'linewidth',2)
set(h(3),'linewidth',1)
set(legend,'box','off','location','best')

set(gca,'box','off')
set(gca,'lineWidth',1.5)
set(gca,'FontSize',16)
set(get(gca,'xlabel'),'FontSize',16)
set(get(gca,'ylabel'),'FontSize',16)
set(get(gca,'title'),'visible','off')

filename = ['RAWPSDs' num2str(subj) 'r' num2str(run) 'CH' num2str(ch)];
print(gcf,'-depsc2','-loose',[savepath filename])
hold off
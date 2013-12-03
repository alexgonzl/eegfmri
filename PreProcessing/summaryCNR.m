function [out] = summaryCNR(CNRtype)


% at what stage;    GA  -> after GA cleanings
%                   BCG -> after BCG cleaning


mainPath    = '/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/';
lockType    = 'RT';

%%
subjs = [4:6 8:13 15 16 18:20 22 23 25:27];
runs  = 1:5;

out = [];
out.CNR_FASTR_GA      = nan(numel(subjs)*numel(runs),1);
out.CNR_OBS_BCG     = nan(numel(subjs)*numel(runs),1);
out.CNR_ST_GA      = nan(numel(subjs)*numel(runs),1);
out.CNR_ST_BCG     = nan(numel(subjs)*numel(runs),1);
out.runNum      = zeros(numel(subjs)*numel(runs),1);
out.subjNum     = zeros(numel(subjs)*numel(runs),1);

counter = 1;
for s = subjs
    for r = runs
        out.subjNum(counter)    = s;
        out.runNum(counter)     = r;
        
        subjId = EF_num2Sub(s);
        
        %if counter == 49; keyboard; end
        % FASTR GA
        try
            fileName    = ['CNR' lockType 'LockERPsFiltFASTRGA.mat'];
            subjPath    = [mainPath subjId '/eeg/epoched/r' num2str(r) '/CNR/'];
            load([subjPath fileName])
            out.CNR_FASTR_GA(counter) = S.(['me' CNRtype 'CNR']);
        catch            
        end
        
        % ST GA
        try
            fileName    = ['CNR' lockType 'LockERPsFiltSTGA.mat'];
            subjPath    = [mainPath subjId '/eeg/epoched/r' num2str(r) '/CNR/'];
            load([subjPath fileName])
            out.CNR_ST_GA(counter) = S.(['me' CNRtype 'CNR']);
        catch            
        end
        
        % OBS BCG
        try
            fileName    = ['CNR' lockType 'LockERPsFiltOBSBCGFiltFASTRGA.mat'];
            subjPath    = [mainPath subjId '/eeg/epoched/r' num2str(r) '/CNR/'];
            load([subjPath fileName])
            out.CNR_OBS_BCG(counter) = S.(['me' CNRtype 'CNR']);
        catch            
        end
        
        % ST BCG
        try
            fileName    = ['CNR' lockType 'LockERPsFiltSTBCGFiltSTGA.mat'];
            subjPath    = [mainPath subjId '/eeg/epoched/r' num2str(r) '/CNR/'];
            load([subjPath fileName])
            out.CNR_ST_BCG(counter) = S.(['me' CNRtype 'CNR']);
        catch
        end

        counter = counter + 1;
        
    end
end

% N=numel(subjs)*numel(runs);
% nSubjs = numel(unique(subjNum));
%%
%
% figure(1); clf; hold on;
% lims = ceil(max([max(CNR_GA) max(CNR_BCG)]) + 2);
% plot([0 lims],[0 lims],'r','linewidth',2)
% scatter(CNR_GA, CNR_BCG,'k','filled');
% set(gca,'linewidth',2,'fontSize',14)
% %set(gca,'yTick',1:2:lims)
% %set(gca,'xTick',1:2:lims)
% xlabel(' CNR before BCG Clean ','fontsize',14)
% ylabel(' CNR after  BCG Clean ','fontsize',14)
%
%
% %%
%
% figure(2); clf; hold on; axis
% y = CNR_BCG./CNR_GA-1;
% lims = [min(y)+0.1*min(y)  max(y)+0.1*max(y)];
% xlim([0.5 5.5]); ylim([lims]) ;
% set(gca,'linewidth',2,'fontSize',14)
% set(gca,'xTick',1:5)
% plot([0 6],[0 0],'--','color',[0.5 0.5 0.5],'linewidth',2)
% scatter(runNum+randn(N,1)*0.08,CNR_BCG./CNR_GA-1, 'filled','k');
% for r = 1:5
%     plot([r r],[mean(y(runNum==r))-std(y(runNum==r)) mean(y(runNum==r))+std(y(runNum==r))], ...
%         'color',[0.8 0.5 0.5],'linewidth',4)
%     plot([r-0.3 r+0.3],[median(y(runNum==r)) median(y(runNum==r))], ...
%         'r','linewidth',2)
% end
% xlabel(' Run Number ','fontsize',14)
% ylabel(' Gain ','fontsize',14)
%
% %%
%
% figure(3); clf; hold on; axis
% y = CNR_BCG./CNR_GA-1;
% lims = [min(y)+0.1*min(y)  max(y)+0.1*max(y)];
%
% set(gca,'linewidth',2,'fontSize',14)
% set(gca,'xTick',1:nSubjs)
% set(gca,'xTickLabel',subjs)
% xlim([0.5 nSubjs+0.5]);ylim([lims]) ;
% plot([0 nSubjs+1],[0 0],'--','color',[0.5 0.5 0.5],'linewidth',2)
%
% for s = 1:nSubjs
%
%     subjId = subjs(s);
%     plot([s s],[mean(y(subjNum==subjId))-std(y(subjNum==subjId)) mean(y(subjNum==subjId))+std(y(subjNum==subjId))], ...
%         'color',[0.8 0.5 0.5],'linewidth',4)
%     plot([s-0.3 s+0.3],[median(y(subjNum==subjId)) median(y(subjNum==subjId))], ...
%         'r','linewidth',2)
%     %scatter(s+randn(5,1)*0.01,y(subjNum==subjId), 50, [0.5 0.5 0.8; 0.4 0.4 0.6;0.2 0.2 0.4;0.1 0.1 0.2; 0 0 0.1],'filled');
% end
% scatter(reshape(repmat(1:nSubjs,5,1),[],1)+randn(N,1)*0.01,CNR_BCG./CNR_GA-1, 'filled','k');
%
% xlabel(' Subject Number ','fontsize',14)
% ylabel(' Gain ','fontsize',14)
%



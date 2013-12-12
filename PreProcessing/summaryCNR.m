function [out] = summaryCNR(lockType)


% lockType : {'stim','RT'}


mainPath        = '/biac4/wagner/biac3/wagner5/alan/eegfmri/fmri_data/';
saveFileName    = strcat('summaryCNR',lockType);
savePath        = strcat(mainPath,'EEG_group/','CNR/');

if ~exist(savePath,'dir'), mkdir(savePath), end;

%%

out = [];
out.subjs   = [4:6 8:13 15 16 18:20 22 23 25:27];
out.runs    = 1:5;

nBlocks     = numel(out.subjs)*numel(out.runs);

out.runNum              = zeros(nBlocks,1);
out.subjNum             = zeros(nBlocks,1);

out.colNames            = {'metCNR','setCNR','q25tCNR','q75tCNR','mebCNR','nTrials'};
out.methods             = {'FiltFASTRGA','FiltSTGA','FiltSTBCGFiltSTGA','FiltOBSBCGFiltFASTRGA', 'FiltOBSBCGFiltSTGA'};

nCols       = numel(out.colNames);
nMethods    = numel(out.methods);

for jj = 1:nMethods
    out.(out.methods{jj}) = nan(nBlocks,nCols);
end

counter = 1;
for s = out.subjs
    for r = out.runs
        out.subjNum(counter)    = s;
        out.runNum(counter)     = r;
        
        subjId = EF_num2Sub(s);
        subjPath    = [mainPath subjId '/eeg/epoched/r' num2str(r) '/CNR/'];
        
        for jj = 1:nMethods
            try
                fileName    = ['CNR' lockType 'LockERPs' out.methods{jj} '.mat'];
                load([subjPath fileName])
                
                for col = 1:nCols;
                    out.(out.methods{jj})(counter,col) = S.(out.colNames{col});
                end
            catch
            end
        end
        counter = counter + 1;
    end
end

save(strcat(savePath,saveFileName),'out')

% N=nBlocks;
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



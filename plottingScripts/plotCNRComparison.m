figure(1); clf; hold on;
x = out.FiltFASTRGA(:,1);
y = out.FiltSTGA(:,1);

lims = 25;
plot([0 lims],[0 lims],'r','linewidth',2)
scatter(x, y,'k','filled');
set(gca,'linewidth',2,'fontSize',14)
%set(gca,'yTick',1:2:lims)
%set(gca,'xTick',1:2:lims)
xlabel(' CNR after FASTR GA cleaning (Niazy,2005) ','fontsize',14)
ylabel(' CNR after ST GA cleanning ','fontsize',14)
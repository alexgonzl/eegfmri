
subjs = [15 16 17 18 19 20];
runs = 1:5;

mainpath = '/Volumes/EXT_HD/ON_eegfmri/s';
datatype = {'NOBCGCleaning','STBCGClean','OBSBCGCleaning'};


CNR_meanch = zeros(numel(datatype),numel(subjs),numel(runs));
CNR_medianch = zeros(numel(datatype),numel(subjs),numel(runs));

for t = 1:numel(datatype);
    for s = 1:numel(subjs)
        parfor r = runs
            datapath =[mainpath num2str(subjs(s)) '/clean_data2/r' num2str(r)];
            temp = load( [datapath '/CNRdata_' datatype{t}]);
            
            CNR_meanch(t,s,r)  = mean(temp.data.CNR_channel);
            CNR_medianch(t,s,r)  = median(temp.data.CNR_channel);
            
        end
    end
end

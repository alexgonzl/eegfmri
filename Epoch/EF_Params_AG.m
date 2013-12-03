function par = EF_Params_AG(substr)
% function par = parParams(subject)
%sets up parameters for parmap batching.  Currently set-up to run once per
%subject...

%profile on

par.FMCorrect = 1;
thisMachine = 'alan';
par.subTask = 'DM';
par.eegAnalysis = 1;

%% subject-specific stuff
switch substr
     case 'ef_071411'
        par.scansSelect = 1:3;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [179 227 227];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 1;
        par.sliceorder = [1:2:35 2:2:34]; % ventral to dorsal
    case 'ef_072111'
        par.scansSelect = [1 2 4 5];
        par.goodEEGVols = [1 2];
        par.numvols = [178 178 0 178 178];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 2;
        par.sliceorder = [1:2:35 2:2:34]; % ventral to dorsal.
    case 'ef_083111'
        par.scansSelect = [1 4 5];
        par.goodEEGVols = par.scansSelect;
        par.numvols = [184 0 0 184 184];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 3;
        par.sliceorder = [35:-2:1 34:-2:2];
    case 'ef_091211'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [234 234 234 234 234];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 4;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [500: 575];
    case 'ef_091311'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 5;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [];
    case 'ef_091511'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 6;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [500: 575];
    case 'ef_091911'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 234];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 7;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [];
    case 'ef_092111'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 8;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [500: 575];
    case  'ef_092211'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 9;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [463: 538];
    case  'ef_092711'
        par.scansSelect = [1 2 3 4 5];
        par.goodEEGVols = [1 2];
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 10;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [550: 625];
    case  'ef_092911'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 11;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [488: 563];
    case  'ef_100511'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 12;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [463: 538];
    case 'ef_101411'
        %normalization is not good for this subject...
        % an effect of artefacts due to the eeg cap?
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 13;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_032912'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 14;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_040412'
        par.scansSelect = 1:5;
        par.goodEEGVols = 1:2;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 15;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_040512'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 16;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_040712'
        par.scansSelect = 1:5;
        par.goodEEGVols = 1:4;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 17;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_040712_2'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 18;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_041112'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 19;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_042912'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 20;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_050112'
        par.scansSelect = 1:4;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225];
        par.goodSub = 0;
        par.flagIt = 0;
        par.subNo = 21;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111512'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 27;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111412_1'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 25;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111412_2'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 26;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111112_1'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 22;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111112_2'
        par.scansSelect = 1:5;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 23;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];
    case 'ef_111112_3'
        par.scansSelect = 1:4;
        par.goodEEGVols = par.scansSelect;
        par.numvols = [225 225 225 225 225];
        par.goodSub = 1;
        par.flagIt = 0;
        par.subNo = 24;
        par.sliceorder = [35:-2:1 34:-2:2];
        par.criticalERPSamples = [450: 525];   
end

par.scans_to_include = par.goodEEGVols;

if (par.eegAnalysis)
    par.usedVols = par.numvols(par.goodEEGVols);
    par.usedScans = par.goodEEGVols;
else
    par.usedVols = par.numvols(par.scans_to_include);
    par.usedScans = par.scansSelect;
end

par.substr = substr;
par.numTrials = 80;


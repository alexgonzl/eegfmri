function S = IAR_GA_Clean(S)
% The function IAR_GA_Clean takes an EEG recorded signal from a
% simultaneous EEG/fMRI recording and cleans the Gradient Artifact (GA)
% using an AAS method (IAR for image artifact rejection in Allen, 2000). 
% This code is optimized for a NetStation Recorded Signal with 257
% channels, with 257 being the reference.
%
% Necessary inputs are:
% signal: S.signal
% pulse markers: S.MR_Pulses_orig
% sampling frequency: S.fs
% Output is S.signal
%
% Default parameters are (as in Allen 2000 paper):
%
% Number of epochs for template (i.e. # of slices)
% S.nEpochsTemplate = 100;
% Number of epochs for template to move
% S.sldwin_epochs = 100; i.e. no overlap
%
% Number of slices per volume;
% S.slicespervolume = 35;
% Length of TR in seconds (Volume acquisition length)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AAS gradiant artifact rejectionn as in Niazy 2000, neuroimage
% Coded by Alex Gonzalez
% Stanford Memory Lab
% Dec 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check for correct inputs

% check for signal
if ~isfield(S,'signal') || ~isfield(S,'MR_Pulses') || ~isfield(S,'SR')
    error('Incorrect input')
end

% Default Parameters
% number of slices in each template
if ~isfield(S,'NPulseEpochs'), S.nEpochsTemplate = 100; end 

if ~isfield(S,'ANC_nFilterCoeff'), S.ANC_nFilterCoeff = 15; end 

if ~isfield(S,'ANC_LPFcutoff'), S.ANC_LPFcutoff = 50; end 

if ~isfield(S,'ANC_nWeights'), S.ANC_nWeights = 100; end 
%
if ~isfield(S,'slicespervolume'), S.slicespervolume = 35; end

if ~isfield(S,'TR_length'), S.TR = 2; end

%% Variables from signal

% total number of points
S.nPoints = size(S.signal,2);

% make sure there is no pre-scan markers
diff_MR_mark = diff(S.MR_Pulses);
[~,MR_ind] = max(diff_MR_mark);

% actual scan time slice markers
if MR_ind >1
    S.MR_Pulses = S.MR_Pulses(MR_ind+1:end);
end

Pidx        = S.MR_Pulses;

% number of slices
S.Nslices = numel(Pidx);

% each epoch can have either 28 or 29 samples. use max to accomodate all.
S.nSliceSamps = ceil(S.SR/S.slicespervolume*S.TR_length);

% make sure the 
if Pidx(S.Nslices)+S.nSliceSamps > S.nPoints
    Pidx(S.Nslices) = [];
    S.Nslices       = S.Nslices-1;    
end

% binary signal indicating samples that where the pulse was triggered, i.e.
% the slice timing signal
pulseSignal = zeros(S.nPoints,1);
pulseSignal(Pidx)=1;

signal  = S.signal;


%% Template subtraction

% template matrix nChans x K x M;
A = zeros(S.nChan,S.nEpochsTemplate,S.nSliceSamps);

for s = 1:S.Nslices
    rowIdx      = mod(s,S.nEpochsTemplate)+1;
    sampIdx     = Pidx(s):Pidx(s)+S.nSliceSamps-1;
    A(:,rowIdx,:) = signal(:,sampIdx);        
    mA          = squeeze(mean(A,2));
    
    if s > S.nEpochsTemplate
        % subtract current template from current epoch
        signal(:,sampIdx) = signal(:,sampIdx)-mA;
    elseif s == S.nEpochsTemplate
        % if first time with full template, go back and subtract from each
        % previous template
        for k = 1:S.nEpochsTemplate
            sampIdx     = Pidx(k):Pidx(k)+S.nSliceSamps-1;
            signal(:,sampIdx)= signal(:,sampIdx)-mA;
        end
    end
end

%% filtering

filtCoeff   = fir1(S.ANC_nFilterCoeff,S.ANC_LPFcutoff/(S.SR/2),'low',hann(S.ANC_nFilterCoeff+1));
signal      = applyFilter(filtCoeff,signal);
pulseSignalF= applyFilter(filtCoeff,pulseSignal')';

%% ANC

for ch = 1:S.nChan
    x       = signal(ch,:)';
    
    Alpha   = sum(x.*pulseSignalF)/sum(pulseSignalF.*pulseSignalF);
    [signal(ch,:),~] = fastranc(pulseSignalF*Alpha,x,...
        S.ANC_nWeights,0.05/(S.ANC_nWeights*var(pulseSignalF*Alpha)));
end
S.signal        = signal;
S.pulseSignalF  = pulseSignalF;
return





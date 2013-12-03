function S = ST_PA_Clean_v3(S)
% The function STPRA_Clean takes an EEG recorded signal from a
% simultaneous EEG/fMRI recording and cleans the Pulse Related Artifact (PRA)
% using a spatio-tempotal SVD filter. This function creates a moving
% template of the artifact and then the  signal is reconstructed by nulling
% the principal components that are more correlated with the artifact.
% This code is optimized for a NetStation Recorded Signal with 257
% channels, with 257 being the reference. This functions is assuming the
% signal is cleaned of gradient artifact and filtered to desired
% prefrences.
%
% Reconstructed signal is converted to single 
%
% A version using a tensor template is in the works.
%
% Necessary inputs are:
% signal: S.signal
% pulse markers: S.pulse_markers
% sampling frequency: S.SR
% marker lag : S.marker_lag
% Output is S.signal
%
% Default parameters are:
% Number of epochs for template
% S.NPulseEpochs = 15;
% Number of epochs for template to move
% S.sldwin_epochs = 5;
% Marker lag of event:
% S.marker_lag = 200ms;
%
% If apriori knowledge of not good signal at the beggining or end: you can
% choose to ignore those events
% S.ignore_firstpulses = 5;
% S.ignore_lastpulses = 5;
%
% Threshold for rejection. If component is significantly different than
% noise it means that is highly correlated to the artifact. In that case
% reject. This is given by a P value.
% S.P_threshold = 0.1;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spatio-Temporal Pulse Artifact Rejection
% Version 4.0
% Created by Alex Gonzalez
% Stanford Memory Lab
% July 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Changes from v3
% updated structure setup

%% check for correct inputs

% check for signal
if ~isfield(S,'signal') || ~isfield(S,'pulse_markers') || ~isfield(S,'SR')
    error('Incorrect input')
end

% Default Parameters
if ~isfield(S,'NPulseEpochs'), S.NPulseEpochs = 15; end

if ~isfield(S,'sldwin_epochs'), S.sldwin_epochs = 5; end

if ~isfield(S,'ignore_firstpulses'), S.ignore_firstpulses = 5; end

if ~isfield(S,'ignore_lastpulses'), S.ignore_lastpulses = 5; end

if ~isfield(S,'marker_lag'), S.marker_lag = 0.2*S.fs; end

if ~isfield(S,'P_threshold'), S.P_threshold = 0.1; end

%% Variables from signal

% total number of points
S.nSamps = size(S.signal,2);
% total numbers of channels
S.nChan = size(S.signal,1);

% pulse marker
S.pulse_markers = single(S.pulse_markers(S.ignore_firstpulses+1: ...
    end-S.ignore_lastpulses)- S.marker_lag);


%% template markers

% number of pulses,
S.Npulse_markers = numel(S.pulse_markers);
% counter and flag for templates
cnt = 0;
not_finshed_flag = 1;

%create template matrix of markers
template_markers = [];
while not_finshed_flag
    
    % beginning of index template cnt
    begIndmark = cnt*S.sldwin_epochs+1;
    % ending of index template cnt
    endIndmark = cnt*S.sldwin_epochs+S.NPulseEpochs+1;
    
    % make sure your ending index is less than the number of pulses
    if endIndmark < S.Npulse_markers
        template_markers(cnt+1,:) = S.pulse_markers(begIndmark: endIndmark);
        % if not just take the last NPulseEpochs for your template
    else
        template_markers(cnt+1,:) = S.pulse_markers(end-S.NPulseEpochs:end);
        not_finshed_flag = 0;
    end
    
    % number of templates should be way less than this
    if cnt > 10000;
        error('Something is wrong with the template creation, too many templates!')
    end
    cnt = cnt+1;
end

% total number of templates
Ntemp = size(template_markers,1);

% max for each pulse to pulse in each template
pulse2pulse = single(diff(template_markers,1,2));
maxPulse2Pulse = max(pulse2pulse,[],2);
meanPulse2Pulse = floor(mean(pulse2pulse,2));

% create end point for each marker
real_template_markers_end = template_markers(:,2:end)-1;

%last column of template markers not needed anymore
template_markers(:,S.NPulseEpochs+1) =[];

% make sure the end temp_markers don't exceed the number of points
if ~isempty(find(real_template_markers_end>S.nSamps,1))
    real_template_markers_end(real_template_markers_end>S.nSamps)=S.nSamps;
end

%% using mean pulse 2 pulse

time_start =  tic;

template_matrix = cell(Ntemp,1);
recons_template_matrix = cell(Ntemp,1);
for temp = 1:Ntemp;
    %display(sprintf('Creating Template %i',temp))
    % each template is 2D matrix: (Nchan X MaxPulsePulse) XNEpochs
    % (spatial X time) X event
    %template_matrix{temp} = single(zeros(S.nChan*meanPulse2Pulse(temp),S.NPulseEpochs));
    template_matrix{temp} = single(zeros(S.nChan*maxPulse2Pulse(temp),S.NPulseEpochs));
    for ep = 1:S.NPulseEpochs
        % samples of interest
        pulse_samples = template_markers(temp,ep):real_template_markers_end(temp,ep);
        epoch_samples = template_markers(temp,ep):template_markers(temp,ep)+maxPulse2Pulse(temp)-1;
        for ch = 1:S.nChan
            start_samp = (ch-1)*numel(epoch_samples)+1;
            end_samp = start_samp + numel(pulse_samples)-1;
            template_matrix{temp}(start_samp:end_samp,ep) = S.signal(ch,pulse_samples);
        end
    end
    [s v d] = svd(template_matrix{temp},'econ');
    [~,P] = ttest(d);
    goodcomp = P>S.P_threshold;
    %S.badcomps(temp,:) = P<S.P_threshold;
    recons_template_matrix{temp} = s*(v.*diag(goodcomp))*d';
end

display(sprintf('Time to create templates %f seconds',toc(time_start)))

%% reconstruct signal
 
S.recons_signalpad = single(zeros(size(S.signal)));

% allocate ignored signal
S.recons_signalpad(:,1:S.pulse_markers_orig(S.ignore_firstpulses+1)-1 - 0.2*S.fs)= ...
    S.signal(:,1:S.pulse_markers_orig(S.ignore_firstpulses+1)-1 -0.2*S.fs);

S.recons_signalpad(:,S.pulse_markers_orig(end)-0.2*S.fs:end)= ...
    S.signal(:,S.pulse_markers_orig(end)-0.2*S.fs:end);

time_start = tic;
for ch = 1:S.nChan
    display(sprintf('Reconstructing channel %i',ch))
    % for every pulse
    %signal = [];
    for pl = 1:S.Npulse_markers-1
        % find the template and corresponding template epoch that the pulse
        % is repeated
        
        [temp, epochs] = find(template_markers==S.pulse_markers(pl));
        
        % initiate the storing variable x
        x = zeros(numel(epochs),pulse2pulse(temp(1),epochs(1)));
        
        % there might be no pulses that match, then you are done
        if ~isempty(temp)
            pulse_samples = template_markers(temp(1),epochs(1)): ...
                real_template_markers_end(temp(1),epochs(1));
            %for every repeated epoched
            for epnum = 1:numel(epochs)
                % what samples signal samples is this pulse in
                epoch_samples = template_markers(temp(epnum),epochs(epnum)): ...
                    template_markers(temp(epnum),epochs(epnum))+maxPulse2Pulse(temp(epnum))-1;
                
                % calculate starting location in template matrix
                start_samp = (ch-1)*numel(epoch_samples)+1;
                end_samp = start_samp + numel(pulse_samples)-1;
                
                x(epnum,:) = ...
                    recons_template_matrix{temp(epnum)}(start_samp:end_samp,epochs(epnum));
            end
            S.recons_signalpad(ch,pulse_samples) = mean(x,1);
        else
            continue
        end
    end
end

display(sprintf('Time to reconstruct signal %f seconds',toc(time_start)))

return





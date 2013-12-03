function S = ST_GA_Clean(S)
% The function ST_GA_Clean takes an EEG recorded signal from a
% simultaneous EEG/fMRI recording and cleans the Gradient Artifact (PRA)
% using a spatio-tempotal SVD filter. This function creates a moving
% template of the artifact and then the  signal is reconstructed by nulling
% the principal components that are more correlated with the artifact.
% This code is optimized for a NetStation Recorded Signal with 257
% channels, with 257 being the reference.
% Reconstructed signal is converted to single save space
%
% A version using a tensor template is in the works.
%
% Necessary inputs are:
% signal: S.signal
% pulse markers: S.MR_Pulses_orig
% sampling frequency: S.fs
% Output is S.signal
%
% Default parameters are:
%
% Number of epochs for template
% S.NPulseEpochs = 15;
% Number of epochs for template to move
% S.sldwin_epochs = 5;
% Number of slices per volume;
% S.slicespervolume = 35;
% Length of TR in seconds (Volume acquisition length)
% 
% Threshold for rejection. If component is significantly different than
% noise it means that is highly correlated to the artifact. In that case
% reject. This is given by a P value.
% S.P_threshold = 0.1;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spatio-Temporal Gradient Artifact Rejection
% Version 3.0
% Created by Alex Gonzalez
% Stanford Memory Lab
% July 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check for correct inputs

% check for signal
if ~isfield(S,'signal') || ~isfield(S,'MR_Pulses') || ~isfield(S,'SR')
    error('Incorrect input')
end

% Default Parameters
if ~isfield(S,'NPulseEpochs'), S.NPulseEpochs = 15; end

if ~isfield(S,'sldwin_epochs'), S.sldwin_epochs = 5; end

if ~isfield(S,'P_threshold'), S.P_threshold = 0.1; end

if ~isfield(S,'slicespervolume'), S.slicespervolume = 35; end

if ~isfield(S,'TR_length'), S.TR = 2; end


%% Variables from signal

% total number of points
S.Npoints = size(S.signal,2);
% total numbers of channels
S.Nchan = size(S.signal,1);

% % pulse marker
% S.pulse_markers = single(S.pulse_markers_orig(S.ignore_firstpulses+1: ...
%     end-S.ignore_lastpulses)- S.marker_lag);

% make sure there is no pre-scan markers
diff_MR_mark = diff(S.MR_Pulses);
[~,MR_ind] = max(diff_MR_mark);

% actual scan time slice markers
if MR_ind >1
    S.MR_Pulses = S.MR_Pulses(MR_ind+1:end);
end

%% template markers,
% this is how the signal is going to be broken down for filtering

% number of slices
S.Nslices = numel(S.MR_Pulses);

%number of TRs
S.nTRs = ceil(S.Nslices/S.slicespervolume);

% create a label for each slice in a TR
labels = repmat(1:S.slicespervolume,1,S.nTRs);

% truncate in case of incomplete volume acquisition
S.slice_labels = labels(1:S.Nslices);
% assume every slice has the same duration across different volumes
% this is a true assumption if acquisition software is synchronize to the
% scanner
S.slice_duration = diff(S.MR_Pulses(1:S.slicespervolume+1));

% template marker matrix indicates the start and end of a slice for all the
% templates in a acquistion. Each template contains # S.NpulseEpochs slices
% for creating a template. This is a spatio temporal template, so each
% template is going to be (#chan X duration of slices) X (#templates)
% each slice has its own template

%create template matrix of markers, one for each slice
template_markers = cell(S.slicespervolume,1);
% end marker
template_markers_end = cell(S.slicespervolume,1);
% markers for each slice
S.slice_pulses = cell(S.slicespervolume,1);

%S.GAClean_signal = single(zeros(size(S.signal)));

origSignal = S.signal;
% allocate ignored signal
% S.GAClean_signal(:,1:S.MR_Pulses(1)-1)= ...
%     S.signal(:,1:S.MR_Pulses(1)-1);
% 
% S.GAClean_signal(:,S.MR_Pulses(end):end)= ...
%     S.signal(:,S.MR_Pulses(end):end);

for sl = 1:S.slicespervolume
    %% maker calculation for slice sl
    display(sprintf('Creating Template for Slice %i',sl))
    % counter and flag for templates
    cnt = 0;
    not_finshed_flag = 1;
    % pulses for slice sl
    S.slice_pulses{sl} = S.MR_Pulses(S.slice_labels==sl);
    S.Nslice_markers(sl) = numel(S.slice_pulses{sl});
    % duration slice sl
    %dur = S.slice_duration(sl);
    
    while not_finshed_flag
        
        % beginning of index template cnt
        begIndmark = cnt*S.sldwin_epochs+1;
        % ending of index template cnt
        endIndmark = cnt*S.sldwin_epochs+S.NPulseEpochs+1;
        
        % make sure your ending index is less than the number of pulses
        if endIndmark < S.Nslice_markers(sl)
            template_markers{sl}(cnt+1,:) = S.slice_pulses{sl}(begIndmark: ...
                endIndmark);
            
            % if not just take the last NPulseEpochs for your template
        else
            template_markers{sl}(cnt+1,:) = S.slice_pulses{sl}(end- ...
                S.NPulseEpochs:end);
            not_finshed_flag = 0;
        end
        
        % number of templates should be way less than this
        if cnt > 100000;
            error('Somthing is wrong with the template creation, too many templates!')
        end
        cnt = cnt+1;
    end
    
    % total number of templates
    S.Ntemp(sl) = size(template_markers{sl},1);
    
    % create end point for each marker
    template_markers_end{sl} = template_markers{sl}(:,2:end)-1;
    
    %last column of template markers not needed anymore
    template_markers{sl}(:,S.NPulseEpochs+1) =[];
    
    % make sure the end temp_markers don't exceed the number of points
    if ~isempty(find(template_markers_end{sl}>S.Npoints,1))
        template_markers_end{sl}(template_markers_end{sl}>S.Npoints)=S.Npoints;
    end
    
    %% create template data matrix
    
    % make tensor or big matrix
    S.tensor = 0; % to do make tensor High order SVD
    
    time_start =  tic;
    if S.tensor
        display('Tensor Analysis hasn''t been coded');
        return
    else
        template_matrix = cell(S.Ntemp(sl),1);
        recons_template_matrix = cell(S.Ntemp(sl),1);
        for temp = 1:S.Ntemp(sl)
            %display(sprintf('Creating Template %i',temp))
            % each template is 2D matrix: (Nchan X MaxPulsePulse) XNEpochs
            % (spatial X time) X event
            template_matrix{temp} = single(zeros(S.Nchan*S.slice_duration(sl), ...
                S.NPulseEpochs));
            for ep = 1:S.NPulseEpochs
                % samples of interest
                epoch_samples = template_markers{sl}(temp,ep):template_markers{sl}(temp,ep) ...
                    +S.slice_duration(sl)-1;
                
                for ch = 1:S.Nchan
                    start_samp = (ch-1)*numel(epoch_samples)+1;
                    end_samp = start_samp + numel(epoch_samples)-1;
                    %template_matrix{temp}(start_samp:end_samp,ep) =  ...
                    %    S.signal(ch,epoch_samples);
                    template_matrix{temp}(start_samp:end_samp,ep) =  ...
                        origSignal(ch,epoch_samples);
                end
            end
            [s v d] = svd(template_matrix{temp},'econ');
            [~,P] = ttest(d);
            goodcomp = P>S.P_threshold;
            %S.badcomps(temp,:) = P<S.P_threshold;
            recons_template_matrix{temp} = s*(v.*diag(goodcomp))*d';
        end
    end
    display(sprintf('Time to create slice template %f seconds',toc(time_start)))
    
    %% reconstruct signal
    time_start = tic;
    for ch = 1:S.Nchan
        %     display(sprintf('Reconstructing channel %i',ch))
        
        % for every TR 
        for tr = 1:size(S.slice_pulses{sl},2)
            % find the template and corresponding template epoch that slice pulse
            %is repeated
            
            [temp, epochs] = find(template_markers{sl}==S.slice_pulses{sl}(tr));
            
            % initiate the storing variable x
            x = zeros(numel(epochs),S.slice_duration(sl));
            
            % there might be no pulses that match, then you are done
            if ~isempty(temp)
                
                %for every repeated epoched
                for epnum = 1:numel(epochs)
                    % what samples signal samples is this pulse in
                    epoch_samples = template_markers{sl}(temp(epnum),epochs(epnum)): ...
                        template_markers{sl}(temp(epnum),epochs(epnum)) + S.slice_duration(sl)-1;
                    
                    % calculate starting index in template matrix
                    start_samp = (ch-1)*numel(epoch_samples)+1;
                    % calculate end index in template matrix
                    end_samp = start_samp+S.slice_duration(sl)-1;
                    
                    x(epnum,:) = recons_template_matrix{temp(epnum)}(start_samp:end_samp,epochs(epnum));
                end
                
                % assign slice to original signal
                %S.GAClean_signal(ch,epoch_samples) = mean(x,1);
                S.signal(ch,epoch_samples) = mean(x,1);
            else
                continue
            end
        end
    end
    
    display(sprintf('Time to reconstruct slice %i %f seconds',sl,toc(time_start)))
end
return





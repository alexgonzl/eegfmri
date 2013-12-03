% timeseries adaptive zscoring, for non-stationary signals
function [out,win_mean,win_var] = ts_adaptivezscore(varargin)
% in:       input signal
% wl:       (samples) window length in samples
% sld_wl:   (samples) slding window length in samples

% Alex Gonzalez
% 

x = varargin{1};
nsamps = numel(x); 

% defaults
if nargin < 2
    wl = 500;
    sld_wl = 0; 
else
    wl = varargin{2};
    sld_wl = varargin{3};
end

% determine the sample index in windows
win_edges = 0:wl-sld_wl:nsamps+wl-sld_wl;
nwindows  = numel(win_edges)-1;
[~,samp_win_idx]= histc((1:nsamps)-.01,win_edges);
    
% linear detrending of mean
x = detrend(x,'linear');

% calculate variance in window, and divide the signal by it
win_var = zeros(nwindows,1);
win_mean = zeros(nwindows,1);
for w = 1:nwindows
    idx = samp_win_idx==w;
    win_mean(w) = mean(x);
    x(idx) = x(idx) - win_mean(w);
    win_var(w) = std(x(idx));
    x(idx) = x(idx)/win_var(w);
end

out = x;

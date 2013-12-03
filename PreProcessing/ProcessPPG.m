
% Physio Data Load & Processing
T = 0.01;                   % (s) sampling period 
pre_trig = 30;              % (s) number of seconds before scanner trigger
pre_trig_samp = pre_trig/T; % (samps) number of samples before scanner trigger


% load raw PPG time course
datafile = '/Users/alexgonzalez/Documents/EEG_fMRI/RawData/s27/physio/PPGDataR1';
z = load(datafile);

nsamps = numel(x);                          % (samps) total number of samples
post_trig_samp = nsamps - pre_trig_samp;    % (samps) number of samples post trigger
post_trig = post_trig_samp*T;               % (s) 

timepoints = linspace(-pre_trig,post_trig,nsamps); % (s) run time points

x = ts_vardetrend(z,500,0);

figure(1); clf;
[~,j]=findpeaks(x,'MINPEAKHEIGHT',1,'minpeakdistance',10);
plot(timepoints,x); hold on
plot(timepoints(j),x(j),'*r'); hold off
axis tight

i = j>pre_trig_samp;
trig_idx = j(i);
trig_amp = x(j(i));

%%

% env_x = abs(hilbert(x));
% y=[0;diff(x)];
% env_y = abs(hilbert(y));
% 
% figure(1); clf;
% plot([x';env_x' ; y'; env_y']');
% legend('raw','env raw', 'd/dt raw', 'env d/dt raw','location','best')
% 
% figure(2); clf;
% subplot(2,2,1);
% [~,j]=findpeaks(x,'MINPEAKHEIGHT',1,'minpeakdistance',10);
% plot(timepoints,x); hold on
% plot(timepoints(rawpk),x(rawpk),'*g');
% plot(timepoints(j),x(j),'*r'); hold off
% axis tight
% 
% subplot(2,2,2);
% [~,j]=findpeaks(env_x,'MINPEAKHEIGHT',1,'minpeakdistance',10);
% plot(timepoints,env_x); hold on
% plot(timepoints(rawpk),env_x(rawpk),'*g');
% plot(timepoints(j),env_x(j),'*r'); hold off
% axis tight
% 
% subplot(2,2,3);
% [~,j]=findpeaks(y,'MINPEAKHEIGHT',1,'minpeakdistance',10);
% plot(timepoints,y); hold on
% plot(timepoints(rawpk),y(rawpk),'*g');
% plot(timepoints(j),y(j),'*r'); hold off
% axis tight
% 
% subplot(2,2,4);
% [~,j]=findpeaks(env_y,'MINPEAKHEIGHT',1,'minpeakdistance',20);
% plot(timepoints,env_y); hold on
% plot(timepoints(rawpk),env_y(rawpk),'*g');
% plot(timepoints(j),env_y(j),'*r'); hold off
% axis tight



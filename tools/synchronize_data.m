function err = synchronize_data(tsh)
% returns the error between two time series as a function of time shift
% tsh : time shift in seconds

close all

% load the test data set
%load HammerTestData

%  nidata = raw pot measurement in volts from the NI board
%  vndata = raw angle data from the VectorNav
%  nisteer = normalized ni data
%  vnsteer = normalized vectornav data

load('../otherdata/test1.mat')
nisteer = nidata(:, 5)*76;
vnsteer = -vndata(:, 8);

% get the size of each data set
[mvn,nvn]=size(vnsteer);
[mni,nni]=size(nisteer);

% create time array
n = 1:1:mni; % samples in nisteer
dt = 0.01; % sample time
tt = dt*n; % time vector, tt[0] = 0.01

% grab data only around the step (both data sets), discard rest
ni = nisteer(5400:5600)-mean(nisteer(5400:5600));
%(5400:5600)
vn = vnsteer(5400:5600)-mean(vnsteer(5400:5600));
t = tt(5400:5600);

% plot the two data sets
figure(1)
subplot(2, 1, 1)
plot(t, ni, '.', t, vn, '.'); legend('ni','vn')

nivn=[ni vn];

% since ni data is cleaner use it to shift and interpolate
tni = t+tsh; % shift time for ni
tvn = t; % don't shift the time for vn

% plot the shifted data
subplot(2, 1, 2)
plot(tni, ni, '.', tvn, vn, '.');

% create time vector from the start of vn to the end of ni
t_int = tvn(find(tvn<tni(end)));

% interpolate between ni samples to find points that correspond in time to vn
ni_int = interp1(tni, ni, t_int);

% truncate vn before and after times that ni is interpolated to
tvn_int = tvn(find(tvn<=t_int(end)));
vn_trunc = vn(find(tvn<=t_int(end)))';

% plot the interpolated and truncated data
hold on
plot(t_int, ni_int,'r.', t_int, vn_trunc, 'k.')
legend('ni','vn','ni int', 'vn trunc')

% calculate the error
err = norm(ni_int-vn_trunc);

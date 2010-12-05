function examine_bumps(file, shift)
% plots the redundant rate and acceleration values from a run
% file : path to the file with the bump data
% shift : number of samples to shift the NI data back

close all; clc

load(file)

% plot the pitch gyro signals
vnpitch = -vndata(:, 12);
vnpitch = vnpitch - vnpitch(end);
vnpitch = rad2deg(vnpitch); % put it in deg/sec
nipitch = nidata(:, 2);

m = 200/2.5; % deg/sec to voltage ratio
b = -200; % 2.5 volts equals 0 deg/sec
nipitch = m.*nipitch + b;
nipitch = nipitch - nipitch(end);

plot(1:length(vnpitch), vnpitch, ...
     1:length(nipitch)-shift, nipitch(1+shift:end))
legend({'VN Pitch Rate' 'NI Pitch Rate'})
xlabel('Sample Number')
ylabel('Rate [deg/sec]')

% plot the accelerations
vna = vndata(:, 7:9);
nia = nidata(:, 4:6);

%m = 3/0.8;
%b = -3;
%nia = (m.*nia + b).*9.8;

% set the nominal value to zero for each accel
for i = 1:length(nia(end, :))
    vna(:, i) = vna(:, i) - vna(1, i);
    nia(:, i) = nia(:, i) - nia(1, i);
end
nia = nia.*76; % a guess of the scaling factor

% plot the accelerations
figure(2)
l = {'X' 'Y' 'Z'};
switchrows = [3 2 1]; % VNav X = NI Z, VNav Z = VNav X
neg = [-1 -1 1]; % flip the signs of the accels
title('Zero shifted Acceleration Signals')
for i = 1:3
    subplot(3, 1, i)
    plot(1:length(vna), neg(i).*vna(:, switchrows(i)), ...
         1:length(nia)-shift, nia(1+shift:end, i))
    legend({['VN' l{i}] ['NI' l{i}]})
    ylim([-20 20])
end

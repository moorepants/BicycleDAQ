function examine_bumps(file, shift)
% file : path to the file with the bump data
% shift : number of samples to shift the NI data back

close all; clc

load(file)

% plot the pitch gyro signals
vnpitch = -vndata(:, 12);
vnpitch = vnpitch - vnpitch(end);
nipitch = nidata(:, 2);

m = 200/2.5;
b = -200;
nipitch = deg2rad(m.*nipitch + b);
nipitch = nipitch - nipitch(end);

plot(1:length(vnpitch), vnpitch, ...
     1:length(nipitch)-shift, nipitch(1+shift:end))
legend({'VN Pitch Rate' 'NI Pitch Rate'})

% plot the accelerations
vnay = -vndata(:, 8);
vnay = vnay - vnay(end);
niay = nidata(:, 5);

m = 3/0.8;
b = -3;
niay = (m.*niay + b)*9.8;
niay = niay - niay(end);
%niax = niax*76;

figure(2)
plot(1:length(vnay), vnay, ...
     1:length(niay)-shift, niay(1+shift:end))
legend({'VN ax' 'NI ax'})

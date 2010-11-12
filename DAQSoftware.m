% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
% clear up everything else
close all; clear all; clc;

% load the VectorNav library
addpath('VectorNavLib')
% serial object for the VectorNav
s = VNserial('COM3');

% connect to the daq box
ai = analoginput('nidaq','Dev1');
ao = analogoutput('nidaq','Dev1');
duration = 6000; % seconds
set(ai,'SampleRate',100)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'TriggerType','Manual');
set(ai,'InputType','SingleEnded');
chan = addchannel(ai,[0 1 2 3 4]);
ochan = addchannel(ao,0);
five = [10 10]';
putdata(ao,five)
start(ao)

start(ai)
trigger(ai)

data = zeros(50,5);

% make the figure
figure(1)
lines = plot(data); % plot the raw data
%ylim([2.4 2.6])
ylabel('Voltage')
leg = legend('Steer Angle', 'Steer Rate', 'Steer Torque', 'Wheel Speed', 'Button');
labels = {'', '', '', '', ''};

% update the plot while the data is being taken
while (1)
    % return the latest 50 samples
    data = peekdata(ai,100);
    for i = 1:5
        set(lines(i), 'YData', data(:, i))
    end
    meanData = mean(data);
    labels{1} = sprintf('Steer Angle = %1.2f V', meanData(1));
    labels{2} = sprintf('Steer Rate = %1.2f V', meanData(2));
    labels{3} = sprintf('Steer Torque = %1.2f V', meanData(3));
    labels{4} = sprintf('Wheel Speed = %1.2f V', meanData(4));
    labels{5} = sprintf('Button = %1.2f V', meanData(5));
    set(leg, 'String', labels)
    figure(1)
end
stop(ao)
delete(ai, ao)
clear ai ao chan ochan

% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
% clear up everything else
close all; clear all; clc;

% connect to the daq box
ai = analoginput('nidaq','Dev1');
ao = analogoutput('nidaq','Dev1');
duration = 6000; % seconds
set(ai,'SampleRate',100)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'TriggerType','Manual');
set(ai,'InputType','SingleEnded');
channels = [1 10];
chan = addchannel(ai, channels);
get(ai)
ochan = addchannel(ao,0);

five = [10 10]';
putdata(ao,five)
start(ao)

start(ai)
trigger(ai)

numsamps = 100;

data = zeros(numsamps, length(channels));

% make the figure
figure(1)
lines = plot(data); % plot the raw data
ylim([0 5])
ylabel('Voltage')
labels = {''};
for i = 2:length(channels)
    labels{i} = '';
end
leg = legend(labels);

% update the plot while the data is being taken
while (1)
    % return the latest samples
    data = peekdata(ai, numsamps);
    for i = 1:length(channels)
        set(lines(i), 'YData', data(:, i))
        meanData = mean(data(:, i));
        labels{i} = sprintf('Channel %s = %1.2f V', ...
                            num2str(channels(i)), ...
                            meanData);
    end
    set(leg, 'String', labels)
    figure(1)
end
stop(ao)
delete(ai, ao)
clear ai ao chan ochan

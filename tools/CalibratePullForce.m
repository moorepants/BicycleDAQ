% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
% clear up everything else
close all; clear all; clc;

% connect to the daq box
ai = analoginput('nidaq','Dev1');
duration = 5; % seconds
set(ai,'SampleRate',200)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'InputType','SingleEnded');
chan = addchannel(ai, [21]);

% how many trials will you do?
numTrials = str2num(input('How many trials?\n', 's'));
% initialize pull force and voltage vectors
p = zeros(numTrials, 1);
v = zeros(numTrials, 1);

for i = 1:length(p)
    % ask the user to enter the number of pounds added
    weightadded = str2num(input('How many pounds have you added?\n', 's'));
    if i == 1
        p(i) = weightadded;
    else
        p(i) = p(i-1)+weightadded;
    end

    start(ai)
    wait(ai, duration+1)
    data = getdata(ai);
    v(i) = mean(data);
    stop(ai)
end

coef = polyfit(v, p, 1)

plot(v, p, '.', v, coef(1).*v+coef(2))

delete(ai)
clear ai chan
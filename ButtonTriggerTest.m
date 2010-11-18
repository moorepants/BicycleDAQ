% testing external triggering

% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

duration = 5; % the sample time in seconds
samplerate = 200; % sample rate in hz
numsamples = duration*samplerate;

% connect to the NI USB-6218
ai = analoginput('nidaq','Dev1');

% add channels and lines
chan = addchannel(ai, [0 17]); % button is in AI17

% configure the DAQ
set(ai,'InputType','SingleEnded')
set(ai,'SampleRate',samplerate)
set(ai,'SamplesPerTrigger',duration*get(ai,'SampleRate'))
set(ai,'TriggerType','Software')
set(ai,'TriggerChannel',chan(2))
set(ai,'TriggerConditionValue',4.9) % trigger if button goes above 4.9 volts

% start up the DAQ
start(ai)
wait(ai, 5*duration)
[nidata, time, abstime, events] = getdata(ai);

stop(ai)
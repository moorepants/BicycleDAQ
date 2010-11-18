 function [nidata, time, abstime, events] = ButtonTriggerTest
% testing external triggering and trigger callback functions

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
chan = addchannel(ai, [0 17]); % pot is in AI0 and button is in AI17

% configure the DAQ
set(ai,'InputType','SingleEnded')
set(ai,'SampleRate',samplerate)
set(ai,'SamplesPerTrigger',duration*get(ai,'SampleRate'))

% configure the trigger
set(ai,'TriggerType','Software')
set(ai,'TriggerChannel',chan(2))
set(ai,'TriggerConditionValue',4.9) % trigger if button goes above 4.9 volts
set(ai,'TriggerFcn',@TriggerCallback)

% start up the DAQ
start(ai)
display('DAQ has started')
wait(ai, 5*duration) % wait so that getdata doesn't try to get too early
[nidata, time, abstime, events] = getdata(ai);
stop(ai)

function TriggerCallback(obj, event)
    display('trigger ran')
% testing external triggering

% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

duration = 20; % the sample time in seconds
samplerate = 100; % sample rate in hz
numsamples = duration*samplerate;

% connect to the NI USB-6218
ai=analoginput('nidaq','Dev1');

% configure the DAQ
set(ai,'SampleRate',samplerate)
ActualRate = get(ai,'SampleRate')
set(ai,'SamplesPerTrigger',duration*ActualRate)
set(ai,'TriggerType','HwDigital')
set(ai,'HwDigitalTriggerSource','PFI0')
set(ai,'TriggerCondition','PositiveEdge')
set(ai,'InputType','SingleEnded')
chan = addchannel(ai,[0]);
get(ai)
% start up the DAQ
start(ai)
display('DAQ started')
daqdata = getdata(ai);
%daqdata = peekdata(ai, numsamples)

events = ai.EventLog

stop(ai)
delete(ai)
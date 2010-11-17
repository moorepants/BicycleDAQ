% gilbert's test code to see if the NI Daq card and the vectornav play well
% together

% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

duration = 10; % the sample time in seconds
samplerate = 100; % sample rate in hz
numsamples = duration*samplerate;

% connect to the VectorNav
s = VNserial('COM3')

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
%trigger(ai)

tic
vndata = VNrecordADOR(s, 'YPR', samplerate, duration);
toc

tic
daqdata = getdata(ai);
%daqdata = peekdata(ai, numsamples)
toc

events = ai.EventLog

stop(ai)
delete(ai)

% plot the angles together
plot(1:numsamples,-(vndata(:,1)-vndata(1,1)),1:numsamples,21*(daqdata-daqdata(1)))
legend('vndata', 'daqdata')
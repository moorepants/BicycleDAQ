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

samplerate = 100; % sample rate in hz
duration = 5; % the sample time in seconds
numsamples = duration*samplerate;

% connect to the NI USB-6218
ai=analoginput('nidaq','Dev1');

% configure the DAQ
set(ai,'SampleRate',samplerate)
ActualRate = get(ai,'SampleRate')
set(ai,'SamplesPerTrigger',duration*ActualRate)
% set(ai,'TriggerType','HwDigital')
set(ai,'TriggerType','Manual')
% set(ai,'HwDigitalTriggerSource','PFI0')
% set(ai,'TriggerCondition','PositiveEdge')
set(ai,'TriggerDelay',0)
set(ai,'InputType','SingleEnded')
chan = addchannel(ai,[0]);
get(ai)

% connect to the VectorNav
s = VNserial('COM3')
%Set the data output rate
VNwriteregister(s, 7, samplerate);
% write to the 'YPR' register
VNwriteregister(s, 6, 1);
% initialize the data
vndata = zeros(samplerate*duration, 3);
%Create parse string
ps = '%*6c';
for i=1:size(vndata,2)
    ps = [ps ',%g'];
end
a = 1:duration
b = 1:samplerate

% start up the DAQ
start(ai)
display('DAQ started')
trigger(ai)

%Record data
%fprintf('Data recording started.\n');
for i=a
    for j=b
        tic
        vndata((i-1)*samplerate+j, :) = fscanf(s, ps);
        toc
    end
    
    %fprintf('%i  seconds remaining...\n', numSec-i);
end
display('VN data done')
%Turn off ADOR
VNprintf(s, 'VNWRG,6,0');
pause(0.1);
VNclearbuffer(s);

% tic
% vndata = VNrecordADOR(s, 'YPR', samplerate, duration);
% toc

daqdata = getdata(ai);
%daqdata = peekdata(ai, numsamples)

events = ai.EventLog

stop(ai)
delete(ai)

% plot the angles together
plot(1:numsamples,-(vndata(:,1)-vndata(1,1)),1:numsamples,21*(daqdata-daqdata(1)))
legend('vndata', 'daqdata')
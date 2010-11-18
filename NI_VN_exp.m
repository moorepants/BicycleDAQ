function NI_VN_exp
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

% connect to the VectorNav
s = VNserial('COM3');
% set the data output rate
VNwriteregister(s, 7, samplerate);
% set the output type: 'YPR'
%VNwriteregister(s, 6, 1);
% initialize the data
%vndata = zeros(samplerate*duration, 3);
VNwriteregister(s, 6, 14);
vndata = zeros(samplerate*duration, 12);
vntextdata = cell(samplerate*duration, 1);
%Create parse string
ps = '%*6c';
for i=1:size(vndata, 2)
    ps = [ps ',%g'];
end

% connect to the NI USB-6218
ai=analoginput('nidaq','Dev1');

% configure the DAQ
set(ai,'InputType','SingleEnded')
set(ai,'SampleRate',samplerate)
set(ai,'SamplesPerTrigger',duration*get(ai,'SampleRate'))
set(ai,'TriggerType','Software')
set(ai,'TriggerDelay',0.0)
set(ai,'TriggerFcn',{@TriggerCallback,duration,samplerate,numsamples,vndata})
chan = addchannel(ai,[0 17]);


vntime = zeros(numsamples,1);

% start up the DAQ
start(ai)
display('DAQ started')
trig = 0;


toc
display('VN data done')
%Turn off ADOR
VNprintf(s, 'VNWRG,6,0');
pause(0.1);
VNclearbuffer(s);

% vndata = VNrecordADOR(s, 'YPR', samplerate, duration);

daqdata = getdata(ai);
%daqdata = peekdata(ai, numsamples)

stop(ai)
delete(ai)

% plot versus sample
figure(1)
plot(1:numsamples,-(vndata(:,1)-vndata(1,1)),1:numsamples,21*(daqdata-daqdata(1)))
figure(2)
% plot versus time
plot(vntime(:),-(vndata(:,1)-vndata(1,1)),0:1/samplerate:duration-1/samplerate,21*(daqdata-daqdata(1)))
legend('vndata', 'daqdata')
figure(3)
plot(vntime)

function TriggerCallback(obj, event, duration, samplerate, numsamples, data)
% record data
for i=1:duration
    for j=1:samplerate
        data((i-1)*samplerate+j, :) = fscanf(s, ps);
    end
end
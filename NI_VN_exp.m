function [nidata, vndata, time, abstime, events, ai, s] = NI_VN_exp
% test code to see if the NI Daq card and the vectornav play well
% together

% you have to delete the ai object before reconnecting
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

% daq parameters
samplerate = 100; % sample rate in hz
duration = 5; % the sample time in seconds
numsamples = duration*samplerate;

% connect to the NI USB-6218
ai=analoginput('nidaq', 'Dev1');

% add channels and lines
chan = addchannel(ai, [0 17]); % pot is in AI0 and button is in AI17

% configure the DAQ
set(ai, 'InputType', 'SingleEnded')
set(ai, 'SampleRate', samplerate)
actualrate = get(ai,'SampleRate')
set(ai, 'SamplesPerTrigger', duration*get(ai,'SampleRate'))

% trigger details
set(ai, 'TriggerType', 'Software')
set(ai, 'TriggerChannel', chan(2))
set(ai, 'TriggerConditionValue', 4.9) % trigger if button goes above 4.9 v
set(ai, 'TriggerDelay', 0.00)

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')
% connect to the VectorNav
s = VNserial('COM3');
% set the data output rate
VNwriteregister(s, 7, samplerate);
% initialize the VectorNav data
vndata = zeros(samplerate*duration, 3);
vndatatext = cell(samplerate*duration, 1);
%Create parse string
ps = '%*6c';
for i=1:size(vndata, 2)
    ps = [ps ',%g'];
end

set(ai,'TriggerFcn',{@TriggerCallback,s,ps,duration,samplerate,numsamples,vndata,vndatatext})

% start up the DAQ
start(ai)
display('DAQ started')
wait(ai, 60)

[nidata, time, abstime, events] = getdata(ai);
%daqdata = peekdata(ai, numsamples)
vndatatext = ai.UserData;
stop(ai)
% delete(ai)

% process the text data
for i=1:numsamples
    try
        vndata(i, :) = sscanf(vndatatext{i}, ps);
    catch
        vndata(i) = NaN;
        display(sprintf('A bad one: %s', vndatatext{i}))
    end
end

% set zero angle to zero, normalize the data
vnsteer = -(vndata(:, 1)-vndata(1, 1));
vnsteer = vnsteer./max(abs(vnsteer));
nisteer =  (nidata(:, 1)-nidata(1, 1));
nisteer = nisteer./max(abs(nisteer));

% plot versus sample
figure(1)
plot(1:numsamples,vnsteer,1:numsamples,nisteer)
legend('VectoNav Data', 'NI Data')

function TriggerCallback(obj, event, s, ps, duration, samplerate, numsamples, vndata, vndatatext)
display('Trigger called')
% record data
% set the output type: 'YPR'
VNwriteregister(s, 6, 1);
for i=1:duration
    for j=1:samplerate
        vndatatext{(i-1)*samplerate+j} = fgets(s);
%         vndata((i-1)*samplerate+j, :) = fscanf(s, ps);
    end
    display('a sec')
end
obj.UserData = vndatatext;
display('VN data done')
%Turn off ADOR
VNprintf(s, 'VNWRG,6,0');
pause(0.1);
VNclearbuffer(s);
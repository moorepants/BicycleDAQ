function [nidata, vndata, nisteer, vnsteer, time, abstime, events, ai, s] = NI_VN_exp
% test code to see if the NI Daq card and the vectornav play well
% together

% you have to delete the ai object before reconnecting
if exist('ai')
    exist 'ai'
    delete(ai)
end

clc
close all;
clear all;

duration = 5; % the sample time in seconds

% daq parameters
nisamplerate = 200; % sample rate in hz
ninumsamples = duration*nisamplerate;

% connect to the NI USB-6218
ai = analoginput('nidaq', 'Dev1');

% add channels and lines
% 0: steer angle pot
% 17: button
chan = addchannel(ai, [0 17]);

% configure the DAQ
set(ai, 'InputType', 'SingleEnded')
set(ai, 'SampleRate', nisamplerate)
actualrate = get(ai,'SampleRate')
set(ai, 'SamplesPerTrigger', duration*get(ai,'SampleRate'))

% trigger details
set(ai, 'TriggerType', 'Software')
set(ai, 'TriggerChannel', chan(2))
set(ai, 'TriggerCondition', 'Falling')
set(ai, 'TriggerConditionValue', 0.5)
set(ai, 'TriggerDelay', 0.00)

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

% vectornav parameters
vnsamplerate = 200;
vnnumsamples = duration*vnsamplerate;     

baudrate = 460800;
s = VNserial('COM3', baudrate);

% set the data output rate
VNwriteregister(s, 7, vnsamplerate);

% set the output type
VNwriteregister(s, 6, 14); % 'YMR'

% save the settings to VectorNav memory
%VNprintf(s, 'VNWNV');

% initialize the VectorNav data
vndata = zeros(vnsamplerate*duration, 12); % YMR
vndatatext = cell(vnsamplerate*duration, 1);

set(ai,'TriggerFcn',{@TriggerCallback, s, duration, vnsamplerate, vndatatext})

% start up the DAQ
start(ai)
display('DAQ started')
wait(ai, 60) % give the person some time to hit the button

[nidata, time, abstime, events] = getdata(ai);
%daqdata = peekdata(ai, numsamples)
vndatatext = ai.UserData;
stop(ai)

%Create parse string
ps = '%*6c';
for i=1:size(vndata, 2)
    ps = [ps ',%g'];
end
% process the text data
for i=1:vnnumsamples
    try
        vndata(i, :) = sscanf(vndatatext{i}, ps);
    catch
        vndata(i) = NaN;
        display(sprintf('A bad one: %s', vndatatext{i}))
    end
end

% set zero angle to zero, normalize the data
vnsteer = -(vndata(:, 1)-vndata(4, 1));
vnsteer = vnsteer./max(abs(vnsteer));
nisteer =  (nidata(:, 1)-nidata(4, 1));
nisteer = nisteer./max(abs(nisteer));

% plot versus sample
figure(1)
plot(1:vnnumsamples,vnsteer,1:ninumsamples,nisteer)
legend('VectoNav Data', 'NI Data')

function TriggerCallback(obj, events, s, duration, samplerate, vndatatext)
display('Trigger called')
% record data
for i=1:duration
    for j=1:samplerate
        vndatatext{(i-1)*samplerate+j} = fgets(s);
    end
    display('a sec')
end
obj.UserData = vndatatext;
display('VN data done')
%Turn off ADOR
VNprintf(s, 'VNWRG,6,0');
pause(0.1);
VNclearbuffer(s);
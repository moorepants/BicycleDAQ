function [nidata, vndata, nisteer, vnsteer, time, abstime, events, ai, s] = NI_VN_exp
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
samplerate = 200; % sample rate in hz
duration = 5; % the sample time in seconds
numsamples = duration*samplerate;

% connect to the NI USB-6218
ai=analoginput('nidaq', 'Dev1');

% add channels and lines
chan = addchannel(ai, [0 17 18 19 20]); % pot is in AI0 and button is in AI17

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
s = VNserial('COM3',460800);
% set the data output rate
VNwriteregister(s, 7, samplerate);
% set the output type
VNwriteregister(s, 6, 14); % 'YMR'
% initialize the VectorNav data
vndata = zeros(samplerate*duration, 12); % YMR
vndatatext = cell(samplerate*duration, 1);


set(ai,'TriggerFcn',{@TriggerCallback, s, duration, samplerate, vndatatext})

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
for i=1:numsamples
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
plot(1:numsamples,vnsteer,1:numsamples,nisteer)
legend('VectoNav Data', 'NI Data')

% plot the acceleration comparisons
vnaccel = vndata(:, 7) - vndata(4, 1);
vnaccel = vnaccel./max(abs(vnaccel));
niaccel = nidata(:, 3) - nidata(4, 1);
niaccel = niaccel./max(abs(niaccel));

figure(2)
plot(1:numsamples,vnaccel,1:numsamples,niaccel)
legend('VectoNav Data', 'NI Data')

function TriggerCallback(obj, events, s, duration, samplerate, vndatatext)
display('Trigger called')
s.ReadAsyncMode = 'manual';
flushinput(s);
serialbreak(s, 250);
s.ReadAsyncMode = 'continuous';
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
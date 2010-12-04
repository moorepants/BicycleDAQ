function [nidata, vndata, time, abstime, events] = NI_VN_exp
% test code to see if the NI Daq card and the vectornav play well
% together



% you have to delete the ai object before reconnecting
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

duration = 60; % the sample time in seconds

% daq parameters
nisamplerate = 200; % sample rate in hz
ninumsamples = duration*nisamplerate;

% connect to the NI USB-6218
ai = analoginput('nidaq', 'Dev1');

% add channels and lines
% 0: steer angle pot
% 4: rate gyro (attached to the VNav box)
% 17: VNav reset button
% 18, 19, 20: accelerometer (x, y ,z)

chan = addchannel(ai, [0 4 17 18 19 20]);

% configure the DAQ
set(ai, 'InputType', 'SingleEnded')
set(ai, 'SampleRate', nisamplerate)
actualrate = get(ai,'SampleRate')
set(ai, 'SamplesPerTrigger', duration*get(ai,'SampleRate'))

% trigger details
set(ai, 'TriggerType', 'Software')
set(ai, 'TriggerChannel', chan(3))
set(ai, 'TriggerCondition', 'Rising')
set(ai, 'TriggerConditionValue', 2.7)
set(ai, 'TriggerDelay', 0.00)

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

% vectornav parameters
vnsamplerate = 200;
vnnumsamples = duration*vnsamplerate;     

comPort = 'COM3';

%Check to see if COM port is already open, if so then close COM port.
display('-------------------------------------------------')
ports = instrfind;
if length(ports) == 0
        display('No ports exist')
end
for i=1:length(ports)
    if strcmp(ports(i).Port, comPort) == 1
        fclose(ports(i));
        delete(ports(i));
        display(['Closed and deleted ' comPort])
    else
        display([comPort ' was not open'])
    end
end

% create the serial port
s = serial(comPort);
display('-------------------------------------------------')
display('Serial port created, here are the initial properties:')
get(s)

% open the serial port
fopen(s);
display('-------------------------------------------------')
display('Serial port is open')

p = 0.1;

% Turn the async off on the VectorNav
command = 'VNWRG,06,0';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
flushinput(s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', s.BytesAvailable))

% set the baudrate on the VNav and the laptop
baudrate = 460800;
command = ['VNWRG,05,' num2str(baudrate)];
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
s.BaudRate = baudrate; % set the laptop baud rate to match
display('-------------------------------------------------')
display('VNav baud rate is now set to:')
display(sprintf(response))
display(sprintf('%d bytes in input buffer after setting the baud rate', s.BytesAvailable))

% set the samplerate
command = ['VNWRG,07,' num2str(vnsamplerate)];
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display('-------------------------------------------------')
display('VNav sample rate is now set to:')
display(sprintf(response))
display(sprintf('%d bytes in input buffer after setting the sample rate', s.BytesAvailable))

% set the async type and turn it on
command = 'VNWRG,06,14';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display('-------------------------------------------------')
display('VNav async is now set to:')
display(sprintf(response))

% now save these settings to the non-volatile memory
command = 'VNWNV';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
display('-------------------------------------------------')
display('Saved the settings to non-volatile memory')

% turn the async off on the VectorNav
command = 'VNWRG,06,0';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
flushinput(s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', s.BytesAvailable))

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

% reset to factory settings
display('-------------------------------------------------')
display('Starting factory reset')
command = 'VNRFS';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display('Reset to factory')
display(sprintf(response))
display(sprintf('%d bytes in input buffer after reseting to factory', s.BytesAvailable))

fclose(s)
display('Serial port is closed')

if exist('s', 'var')
    delete(s)
    clear s
    display('Serial port is deleted')
end

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

figure(1)
plot(nidata)
legend({'steer pot' 'rate gyro' 'button' 'ax' 'ay' 'az'})

figure(2)
plot(vndata)
legend({'yaw' 'pitch' 'roll' 'magx' 'magy' 'magz' 'ax' 'ay' 'az' 'wx' 'wy' 'wz'})

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
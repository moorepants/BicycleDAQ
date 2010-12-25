function [nidata, vndata, vndatatext] = NI_VN_exp
% test code to see if the NI Daq card and the vectornav play well
% together

% you have to delete the ai object before reconnecting
if exist('ai')
    delete(ai)
end

clc
close all;
clear all;

duration = 10; % the sample time in seconds

% daq parameters
nisamplerate = 200; % sample rate in hz
ninumsamples = duration*nisamplerate;

% connect to the NI USB-6218
ai = analoginput('nidaq', 'Dev1');

% add channels and lines
% 0 : PushButton
% 1 : SteerPotentiometer
% 2 : HipPotentiometer
% 3 : LeanPotentionmeter
% 4 : TwistPotentionmeter
% 5 : SteerRateGyro
% 6 : WheelSpeedMotor
% 7 : FrameAccelX
% 8 : FrameAccelY
% 9 : FrameAccelZ
% 10 : SteerTorqueSensor
% 11 : SeatpostBridge1
% 12 : SeatpostBridge2
% 13 : SeatpostBridge3
% 14 : SeatpostBridge4
% 15 : SeatpostBridge5
% 16 : SeatpostBridge6
% 17 : RightFootBridge1
% 18 : RightFootBridge2
% 19 : LeftFootBridge1
% 20 : LeftFootBridge2
% 21 : PullForceBrigde
% 22 : 3.3v
% 23 : 5v

% configure the DAQ
set(ai, 'InputType', 'SingleEnded') % Differential is default
set(ai, 'SampleRate', nisamplerate)
actualrate = get(ai,'SampleRate');
set(ai, 'SamplesPerTrigger', duration*get(ai,'SampleRate'))

chan = addchannel(ai, [0 1 5 6 7 8 9 21 22 23]); % important that this comes after set(InputType)

% trigger details
set(ai, 'TriggerType', 'Software')
set(ai, 'TriggerChannel', chan(1))
set(ai, 'TriggerCondition', 'Rising')
set(ai, 'TriggerConditionValue', 4.9)
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
s.InputBufferSize = 512*6;
get(s)

% open the serial port
fopen(s);
display('-------------------------------------------------')
display('Serial port is open')

p = 0.5; % pause value in seconds

% Turn the async off on the VectorNav
command = 'VNWRG,06,0';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
flushinput(s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', s.BytesAvailable))

% set the baudrate on the VNav and the laptop
baudrate = 921600;
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

% initialize the VectorNav data
vndata = zeros(vnsamplerate*duration, 12); % YMR
vndatatext = cell(vnsamplerate*duration, 1);

% this function takes longer than the duration to run, which is good for
% getdata(ai)
set(ai,'TriggerFcn',{@TriggerCallback, s, duration, vnsamplerate, vndatatext})

% start up the DAQ
start(ai)
display('DAQ started')
wait(ai, 60) % give the person some time to hit the button

% get the data from both devices
[nidata, time, abstime, events] = getdata(ai);
vndatatext = ai.UserData;

stop(ai)

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
        vndata(i, :) = NaN*ones(size(vndata(i, :)));
        display(sprintf('%d is a bad one: %s', i, vndatatext{i}))
    end
end

figure(1)
plot(nidata)
legend({'button' 'steer pot' 'rate gyro' 'wheel speed' 'ax' 'ay' 'az' 'pull force' '3.3v' '5v'})

figure(2)
plot(vndata)
legend({'yaw' 'pitch' 'roll' 'magx' 'magy' 'magz' 'ax' 'ay' 'az' 'wx' 'wy' 'wz'})

function TriggerCallback(obj, events, s, duration, samplerate, vndatatext)

display('Trigger called')
s.BytesAvailable

p = 0.01;

% set the async type and turn it on
command = 'VNWRG,06,14';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display('-------------------------------------------------')
display('VNav async is now set to:')
display(sprintf(response))

% record data
for i=1:duration
    for j=1:samplerate
        vndatatext{(i-1)*samplerate+j} = fgets(s);
    end
    display('a sec')
end

% Turn the async off on the VectorNav
command = 'VNWRG,06,0';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
flushinput(s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', s.BytesAvailable))

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

obj.UserData = vndatatext;
display('VN data done')
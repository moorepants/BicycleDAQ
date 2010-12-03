function UnderstandSerial

clc

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

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
display('-------------------------------------------------')
display('Pin Status:')
s.PinStatus

% set up some callback functions to see what they do
s.BytesAvailableFcn = @BytesAvailCallback;
s.BytesAvailableFcnMode = 'terminator';
s.ErrorFcn = @ErrorCallback;
s.TimerFcn = @TimerCallback;
s.OutputEmptyFcn = @OutputEmptyCallback;
s.PinStatusFcn = @PinStatusCallback;
s.BreakInterruptFcn = @BreakInterruptCallback;
display('-------------------------------------------------')
display('Callback functions are declared')

% open the serial port
fopen(s);
tic
display('-------------------------------------------------')
display('Serial port is open')
s
display('-------------------------------------------------')
display('Serial port properties after the port is open')
get(s)
display('-------------------------------------------------')
display('Pin Status:')
s.PinStatus

p = 0.1;
pause(p)
display('-------------------------------------------------')
t = toc;
display(sprintf('%d bytes in the input buffer %s seconds after opening', s.BytesAvailable, num2str(t)))

% Turn the async off on the VectorNav
command = 'VNWRG,06,0';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
flushinput(s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', s.BytesAvailable))

% Output some of the VNav registers
display('-------------------------------------------------')
display('Model Number')
command = 'VNRRG,01';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display(sprintf(response))

display('-------------------------------------------------')
display('Hardware Revision')
command = 'VNRRG,02';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display(sprintf(response))

display('-------------------------------------------------')
display('Serial Number')
command = 'VNRRG,03';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display(sprintf(response))

display('-------------------------------------------------')
display('Baud Rate')
command = 'VNRRG,05';
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(p)
response = fgets(s);
display(sprintf(response))

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


function BytesAvailCallback(obj, event)
    display('=========================================')
    display(sprintf('%d bytes available at %f seconds', obj.BytesAvailable, event.Data.AbsTime(6)))
    display('=========================================')

function OutputEmptyCallback(obj, event)
    display('=========================================')    
    display('Output is empty')
    display('=========================================')

function ErrorCallback(obj, event)
    display('=========================================')
    display('Error occured')
    event.Data.Message
    display('=========================================')
    
function TimerCallback(obj, event)
    display('=========================================')
    display('Timer')
    event.Data.AbsTime
    display('=========================================')
    
function BreakInterruptCallback(obj, event)
    display('=========================================')
    display('BreakInterrupt')
    display('=========================================')

function PinStatusCallback(obj, event)
    display('Pins changed')
    events.Data.Pin
    events.Data.PinValue
function UnderstandSerial

clc

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

comPort = 'COM3';
baudrate = 9600;

%Convert input to string
if isstr(comPort) == 0
    comPort = ['COM' num2str(comPort)];
end

%Check to see if COM port is already open, if so then close COM port.
ports = instrfind;
for i=1:length(ports)
    if strcmp(ports(i).Port, comPort) == 1
        fclose(ports(i));
    end
end

%Create the serial port
s = serial(comPort);
s.BaudRate = baudrate; % sets the serial connection baud rate
% if you set ReadAsyncMode to continous the sofware input buffer will fill
% as soon as bytes are available to fill it, but if you set it to manual
% then you have more control when you let bytes into the software input
% buffer
s.ReadAsyncMode = 'manual';
s.BytesAvailableFcnMode = 'terminator';
s.BytesAvailableFcn = @BytesAvailCallback;
s.OutputEmptyFcn = @OutputEmptyCallback;
s.PinStatusFcn = @PinStatusCallback;
display('Serial port is created')
s
display(sprintf('DataTerminalReady is %s', s.DataTerminalReady))
display(sprintf('RequestToSend is %s', s.RequestToSend))
s.PinStatus

% open the serial port
fopen(s);
display('Serial port is open')
s
display(sprintf('DataTerminalReady is %s', s.DataTerminalReady))
display(sprintf('RequestToSend is %s', s.RequestToSend))
s.PinStatus

% set stuff on the VectorNav
% turns off VN asynchronous ouput
% string = sprintf('$%s*%s\n', 'VNWRG,6,0', VNchecksum(text));
% fprintf(s, string);
% s.ValuesSent
% sets the VN sample rate
% string = sprintf('$%s*%s\n', 'VNWRG,7,200', VNchecksum(text));
% fprintf(s, string);
% sets the VN baud rate
% string = sprintf('$%s*%s\n', sprintf('VNWRG,5,%i', baudrate), VNchecksum(text));
% fprintf(s, string);
% s.PinStatus


display(sprintf('%d bytes available before flush', s.BytesAvailable))
pause(0.1);
flushinput(s);
display(sprintf('%d bytes available after flush', s.BytesAvailable))

pausetime = 2;

% wait and see if the input buffer fills (you should get a
% BytesAvailableCallback)
pause(pausetime)
display(sprintf('After %s seconds', num2str(pausetime)))
% ok now see if the buffer fills when turning on the async
s.ReadAsyncMode = 'continuous';
pause(pausetime)
display(sprintf('After %s seconds', num2str(pausetime)))
s.PinStatus

fclose(s)
display('Serial port is closed')

if exist('s')
    delete(s)
    clear s
end

function BytesAvailCallback(obj, event)
    display(sprintf('%d bytes available at %f seconds', obj.BytesAvailable, event.Data.AbsTime(6)))

function OutputEmptyCallback(obj, event)
    display('Output is empty')

function PinStatusCallback(obj, event)
    display('Pins changed')
    events.Data.Pin
    events.Data.PinValue
function UnderstandSerial

clc

comPort = 'COM3';

%Create the serial port
s = serial(comPort);
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

%Check to see if COM port is already open, if so then close COM port.
ports = instrfind;
for i=1:length(ports)
    if strcmp(ports(i).Port, comPort) == 1
        fclose(ports(i));
    end
end

%Create the serial port
fopen(s);
display('Serial port is open')
s
display(sprintf('DataTerminalReady is %s', s.DataTerminalReady))
display(sprintf('RequestToSend is %s', s.RequestToSend))
s.PinStatus

pausetime = 1;
pause(pausetime)
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
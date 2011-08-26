function calibrate()
% calibrate()
% 
% This program collects data for the calibration of several sensors on the
% instrumented bicycle. Simply run the program and follow the on screen
% instructions.

% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
daqreset

% clear up everything else
close all; clear all; clc;

% these are the sensors that can be calibrated
choices = {'Steer Angle'
           'Roll Angle'
           'Pull Force'
           'Seat Post Forces'
           'Foot Peg Forces'};

% get an choice from the user input
question = 'What would you like to calibrate?\n';
for i=1:length(choices)
    question = [question num2str(i) ': ' choices{i} '\n'];
end
choice = str2double(input(question, 's'));

% these are the names of the sensors
sensorNames = {'SteerPotentiometer'
               'RollPotentiometer'
               'PullForceBridge'
               'SeatPostBridges'
               'FootPegBridges'};

% user can add some notes
notes = input('Type notes if needed:\n', 's');
% connect to the daq box
ai = analoginput('nidaq','Dev1');
duration = 2; % collection time in seconds
set(ai, 'SampleRate', 200)
ActualRate = get(ai, 'SampleRate');
set(ai, 'SamplesPerTrigger', duration * ActualRate);
set(ai, 'InputType', 'SingleEnded');

% save parameters in this directory
directory = ['..' filesep 'data' filesep 'CalibData'];

timeStamp = datestr(clock);

% set the proper channels
switch choice
    case 1
        % 1 is the pot and 23 is the 5 volt signal
        channels = [1 23];
    case 2
        % 23 is the 5 volt signal and 24 is the pot
        channels = [23 24];
    case 3
        % 21 is the pull force bridge
        channels = 21;
    case 4
        display(['Seat post calibration is not yet implemented, ' ...
                 'please start over.'])
        return
    case 5
        display(['Foot peg calibration is not yet implemented, please ' ...
                 'start over.'])
        return
    otherwise
        display(sprintf('%d is not an option, please start over.', choice))
        return
end

% add the correct channels
chan = addchannel(ai, channels);

display(choices{choice})

% Ask the user for an accuracy of the manual reading. For example, if you
% are calibrating the pull force and you can measure the applied load with
% a sigma = +/- 0.2 lb accuracy, then enter '0.2'.
accuracy = ...
    input('What is the accuracy of your manual reading?\n', 's');

% How many trials will you do? This is the number of measurements you will
% take during the calibration.
numTrials = str2double(input('How many trials?\n', 's'));

% initialize x, y and v vectors
x = zeros(duration * ActualRate, numTrials); % voltage measurement
y = zeros(numTrials, 1); % manual reading
v = zeros(duration * ActualRate, numTrials); % supply voltage

% for each trial
for i = 1:length(y)
    switch choice
        case 1
            % The protractor should be installed into the steer tube and
            % aligned with the etched line on the bicycle frame. Positive
            % rotation is defined by a rotation vector pointing down along
            % the steer axis.
            y(i) = ...
                str2double(input(['What is the protractor reading? ' ...
                                  '[deg]\n'], 's'));
        case 2
            % The Johnson Digital Level (40-6060)should be mounted on the
            % right side of the bicycle on a surface that is parallel to
            % the mid-plane of the bicycle. The bottom of the level should
            % contact the surface and the power button on the level should
            % be below the screen. See photo P1070464.jpg. Positive
            % rotation is about an axis point from the rear wheel contact
            % point to the front wheel contact point.
            reading = ...
                str2double(input(['What is the digital level reading? ' ...
                                  '[deg]\n'], 's'));
            if sign(reading) == -1
                y(i) = -(90 + reading);
            else
                y(i) = 90 - reading;
            end
        case 3
            % The lateral force (pull force) load cell should be mounted
            % such that weight can be hung from it that puts the load cell
            % in  both tension and compression. The lateral force rod/rope
            % is setup such that a pull corresponds to a negative roll
            % angle and a push corresponds to a positive roll angle (i.e.
            % push/compression is in the positive y direction pull/tension
            % is in the negatvie y direction). Only enter the amount added
            % or subtracted from the previous measurment. For example
            % starting with tension you would apply 100 lbs to the load
            % cell and enter -100 which will then collect the data at 100
            % lbs in tension. Remove 10 lbs and enter 10 which will collect
            % the data for -85 lbs. Continue to remove 10 lbs and enter
            % '10' until you collect data for 0 lbs. Then set the load cell
            % up to measure compression and continue to add 10 lbs and
            % enter '10' until you are at +95 lbs.
            yAdded = ...
                str2double(input(['How many pounds have you added? ' ...
                                  '[lbs]\n'], 's'));
            if i == 1
                y(i) = yAdded;
            else
                y(i) = y(i - 1) + yAdded;
            end
    end
    display('Collecting data, please wait.')
    % collect voltage data
    start(ai)
    wait(ai, duration + 1)
    % output is MxN where M is number of samples and N is number of
    % channels
    output = getdata(ai);
    switch choice
        case 1
            x(:, i) = output(:, 1);
            v(:, i) = output(:, 2);
        case 2
            x(:, i) = output(:, 2);
            v(:, i) = output(:, 1);
        case 3
            x(:, i) = output(:, 1);
            v(:, i) = NaN*ones(size(output(:, 1)));
    end
    stop(ai)
    display('Data collected.')
end

% sort the data in case it is not in order
[y, indice] = sort(y);
x = x(:, indice);
v = v(:, indice);

% basic regression fit for the mean voltage and the applied weight
avgX = mean(x, 1)';
coef = polyfit(avgX, y, 1);

% plot the results
f = polyval(coef, avgX);
sst = sum((y - mean(y)).^2);
sse = sum((y - f).^2);
rsq = 1-sse / sst;
plot(avgX, y, '.', avgX, f)
xlabel('Volts')

% generate a calibration ID
calibrationID = calibration_id(directory);

% remove whitespace from the choice
signal = choices{choice};
signal(signal==' ') = '';

% build the data structure
data = struct('accuracy', accuracy, ...
              'calibrationID', calibrationID, ...
              'name', sensorNames{choice}, ...
              'notes', notes, ...
              'offset', coef(2), ...
              'rsq', rsq, ...
              'signal', signal, ...
              'slope', coef(1), ...
              'timeStamp', timeStamp, ...
              'x', x, ...
              'y', y);

if choice == 1 || choice == 2
    data.v = v;
    data.units = 'degree';
    data.calibrationSupplyVoltage = mean(v(:));
    data.runSupplyVoltage = NaN;
    data.runSupplyVoltageSource = 'FiveVolts';
    data.sensorType = 'potentiometer';
elseif choice == 3
    data.units = 'pound';
    data.calibrationSupplyVoltage = 5;
    data.runSupplyVoltage = 5;
    data.runSupplyVoltageSource = 'na';
    data.sensorType = 'LoadCell';
end

% save the calibration file
save([directory filesep calibrationID], 'data')

% clean up
delete(chan)
clear chan
delete(ai)
clear ai

function calibrationID = calibration_id(directory)
% Returns the calibration id to a number that isn't already in the data
% directory.

dirinfo = what(directory);
MatFiles = dirinfo.mat;

if isempty(MatFiles) % if there are no mat files
    calibrationID = '00000';
else % make new sequential run id
    filelist = sort(MatFiles);
    lastfile = filelist{end}; % get the last file
    lastnum = str2double(lastfile(1:end-4)); % number of the last file
    newnum = num2str(lastnum + 1);
    % pad with zeros
    for i = 1:5-length(newnum)
        newnum = ['0' newnum];
    end
    calibrationID = newnum;
end
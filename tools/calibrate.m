function calibrate()
% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
daqreset
% clear up everything else
close all; clear all; clc;

choices = {'Steer Angle Potentiometer'
           'Roll Angle Potentiometer'
           'Pull Force'
           'Seat Post'
           'Foot Pegs'};
question = 'What would you like to calibrate?\n';
for i=1:length(choices)
    question = [question num2str(i) ': ' choices{i} '\n'];
end
choice = str2num(input(question, 's'));

% connect to the daq box
ai = analoginput('nidaq','Dev1');
duration = 2; % seconds
set(ai, 'SampleRate', 200)
ActualRate = get(ai,'SampleRate');
set(ai, 'SamplesPerTrigger', duration*ActualRate);
set(ai, 'InputType', 'SingleEnded');

% save parameters
directory = ['..' filesep 'data' filesep 'CalibData'];
timestamp = fix(clock);

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
end

display(choices{choice})
% add the correct channels
chan = addchannel(ai, channels);
accuracy = ...
    input('What is the accuracy of your manual reading?\n', 's');
% how many trials will you do?
numTrials = str2num(input('How many trials?\n', 's'));
% initialize x and y vectors
x = zeros(duration*ActualRate, numTrials); % voltage measurement
y = zeros(numTrials, 1); % manual reading
v = zeros(duration*ActualRate, numTrials); % supply voltage

for i = 1:length(y)
    switch choice
        case 1
            y(i) = ...
                str2num(input('What is the protractor reading?\n', 's'));
        case 2
            reading = ...
                str2num(input('What is the digital level reading?\n', 's'));
            if sign(reading) == -1
                y(i) = -(90+reading);
            else
                y(i) = 90-reading;
            end
        case 3
            % ask the user to enter the number of pounds added
            yAdded = ...
                str2num(input('How many pounds have you added?\n', 's'));
            if i == 1
                y(i) = yAdded;
            else
                y(i) = y(i-1) + yAdded;
            end
    end
    display('Collecting data, please wait.')
    % collect voltage data
    start(ai)
    wait(ai, duration+1)
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
sst = sum((y-mean(y)).^2);
sse = sum((y-f).^2);
rsq = 1-sse/sst;
plot(avgX, y, '.', avgX, f)
xlabel('Volts')
calibID = calibration_id(directory);
data = struct('calibration', choices{choice}, ...
              'calibID', calibID, ...
              'timestamp', timestamp, ...
              'accuracy', accuracy, ...
              'y', y, ...
              'x', x, ...
              'slope', coef(1), ...
              'offset', coef(2), ...
              'rsq', rsq);
if choice ~= 3
    data.v = v;
end
save([directory filesep calibID], 'data')
delete(chan)
clear chan
delete(ai)
clear ai
function calibID = calibration_id(directory)
% Returns the calibration id to a number that isn't already in the data
% directory.

dirinfo = what(directory);
MatFiles = dirinfo.mat

if isempty(MatFiles) % if there are no mat files
    calibID = '00000';
else % make new sequential run id
    filelist = sort(MatFiles);
    lastfile = filelist{end}; % get the last file
    lastnum = str2double(lastfile(1:end-4)); % number of the last file
    newnum = num2str(lastnum + 1);
    % pad with zeros
    for i = 1:5-length(newnum)
        newnum = ['0' newnum];
    end
    calibID = newnum;
end

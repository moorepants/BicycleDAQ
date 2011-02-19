% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
% clear up everything else
close all; clear all; clc;

% connect to the daq box
ai = analoginput('nidaq','Dev1');
duration = 5; % seconds
set(ai,'SampleRate',200)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'InputType','SingleEnded');
chan = addchannel(ai,[1,23]);
%Vin=addchannel(ai,[23]);  %recording the input voltage

% how many trials will you do?
numTrials = str2num(input('How many angles do you want to collect data at?\n', 's'));
% initialize pull force and voltage vectors
p = zeros(numTrials, 1);
v = zeros(numTrials, 1);
Vin=zeros(numTrials, 1);

for i = 1:length(p)
    % ask the user to enter the number of pounds added
%     weightadded = str2num(input('How many pounds have you added?\n', 's'));
%     if i == 1
%         p(i) = weightadded;
%     else
%         p(i) = p(i-1)+weightadded;
%     end
    angle1=str2num(input('what is the angle reading on the protractor? \n', 's') );
    %Angle beyond 50 degrees on each side overshoots the potentiometer. 
    %calibrate for angles from -50 to +50, which is 21 data points
    p(i)=angle1;
    
    start(ai)
    wait(ai, duration+1)
    data = getdata(ai);
    v(i) = mean(data(:,1));
    Vin(i)=mean(data(:,2));
    stop(ai)
end



coef = polyfit(v, p, 1)

plot(v, p, '.', v, coef(1).*v+coef(2))
grid on
delete(ai)
clear ai chan
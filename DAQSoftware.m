% you have to delete the ai object for things to restart correctly
if exist('ai')
    delete(ai)
end
% clear up everything else
close all; clear all; clc;

% Sensitvity matrix from Cal Stone's thesis (Stone 1990)
% L = S*R
% L : Load, S : Sensitivty Matrix, R : Wheatstone bridge response
% Units:
% Force: N*Gain/V
% Moment: N*m*Gain/V
senMatrix = [.563 -2.923 276.195 275.294 -0.012;
    333.116 -259.823 -0.737 3.789 -12.908;
    1.855 17.542 -15.340 -36.186 -2957.206;
    48.917 -24.279 -0.031 0.278 -0.603;
    0.288 0.166 -27.431 -41.685 -2.078];
fzGain = 454;
otherGain = 525;
senMatrix(:,[1 2 4 5]) = senMatrix(:,[1 2 4 5])*1000/otherGain;
senMatrix(:,3) = senMatrix(:,3)*1000/fzGain;
% s = daqhwinfo
% s.InstalledAdaptors
% out=daqhwinfo('nidaq')
% out.ObjectConstructorName(:)

% open the daq box
ai = analoginput('nidaq','Dev1');
duration = 10; % seconds
set(ai,'SampleRate',100);
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'TriggerType','Manual');
set(ai,'InputType','SingleEnded');
chan = addchannel(ai,[0 1 2 3 4]);

% take 10 seconds of data
start(ai)
trigger(ai)
wait(ai,duration+1)
data = getdata(ai);
avg = sum(data(101:end,:))/(length(data)-100);

delete(ai)
clear ai chan

% connect to the daq box again
ai = analoginput('nidaq','Dev1');
duration = 6000; % seconds
set(ai,'SampleRate',100)
ActualRate = get(ai,'SampleRate');
set(ai,'SamplesPerTrigger',duration*ActualRate);
set(ai,'TriggerType','Manual');
set(ai,'InputType','SingleEnded');
chan = addchannel(ai,[0 1 2 3 4]);

start(ai)
trigger(ai)

data = zeros(50,5);
data2 = zeros(50,5);

% make the figure
figure(1)
bridgePlot = subplot(1,3,1);
bridgeLines = plot(data); % plot the raw data
ylim([2.4 2.6])
ylabel('Bridge Voltage')
bridgeLeg = legend('Bridge 9', 'Bridge 10', 'Bridge 11', 'Bridge 12', 'Bridge 13');
% plot the three forces
forcePlot = subplot(1,3,2);
forceLines = plot(data2(:,1:3));
ylabel('Force [lbs]')
forceLeg = legend('Fx', 'Fy', 'Fz');
ylim([-50,50])
% plot the moments
momentPlot = subplot(1,3,3);
momentLines = plot(data2(:,4:5));
ylabel('Moment [ft-lbs]')
ylim([-20,20])
momentLeg = legend('Mx', 'My');

% conversion factors
newtons2lbs = 1/4.45;
nm2ftlbs = 0.73756;


% update the plot while the data is being taken
while (1)
    % return the latest 50 samples
    data = peekdata(ai,50);
        % take only the channels for the loads
    data2 = data(:,1:5);
    for i = 1:length(data);
        % multiply the average subtracted data by the sensitivty matrix 
        data2(i,:) = senMatrix*(data2(i,:) - avg)';
    end
        for i = 1:5
        set(bridgeLines(i), 'YData', data(:,i))
    end
    for i = 1:3
        set(forceLines(i), 'YData', data2(:,i).*newtons2lbs)
    end
    for i = 4:5
        set(momentLines(i-3), 'YData', data2(:,i).*nm2ftlbs)
    end
    
    meanData = mean(data);
    meanData2 = mean([data2(:,1:3).*newtons2lbs, data2(:,4:5).*nm2ftlbs]);
    br1Label = sprintf('Bridge 9 = %1.2f V', meanData(1));
    br2Label = sprintf('Bridge 10 = %1.2f V', meanData(2));
    br3Label = sprintf('Bridge 11 = %1.2f V', meanData(3));
    br4Label = sprintf('Bridge 12 = %1.2f V', meanData(4));
    br5Label = sprintf('Bridge 13 = %1.2f V', meanData(5));
    fxLabel = sprintf('Fx = %1.2f lbs', meanData2(1));
    fyLabel = sprintf('Fy = %1.2f lbs', meanData2(2));
    fzLabel = sprintf('Fz = %1.2f lbs', meanData2(3));
    mxLabel = sprintf('Mx = %1.2f ft*lbs', meanData2(4));
    myLabel = sprintf('My = %1.2f ft*lbs', meanData2(5));
    set(bridgeLeg, 'String', {br1Label, br2Label, br3Label, br4Label, br5Label})
    set(forceLeg, 'String', {fxLabel, fyLabel, fzLabel})
    set(momentLeg, 'String', {mxLabel, myLabel})
    figure(1)
end

delete(ai)
clear ai chan

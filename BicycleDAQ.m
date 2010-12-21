function varargout = BicycleDAQ(varargin)
%BICYCLEDAQ M-file for BicycleDAQ.fig
%      BICYCLEDAQ, by itself, creates a new BICYCLEDAQ or raises the existing
%      singleton*.
%
%      H = BICYCLEDAQ returns the handle to a new BICYCLEDAQ or the handle to
%      the existing singleton*.
%
%      BICYCLEDAQ('Property','Value',...) creates a new BICYCLEDAQ using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to BicycleDAQ_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BICYCLEDAQ('CALLBACK') and BICYCLEDAQ('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BICYCLEDAQ.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BicycleDAQ

% Last Modified by GUIDE v2.5 20-Dec-2010 16:41:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BicycleDAQ_OpeningFcn, ...
                   'gui_OutputFcn',  @BicycleDAQ_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before BicycleDAQ is made visible.
function BicycleDAQ_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for BicycleDAQ
handles.output = hObject;

if exist('handles.ai')
    delete(handles.ai)
end

% these permanently set the functions for these callbacks in the gui
set(handles.GraphTypeButtonGroup, 'SelectionChangeFcn', ...
    @GraphTypeButtonGroup_SelectionChangeFcn);
set(handles.ActionButtonGroup, 'SelectionChangeFcn', ...
    @ActionButtonGroup_SelectionChangeFcn);

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

% this is what is plugged into each analog input on the NI USB-6218
handles.InputPairs = struct('PushButton',          0, ...
                            'SteerPotentiometer',  1, ...
                            'HipPotentiometer',    2, ...
                            'LeanPotentionmeter',  3, ...
                            'TwistPotentionmeter', 4, ...
                            'SteerRateGyro',       5, ...
                            'WheelSpeedMotor',     6, ...
                            'FrameAccelX',         7, ...
                            'FrameAccelY',         8, ...
                            'FrameAccelZ',         9, ...
                            'SteerTorqueSensor',  10, ...
                            'SeatpostBridge1',    11, ...
                            'SeatpostBridge2',    12, ...
                            'SeatpostBridge3',    13, ...
                            'SeatpostBridge4',    14, ...
                            'SeatpostBridge5',    15, ...
                            'SeatpostBridge6',    16, ...
                            'RightFootBridge1',   17, ...
                            'RightFootBridge2',   18, ...
                            'LeftFootBridge1',    19, ...
                            'LeftFootBridge2',    20, ...
                            'PullForceBrigde',    21);

% graph legends
% the struct command doesn't seem to like values of different length so I
% had to put all the cells in double brackets
handles.RawLegends = struct('SteerAngleButton', {{'PushButton'
                                                  'SteerPotentiometer'
                                                  'SteerRateGyro'
                                                  'WheelSpeedMotor'
                                                  'SteerTorqueSensor'
                                                  'FrameAccelX'
                                                  'FrameAccelY'
                                                  'FrameAccelZ'}}, ...
                            'RiderRateButton', {{'HipPotentiometer'
                                                 'LeanPotentionmeter'
                                                 'TwistPotentionmeter'}}, ...
                            'SeatpostAccelerationButton', {{'SeatpostBridge1'
                                                            'SeatpostBridge2'
                                                            'SeatpostBridge3'
                                                            'SeatpostBridge4'
                                                            'SeatpostBridge5'
                                                            'SeatpostBridge6'}}, ...
                            'FeetForceButton', {{'RightFootBridge1'
                                                 'RightFootBridge2'
                                                 'LeftFootBridge1'
                                                 'LeftFootBridge2'}}, ...
                            'VnavMomentButton', {{'Voltage 1'
                                                  'Voltage 2'
                                                  'Voltage 3'
                                                  'Voltage 4'
                                                  'Voltage 5'
                                                  'Voltage 6'
                                                  'Voltage 7'
                                                  'Voltage 8'
                                                  'Voltage 9'
                                                  'Voltage 10'}});
handles.ScaledLegends = struct('SteerAngleButton', {{'Steer Angle'
                                                     'Roll Angle'
                                                     'Yaw Angle'
                                                     'Pitch Angle'
                                                     'Hip Angle'
                                                     'Lean Angle'
                                                     'Twist Angle'}}, ...
                               'RiderRateButton', {{'Steer Rate'
                                                    'Roll Rate'
                                                    'Yaw Rate'
                                                    'Pitch Rate'
                                                    'Wheel Rate'}}, ...
                               'SeatpostAccelerationButton', {{'VNav X'
                                                               'VNav Y'
                                                               'VNav Z'
                                                               'Frame X'
                                                               'Frame Y'
                                                               'Frame Z'}}, ...
                               'FeetForceButton', {{'Seat Fx'
                                                    'Seat Fy'
                                                    'Seat Fz'
                                                    'Right Foot'
                                                    'Left Foot'
                                                    'Pull Force'}}, ...
                               'VnavMomentButton', {{'Steer Torque'
                                                     'Seat Mx'
                                                     'Seat My'
                                                     'Seat Mz'
                                                     'Right Foot'
                                                     'Left Foot'}}, ...
                               'MagneticButton', {{'X'
                                                   'Y'
                                                   'Z'}});

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BicycleDAQ wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = BicycleDAQ_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function NotesText_Callback(hObject, eventdata, handles)
% hObject    handle to NotesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NotesText as text
%        str2double(get(hObject,'String')) returns contents of NotesText as a double


% --- Executes during object creation, after setting all properties.
function NotesText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NotesText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NewSpeedEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpeedEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewSpeedEditText as text
%        str2double(get(hObject,'String')) returns contents of NewSpeedEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the items in the popmenu
items = get(handles.SpeedPopupmenu, 'String');

% if the popupmenu is not a cell then make it one
if sum(class(items) == 'cell') ~= 4
    items = {items};
end

% how many are already in the list
number = length(items);

% add the new item to the end of the list
items{number + 1} = newitem;

% sort the speeds
[sorteditems, index] = sort(str2double(items));

% convert the sorted speeds back to a strings and cells
for i = 1:length(sorteditems)
    items{i} = num2str(sorteditems(i));
end

% rewrite the popupmenu and set the value to the new item
set(handles.SpeedPopupmenu, 'String', items)
set(handles.SpeedPopupmenu, 'Value', index(number + 1))

% put the old text back in the edit box
set(hObject, 'String', 'Add a new speed')


% --- Executes during object creation, after setting all properties.
function NewSpeedEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewSpeedEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ScaledRawButton.
function ScaledRawButton_Callback(hObject, eventdata, handles)
% hObject    handle to ScaledRawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScaledRawButton

switch get(hObject, 'Value')
    case 0.0
        set(hObject, 'String', 'Scaled Data')
        set(handles.SteerAngleButton, 'String', 'Steer')
        set(handles.RiderRateButton, 'String', 'Rider')
        set(handles.SeatpostAccelerationButton, 'String', 'Seatpost')
        set(handles.FeetForceButton, 'String', 'Feet')
        set(handles.VnavMomentButton, 'String', 'VectorNav')
        set(handles.MagneticButton, 'Enable', 'off')
    case 1.0
        set(hObject, 'String', 'Raw Data')
        set(handles.SteerAngleButton, 'String', 'Angles')
        set(handles.RiderRateButton, 'String', 'Rates')
        set(handles.SeatpostAccelerationButton, 'String', 'Accelerations')
        set(handles.FeetForceButton, 'String', 'Forces')
        set(handles.VnavMomentButton, 'String', 'Moments')
        set(handles.MagneticButton, 'Enable', 'on')
end


function NewRiderEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewRiderEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewRiderEditText as text
%        str2double(get(hObject,'String')) returns contents of NewRiderEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the items in the popmenu
items = get(handles.RiderPopupmenu, 'String');

% if the popupmenu is not a cell then make it one
if sum(class(items) == 'cell') ~= 4
    items = {items};
end

% how many are already in the list
number = length(items);

% add the new item to the end of the list
items{number + 1} = newitem;

% rewrite the popupmenu and set the value to the new item
set(handles.RiderPopupmenu, 'String', items)
set(handles.RiderPopupmenu, 'Value', number + 1)

% put the old text back in the edit box
set(hObject, 'String', 'Add a new rider')


% --- Executes during object creation, after setting all properties.
function NewRiderEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewRiderEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NewBicycleEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewBicycleEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewBicycleEditText as text
%        str2double(get(hObject,'String')) returns contents of NewBicycleEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the items in the popmenu
items = get(handles.BicyclePopupmenu, 'String');

% if the popupmenu is not a cell then make it one
if sum(class(items) == 'cell') ~= 4
    items = {items};
end

% how many are already in the list
number = length(items);

% add the new item to the end of the list
items{number + 1} = newitem;

% rewrite the popupmenu and set the value to the new item
set(handles.BicyclePopupmenu, 'String', items)
set(handles.BicyclePopupmenu, 'Value', number + 1)

% put the old text back in the edit box
set(hObject, 'String', 'Add a new bicycle')

% --- Executes during object creation, after setting all properties.
function NewBicycleEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewBicycleEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function GraphTypeButtonGroup_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'SteerAngleButton'
        display('angles')
    case 'RiderRateButton'
        display('angles')
    case 'SeatpostAccelerationButton'
        display('accelerations')
    case 'FeetForceButton'
        display('forces')
    case 'VnavMomentButton'
        display('moments')
    case 'MagneticButton'
        display('magnetic')
    otherwise
        % Code for when there is no match.
end

function ActionButtonGroup_SelectionChangeFcn(hObject, eventdata)
handles = guidata(hObject);
switch get(eventdata.NewValue, 'Tag')
    case 'LoadButton'
        % brings up a selection window for a file
    case 'DisplayButton'
        % displays the live data
        % start collecting data from the DAQ
        start(handles.ai)
        trigger(handles.ai)
        % find out what graph button is pressed
        ButtonName = get(get(handles.GraphTypeButtonGroup, 'SelectedObject'), 'Tag');
        % find out if the graph is raw or scaled data
        switch get(handles.ScaledRawButton, 'Value')
            case 0.0
                legtype = 'RawLegends';
            case 1.0
                legtype = 'ScaledLegends';
        end
        % create a vector with the analog input numbers for this graph
        datavals = zeros(1,length(eval(['handles.' legtype '.' ButtonName])));
        for i = 1:length(eval(['handles.' legtype '.' ButtonName]))
            input = char(eval(['handles.' legtype '.' ButtonName '(i)']));
            datavals(i) = eval(['handles.InputPairs.' input]);
        end
        % set the plot axes to the graph
        axes(handles.Graph)
        % plot blank data
        data = zeros(50,length(eval(['handles.RawLegends.' ButtonName])));
        lines = plot(data); % plot the raw data
        ylim([-5 5])
        ylabel('Voltage')
        
        leg = legend(eval(['handles.' legtype '.' ButtonName]));
%         labels = {'', '', '', '', ''};

        daqdata = zeros(50, length(fieldnames(handles.InputPairs)));
        vnavdata = zeros(50, 10);
        % update the plot while the data is being taken
        while handles.stopgraph == 0
            display('another while')
            for i = 1:50
                tic
                display('VNav')
                vnavdata(i, :) = VNgetsamples(handles.s, 'RAW', 1);
                toc
                tic
                display('DAQ')
                daqdata(i, :) = peekdata(handles.ai, 1);
                toc
                %getsample(handles.ai);
            end
            % return the latest 100 samples
%             data = peekdata(handles.ai, 50);
            for i = 1:length(eval(['handles.' legtype '.' ButtonName]))
                set(lines(i), 'YData', daqdata(:, datavals(i)+1))
            end
%             meanData = mean(data);
%             labels{1} = sprintf('Steer Angle = %1.2f V', meanData(1));
%             labels{2} = sprintf('Steer Rate = %1.2f V', meanData(2));
%             labels{3} = sprintf('Steer Torque = %1.2f V', meanData(3));
%             labels{4} = sprintf('Wheel Speed = %1.2f V', meanData(4));
%             labels{5} = sprintf('Button = %1.2f V', meanData(5));
%             set(leg, 'String', labels)
            drawnow
            handles = guidata(handles.BicycleDAQ);
        end
    case 'RecordButton'
        % records data to file
end


% --- Executes on key release with focus on BicycleDAQ and none of its controls.
function BicycleDAQ_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to BicycleDAQ (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rmfield(handles, 'ai')
delete(handles.ai)
daqreset


% --- Executes when user attempts to close BicycleDAQ.
function BicycleDAQ_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to BicycleDAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in ConnectButton.
function ConnectButton_Callback(hObject, eventdata, handles)
% hObject    handle to ConnectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ConnectButton

switch get(hObject, 'Value')
    case 1.0 % connect
        % button turns yellow and displays connecting
        set(hObject, 'String', 'Connecting...')
        set(hObject, 'BackgroundColor', 'Yellow')

        % get general parameters
        handles.duration = str2double(get(handles.DurationEditText, 'String'));

        % get VectorNav parameters
        handles.comport = get(handles.VNavComPortEditText, 'String');
        handles.vnsamplerate = str2double(get(handles.VNavSampleRateEditText, 'String'));
        % may need a way here to make sure the vn sample rate is a valid choice
        handles.vnnumsamples = handles.duration*handles.vnsamplerate;

        % see if the port is already open, close it if so
        close_port(handles.comport)

        % create the serial port
        handles.s = serial(handles.comport);
        display('-------------------------------------------------')
        display('Serial port created, here are the initial properties:')
        set(handles.s, 'InputBufferSize', 512*6)
        set(handles.s, 'Timeout', 1)
        get(handles.s) % display the attributes of the port

        % open the serial port
        fopen(handles.s);
        display('-------------------------------------------------')
        display('Serial port is open')

        p = 0.1; % pause value in seconds
        pause(p)

        % determine the VNav baud rate and set the serial port baud rate to
        % match
        baudrate = determine_vnav_baud_rate(handles.s);
        set(handles.s, 'BaudRate', baudrate)

        % turn the async off on the VectorNav
        send_command(handles.s, 'VNWRG,06,0');
        pause(p)
        flush_buffer(handles.s)
        display('-------------------------------------------------')
        display('The VectorNav async mode is off')
        display(sprintf('%d bytes in input buffer after turning async off and flushing', get(handles.s, 'BytesAvailable')))

        % set the baudrate on the VNav and the laptop
        baudrate = 921600;
        response = send_command(handles.s, ['VNWRG,05,' num2str(baudrate)]);
        set(handles.s, 'BaudRate', baudrate) % set the laptop baud rate to match
        display('-------------------------------------------------')
        display('VNav baud rate is now set to:')
        display(sprintf(response))
        display(sprintf('%d bytes in input buffer after setting the baud rate', get(handles.s, 'BytesAvailable')))

        % set the samplerate
        response = send_command(handles.s, ['VNWRG,07,' num2str(handles.vnsamplerate)]);
        display('-------------------------------------------------')
        display('VNav sample rate is now set to:')
        display(sprintf(response))
        display(sprintf('%d bytes in input buffer after setting the sample rate', get(handles.s, 'BytesAvailable')))

        % initialize the VectorNav data
        handles.vndata = zeros(handles.vnsamplerate*handles.duration, 12); % YMR
        handles.vndatatext = cell(handles.vnsamplerate*handles.duration, 1);

        % daq parameters
        handles.nisamplerate = str2num(get(handles.NISampleRateEditText, 'String')); % sample rate in hz
        handles.ninumsamples = handles.duration*handles.nisamplerate;

        % connect to the NI USB-6218
        handles.ai = analoginput('nidaq', 'Dev1');

        % configure the DAQ
        set(handles.ai, 'InputType', 'SingleEnded') % Differential is default
        set(handles.ai, 'SampleRate', handles.nisamplerate)
        actualrate = get(handles.ai,'SampleRate');
        set(handles.ai, 'SamplesPerTrigger', handles.duration*get(handles.ai,'SampleRate'))

        chan = addchannel(handles.ai, [0 1 5 6 7 8 9]); % important that this comes after set(InputType)

        % trigger details
        set(handles.ai, 'TriggerType', 'Software')
        set(handles.ai, 'TriggerChannel', chan(1))
        set(handles.ai, 'TriggerCondition', 'Rising')
        set(handles.ai, 'TriggerConditionValue', 4.9)
        set(handles.ai, 'TriggerDelay', 0.00)

        % this function takes longer than the duration to run, which is good for
        % getdata(ai)
        set(handles.ai, 'TriggerFcn', {@trigger_callback, handles})

        get(handles.ai)

        % tells the graph loop to keep going
        handles.stopgraph = 0;

        set(hObject, 'String', sprintf('Disconnect'))
        set(hObject, 'BackgroundColor', 'Red')
        set(handles.DisplayButton, 'Enable', 'On')
        set(handles.RecordButton, 'Enable', 'On')
        set(handles.TareButton, 'Enable', 'On')

    case 0.0 % disconnect
        set(hObject, 'String', 'Connect')
        set(hObject, 'BackgroundColor', 'Green')
        set(handles.DisplayButton, 'Enable', 'Off')
        set(handles.RecordButton, 'Enable', 'Off')
        set(handles.TareButton, 'Enable', 'Off')
        % tells the graph loop to stop
        handles.stopgraph = 1;
        %rmfield(handles, 'ai')
        %delete(handles.ai)
        get(handles.ai, 'Running')
        if strcmp(get(handles.ai, 'Running'), 'On')
            stop(handles.ai)
        end
        daqreset
        
        % reset to factory settings
        display('-------------------------------------------------')
        display('Starting factory reset')
        response = send_command(handles.s, 'VNRFS');
        display('Reset to factory')
        display(sprintf(response))
        display(sprintf('%d bytes in input buffer after reseting to factory', get(handles.s, 'BytesAvailable')))
        % close the VectorNav connection
        fclose(handles.s)
        display('Serial port is closed')

        if exist('s', 'var')
            delete(s)
            clear s
            display('Serial port is deleted')
        end

end

% Update handles structure
guidata(hObject, handles);
    


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over NewBicycleEditText.
function NewBicycleEditText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to NewBicycleEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
display('testing')
set(hObject, 'Enable', 'on')

% --- Executes on selection change in RiderPopupmenu.
function RiderPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to RiderPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RiderPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RiderPopupmenu


% --- Executes during object creation, after setting all properties.
function RiderPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RiderPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in SpeedPopupmenu.
function SpeedPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SpeedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SpeedPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpeedPopupmenu


% --- Executes during object creation, after setting all properties.
function SpeedPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SpeedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over NewRiderEditText.
function NewRiderEditText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to NewRiderEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function BicyclePopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BicyclePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function RunIDEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RunIDEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BicyclePopupmenu.
function BicyclePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to BicyclePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BicyclePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BicyclePopupmenu



function NewManueverEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewManueverEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewManueverEditText as text
%        str2double(get(hObject,'String')) returns contents of NewManueverEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the items in the popmenu
items = get(handles.ManueverPopupmenu, 'String');

% if the popupmenu is not a cell then make it one
if sum(class(items) == 'cell') ~= 4
    items = {items};
end

% how many are already in the list
number = length(items);

% add the new item to the end of the list
items{number + 1} = newitem;

% rewrite the popupmenu and set the value to the new item
set(handles.ManueverPopupmenu, 'String', items)
set(handles.ManueverPopupmenu, 'Value', number + 1)

% put the old text back in the edit box
set(hObject, 'String', 'Add a new manuever')


% --- Executes during object creation, after setting all properties.
function NewManueverEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewManueverEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ManueverPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManueverPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ManueverPopupmenu.
function ManueverPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ManueverPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ManueverPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ManueverPopupmenu



function RunIDEditText_Callback(hObject, eventdata, handles)
% hObject    handle to RunIDEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RunIDEditText as text
%        str2double(get(hObject,'String')) returns contents of RunIDEditText as a double



function VNavSampleRateEditText_Callback(hObject, eventdata, handles)
% hObject    handle to VNavSampleRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VNavSampleRateEditText as text
%        str2double(get(hObject,'String')) returns contents of VNavSampleRateEditText as a double


% --- Executes during object creation, after setting all properties.
function VNavSampleRateEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VNavSampleRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NISampleRateEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NISampleRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NISampleRateEditText as text
%        str2double(get(hObject,'String')) returns contents of NISampleRateEditText as a double


% --- Executes during object creation, after setting all properties.
function NISampleRateEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NISampleRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DurationEditText_Callback(hObject, eventdata, handles)
% hObject    handle to DurationEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DurationEditText as text
%        str2double(get(hObject,'String')) returns contents of DurationEditText as a double


% --- Executes during object creation, after setting all properties.
function DurationEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DurationEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VNavComPortEditText_Callback(hObject, eventdata, handles)
% hObject    handle to VNavComPortEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VNavComPortEditText as text
%        str2double(get(hObject,'String')) returns contents of VNavComPortEditText as a double


% --- Executes during object creation, after setting all properties.
function VNavComPortEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VNavComPortEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trigger_callback(obj, events, handles)

display('Trigger called')

% set the async type and turn it on
response = send_command(handles.s, 'VNWRG,06,14');
display('-------------------------------------------------')
display('VNav async is now set to:')
display(sprintf(response))

% record data
for i=1:handles.duration
    for j=1:handles.vnsamplerate
        handles.vndatatext{(i-1)*handles.vnsamplerate+j} = fgets(handles.s);
    end
    display(sprintf('Data taken for %d seconds', i))
end

% turn the async off on the VectorNav
send_command(handles.s, 'VNWRG,06,0');
pause(0.1)
flush_buffer(handles.s)
display('-------------------------------------------------')
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', get(handles.s, 'BytesAvailable')))


obj.UserData = handles.vndatatext;
display('VN data done')

function baudrate = determine_vnav_baud_rate(s)
    % Returns the baudrate that the VectorNav is set to or NaN if it can't be
    % determined.
    % s : serial port object for the VectorNav

    baudrates = [9600 19200 38400 57600 115200 128000 230400 460800 921600];

    baudrate = NaN;

    for i = 1:length(baudrates)
        % set the serial object baudrate
        s.BaudRate = baudrates(i);
        % first set the async to off
        send_command(s, 'VNWRG,06,0');
        pause(0.1)
        display('-------------------------------------------------')
        display(sprintf('Checking the %d baudrate', baudrates(i)))
        display('The VectorNav async mode is off')
        % flush the buffer
        flush_buffer(s)
        display(sprintf('%d bytes in input buffer after turning async off and flushing', get(s, 'BytesAvailable')))
        display('-------------------------------------------------')
        % see if it will return the version number
        response = send_command(s, 'VNRRG,01');
        if strcmp(response, sprintf('$VNRRG,01,VN-100_v4*47\r\n'))
            % then the baudrate is correct and we should save it
            baudrate = baudrates(i);
            display(sprintf('The VNav baud rate is %d', baudrate))
            break
        end
    end

function response = send_command(s, command)
    % Returns the latest response from the input buffer after the issued
    % command. Response will only work correctly  when async is off.
    % s : serial port object for the VectorNav
    % command : string
    % response : string

    fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
    pause(0.1)
    response = fgets(s);

function flush_buffer(s)
    % flushes the serial port input buffer

    while get(s, 'BytesAvailable') > 0
        flushinput(s)
        display('Flushed the input buffer')
    end

function close_port(comport)
    % check to see if COM port is already open, if so then close COM port.

    ports = instrfind;
    if length(ports) == 0
        display('No ports exist')
    else
        for i = 1:length(ports)
            if strcmp(ports(i).Port, comport) == 1
                fclose(ports(i));
                delete(ports(i));
                display(['Closed and deleted ' comport])
            else
                display([comport ' was not open'])
            end
        end
    end


% --- Executes on button press in TareButton.
function TareButton_Callback(hObject, eventdata, handles)
% hObject    handle to TareButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RecordButton.
function RecordButton_Callback(hObject, eventdata, handles)
% hObject    handle to RecordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RecordButton
set(handles.LoadButton, 'Enable', 'Off')
set(handles.DisplayButton, 'Enable', 'Off')
set(handles.TareButton, 'Enable', 'Off')

% start up the DAQ
start(handles.ai)
display('DAQ started, waiting for trigger...')
set(hObject, 'String', 'DAQ started, waiting for trigger...')
wait(handles.ai, str2double(get(handles.WaitEditText, 'String'))) % give the person some time to hit the button

% get the data from both devices
[nidata, time, abstime, events] = getdata(handles.ai);
handles.vndatatext = get(handles.ai, 'UserData');

stop(handles.ai)



function WaitEditText_Callback(hObject, eventdata, handles)
% hObject    handle to WaitEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WaitEditText as text
%        str2double(get(hObject,'String')) returns contents of WaitEditText as a double


% --- Executes during object creation, after setting all properties.
function WaitEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WaitEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

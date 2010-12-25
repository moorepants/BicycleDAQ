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

% Last Modified by GUIDE v2.5 23-Dec-2010 14:38:12

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

% make sure the analog input was properly deleted
if exist('handles.ai')
    delete(handles.ai)
end

% permanently set the function for this callback in the gui
set(handles.GraphTypeButtonGroup, 'SelectionChangeFcn', ...
    @GraphTypeButtonGroup_SelectionChangeFcn);

% load the VectorNav library
addpath('C:\Documents and Settings\Administrator\My Documents\MATLAB\VectorNavLib')

% create a data directory if one doesn't already exist
if exist('data/', 'dir') ~= 7
    mkdir('data/')
end

% set the default parameters in the gui
populate_gui(handles)

% update the run id number
set_run_id(handles)

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
                            'PullForceBridge',    21, ...
                            'ThreeVolts',         22, ...
                            'FiveVolts',          23);

% graph legends
% the struct command doesn't seem to like values of different length so I
% had to put all the cells in double brackets
handles.RawLegends = struct('PotAngleButton', {{'SteerPotentiometer'
                                                'HipPotentiometer'
                                                'LeanPotentionmeter'
                                                'TwistPotentionmeter'}}, ...
                            'RateAccelRateButton', {{'SteerRateGyro'
                                                     'WheelSpeedMotor'
                                                     'FrameAccelX'
                                                     'FrameAccelY'
                                                     'FrameAccelZ'}}, ...
                            'SeatpostAccelerationButton', {{'SeatpostBridge1'
                                                            'SeatpostBridge2'
                                                            'SeatpostBridge3'
                                                            'SeatpostBridge4'
                                                            'SeatpostBridge5'
                                                            'SeatpostBridge6'}}, ...
                            'FeetForceButton', {{'SteerTorqueSensor'
                                                 'RightFootBridge1'
                                                 'RightFootBridge2'
                                                 'LeftFootBridge1'
                                                 'LeftFootBridge2'
                                                 'PullForceBridge'}}, ...
                            'VnavMomentButton', {{'Angular Rotation Z'
                                                  'Angular Rotation Y'
                                                  'Angular Rotation X'
                                                  'Mag X'
                                                  'Mag Y'
                                                  'Mag Z'
                                                  'Acceleration X'
                                                  'Acceleration Y'
                                                  'Acceleration Z'
                                                  'Angular Rate X'
                                                  'Angular Rate Y'
                                                  'Angular Rate Z'}}, ...
                             'VoltageMagneticButton', {{'PushButton'
                                                        'ThreeVolts'
                                                        'FiveVolts'}});
handles.ScaledLegends = struct('PotAngleButton', {{'Steer Angle'
                                                   'Roll Angle'
                                                   'Yaw Angle'
                                                   'Pitch Angle'
                                                   'Hip Angle'
                                                   'Lean Angle'
                                                   'Twist Angle'}}, ...
                               'RateAccelRateButton', {{'Steer Rate'
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
                               'VoltageMagneticButton', {{'X'
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


function NotesEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NotesEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NotesEditText as text
%        str2double(get(hObject,'String')) returns contents of NotesEditText as a double

handles.par.notes = get(hObject, 'String')

function NewSpeedEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpeedEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewSpeedEditText as text
%        str2double(get(hObject,'String')) returns contents of NewSpeedEditText as a double

add_to_popupmenu(hObject, handles)
handles.par.Speed = str2double(get(hObject, 'String'))


% --- Executes on button press in ScaledRawButton.
function ScaledRawButton_Callback(hObject, eventdata, handles)
% hObject    handle to ScaledRawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ScaledRawButton

switch get(hObject, 'Value')
    case 0.0
        set(hObject, 'String', 'Scaled Data')
        set(handles.PotAngleButton, 'String', 'Pots')
        set(handles.RateAccelRateButton, 'String', 'Rates/Accels')
        set(handles.SeatpostAccelerationButton, 'String', 'Seatpost')
        set(handles.FeetForceButton, 'String', 'Feet/Forces')
        set(handles.VnavMomentButton, 'String', 'VectorNav')
        set(handles.VoltageMagneticButton, 'String', 'Voltage')
    case 1.0
        set(hObject, 'String', 'Raw Data')
        set(handles.PotAngleButton, 'String', 'Angles')
        set(handles.RateAccelRateButton, 'String', 'Rates')
        set(handles.SeatpostAccelerationButton, 'String', 'Accelerations')
        set(handles.FeetForceButton, 'String', 'Forces')
        set(handles.VnavMomentButton, 'String', 'Moments')
        set(handles.VoltageMagneticButton, 'String', 'Magnetic')
end


function NewRiderEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewRiderEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewRiderEditText as text
%        str2double(get(hObject,'String')) returns contents of NewRiderEditText as a double

add_to_popupmenu(hObject, handles)
handles.par.Rider = get(hObject, 'String')


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

add_to_popupmenu(hObject, handles)
handles.par.Bicycle = get(hObject, 'String')

function GraphTypeButtonGroup_SelectionChangeFcn(hObject, eventdata)
% Plots the data of the current graph button that is pressed.
% Parameters
% ----------
% hObject : handle to the GraphTypeButton
% eventdata : handle to the button press event

% get the latest handles since it wasn't passed in
handles = guidata(hObject);

% update the graph
plot_data(handles)


function ActionButtonGroup_SelectionChangeFcn(hObject, eventdata)

% get the latest handles
handles = guidata(hObject);
get(eventdata.NewValue, 'Tag')
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
    case 'RecordButton' % records data to file


end


% --- Executes on key release with focus on BicycleDAQ and none of its controls.
function BicycleDAQ_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to BicycleDAQ (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close BicycleDAQ.
function BicycleDAQ_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to BicycleDAQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

% update the pop up menus
Rider = get(handles.RiderPopupmenu, 'String');
Speed = get(handles.SpeedPopupmenu, 'String');
Bicycle = get(handles.BicyclePopupmenu, 'String');
Manuever = get(handles.ManueverPopupmenu, 'String');
Environment = get(handles.EnvironmentPopupmenu, 'String');

% make a copy of the default parameters file
%copyfile('DefaultParameters.mat', 'AppendedParameters.mat')

% append the additonal popup menus to the new file
%save('AppendedParameters.mat', ...
%     'Rider', 'Speed', 'Bicycle', 'Manuever', 'Enviroment', ...
%     '-append')

% delete the gui
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
        set(hObject, 'Enable', 'Off')
        set(hObject, 'String', 'Connecting...')
        set(hObject, 'BackgroundColor', 'Yellow')
        set(handles.VNavComPortEditText, 'Enable', 'Off')

        % grab the current parameters and store them
        handles = store_current_parameters(handles);

        % see if the port is already open, close it if so
        close_port(handles.par.VNavComPort)

        % create the serial port
        handles.s = serial(handles.par.VNavComPort);
        display_hr()
        display('Serial port created, here are the initial properties:')
        set(handles.s, 'InputBufferSize', 512*6)
        get(handles.s) % display the attributes of the port
        display_hr()

        % open the serial port
        fopen(handles.s);
        display_hr()
        display('Serial port is open')
        display_hr()

        % determine the VNav baud rate and set the serial port baud rate to
        % match
        CurrentBaudRate = determine_vnav_baud_rate(handles.s);
        set(handles.s, 'BaudRate', CurrentBaudRate)

        % turn the async off on the VectorNav
        set_async(handles.s, '0')

        set_baudrate(handles.s, handles.par.BaudRate, handles);

        % connect to the NI USB-6218
        handles.ai = analoginput('nidaq', 'Dev1');

        % configure the DAQ
        set(handles.ai, 'InputType', 'SingleEnded') % Differential is default

        % NI channels
        channelnames = fieldnames(handles.InputPairs);
        % important that this comes after set(InputType)
        handles.chan = addchannel(handles.ai, 0:length(channelnames)-1);

        % display the daq's attributes
        get(handles.ai)

        set(hObject, 'Enable', 'On')
        set(hObject, 'String', sprintf('Disconnect'))
        set(hObject, 'BackgroundColor', 'Red')
        set(handles.DisplayButton, 'Enable', 'On')
        set(handles.RecordButton, 'Enable', 'On')
        set(handles.TareButton, 'Enable', 'On')
        enable_parameters(handles, 'On')

    case 0.0 % disconnect
        % tells the graph loop to stop
        handles.stopgraph = 1;

        set(hObject, 'String', 'Connect')
        set(hObject, 'BackgroundColor', 'Green')
        set(handles.DisplayButton, 'Enable', 'Off')
        set(handles.RecordButton, 'Enable', 'Off')
        set(handles.TareButton, 'Enable', 'Off')

        if strcmp(get(handles.ai, 'Running'), 'On')
            stop(handles.ai)
        end

        % reset the daq (delete any daq objects)
        daqreset

        % reset to factory settings
        display_hr()
        display('Starting factory reset')
        response = send_command(handles.s, 'VNRFS');
        display('Reset to factory')
        display(sprintf(response))
        display(sprintf('%d bytes in input buffer after reseting to factory', get(handles.s, 'BytesAvailable')))
        display_hr()

        % close the VectorNav connection
        fclose(handles.s)
        display_hr()
        display('Serial port is closed')
        display_hr()

        enable_parameters(handles, 'Off')
        set(handles.VNavComPortEditText, 'Enable', 'On')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in RiderPopupmenu.
function RiderPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to RiderPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns RiderPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from RiderPopupmenu


% --- Executes on selection change in SpeedPopupmenu.
function SpeedPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SpeedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SpeedPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpeedPopupmenu


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

add_to_popupmenu(hObject, handles)


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

handles = store_current_parameters(handles);
[handles, success] = set_vnav_sample_rate(handles);
handles = store_current_parameters(handles);

guidata(hObject, handles)

function NISampleRateEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NISampleRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NISampleRateEditText as text
%        str2double(get(hObject,'String')) returns contents of NISampleRateEditText as a double

handles = store_current_parameters(handles);
handles = set_ni_samples_per_trigger(handles);

guidata(hObject, handles)

function DurationEditText_Callback(hObject, eventdata, handles)
% hObject    handle to DurationEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DurationEditText as text
%        str2double(get(hObject,'String')) returns contents of DurationEditText as a double

handles = store_current_parameters(handles);
handles = set_ni_samples_per_trigger(handles);

guidata(hObject, handles)

function VNavComPortEditText_Callback(hObject, eventdata, handles)
% hObject    handle to VNavComPortEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VNavComPortEditText as text
%        str2double(get(hObject,'String')) returns contents of VNavComPortEditText as a double


function trigger_callback(obj, events, handles)

display('Trigger called')

set(handles.RecordButton, 'String', 'Recording')

% set the async type and turn it on
set_async(handles.s, '14')

% record data
for i = 1:handles.par.Duration
    for j = 1:handles.par.VNavSampleRate
        handles.par.VNavDataText{(i-1)*handles.par.VNavSampleRate+j} = fgets(handles.s);
    end
    display(sprintf('Data taken for %d seconds', i))
end

% turn the async off on the VectorNav
set_async(handles.s, '0')

obj.UserData = handles.VNavDataText;
display('VN data done')

function baudrate = determine_vnav_baud_rate(s)
% Returns the baudrate that the VectorNav is set to or NaN if it can't be
% determined.
% s : serial port object for the VectorNav

baudrates = [9600 19200 38400 57600 115200 128000 230400 460800 921600];

baudrate = NaN;

% set the timeout property low so the search goes fast
DefaultTimeout = get(s, 'Timeout');
set(s, 'Timeout', 0.1)

for i = 1:length(baudrates)
    % set the serial object baudrate
    s.BaudRate = baudrates(i);
    % first set the async to off
    set_async(s, '0')
    % flush the buffer
    flush_buffer(s)
    display(sprintf('%d bytes in input buffer after turning async off and flushing', get(s, 'BytesAvailable')))
    display_hr()
    % see if it will return the version number
    response = send_command(s, 'VNRRG,01');
    if strcmp(response, sprintf('$VNRRG,01,VN-100_v4*47\r\n'))
        % then the baudrate is correct and we should save it
        baudrate = baudrates(i);
        display(sprintf('The VNav baud rate is %d', baudrate))
        break
    end
end

set(s, 'Timeout', DefaultTimeout)

function response = send_command(s, command)
% Returns the latest response from the input buffer after the issued
% command. Response will not necessarily deliver the correct response when
% async is off.
%
% Parameters
% ----------
% s : serial port object
%   The object should be connected to the VectorNav
% command : string
%   One of the accepted ASCII commands for the VectorNav not including the '$',
%   '*' or checksum.
%
% Returns
% -------
% response : string
%   The full response from the VectorNav including the '$', '*' and checksum.

fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
pause(0.1)
response = fgets(s);

function flush_buffer(s)
% Flushes the serial port input buffer.
%
% Parameters
% ----------
% s : serial port object

while get(s, 'BytesAvailable') > 0
    flushinput(s)
    display('Flushed the input buffer')
end

function close_port(comport)
% Checks to see if comport is already open, if so it closes it.
%
% Parameters
% ----------
% comport : string
%   Comport name such as 'COM3'.

ports = instrfind; % get a list of the ports
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

set(handles.LoadButton, 'Enable', 'Off')
set(handles.RecordButton, 'Enable', 'Off')
set(handles.DisplayButton, 'Enable', 'Off')

set(hObject, 'String', 'Taring')

response = send_command(handles.s, 'VNTAR');

if strcmp(response, sprintf('$VNTAR*5F\r\n'))
    display('Device was tared')
else
    display('Device did not tare')
end

set(handles.LoadButton, 'Enable', 'On')
set(handles.RecordButton, 'Enable', 'On')
set(handles.DisplayButton, 'Enable', 'On')

set(hObject, 'String', 'Tare')

% --- Executes on button press in RecordButton.
function RecordButton_Callback(hObject, eventdata, handles)
% hObject    handle to RecordButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RecordButton

% make sure you can't click things while the recording is happening
set(handles.LoadButton, 'Enable', 'Off')
set(handles.DisplayButton, 'Enable', 'Off')
set(handles.TareButton, 'Enable', 'Off')
set(handles.RecordButton, 'Enable', 'Off')

% make sure the run id is set correctly
set_run_id(handles);

% make sure all the parameters are current
handles = store_current_parameters(handles);

% set the baudrate on the VNav and the laptop
set_baudrate(handles.s, handles.par.BaudRate)

% set the VectorNavsamplerate
[handles, success] = set_vnav_sample_rate(handles, ...
    handles.par.VNavSampleRate);

% initialize the VectorNav data
handles.VNavData = zeros(handles.par.VNavNumSamples, 12); % YMR
handles.VNavDataText = cell(handles.par.VNavNumSamples, 1);

handles = set_ni_samples_per_trigger(handles);

% trigger details
set_trigger(handles)

% store parameters again
handles = store_current_parameters(handles);

% start up the DAQ
start(handles.ai)
display('DAQ started, waiting for trigger...')
set(hObject, 'String', 'Waiting for trigger...')
wait(handles.ai, handles.par.Wait) % give the person some time to hit the button

set(handles.RecordButton, 'String', 'Processing')

% get the data from both devices
handles.NIData = getdata(handles.ai);
handles.VNavDataText = get(handles.ai, 'UserData');

stop(handles.ai)

% parse the text data and return numerical values
handles = parse_vnav_text_data(handles);

save_data(handles)

plot_data(handles)

enable_graph_buttons(handles, 'On')

set(hObject, 'String', 'Record')
set(handles.LoadButton, 'Enable', 'On')
set(handles.DisplayButton, 'Enable', 'On')
set(handles.TareButton, 'Enable', 'On')
set(handles.RecordButton, 'Enable', 'On')

guidata(hObject, handles)

function WaitEditText_Callback(hObject, eventdata, handles)
% hObject    handle to WaitEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WaitEditText as text
%        str2double(get(hObject,'String')) returns contents of WaitEditText as a double

handles.par.Wait = str2double(get(hObject,'String'));

guidata(hObject, handles)

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

function handles = parse_vnav_text_data(handles)

%Create parse string
ps = '%*6c';
for i=1:size(handles.VNavData, 2)
    ps = [ps ',%g'];
end

% process the text data
for i=1:handles.vnnumsamples
    try
        handles.VNavData(i, :) = sscanf(handles.VNavDataText{i}, ps);
    catch
        handles.VNavData(i, :) = NaN*ones(size(handles.VNavData(i, :)));
        display(sprintf('%d is a bad one: %s', i, handles.VNavDataText{i}))
    end
end

function enable_parameters(handles, state)
% Enables (on or off) parameters that should be set only when the VNav and NI
% DAQ are disconnected.
%
% Parameters
% ----------
% handles : structure
%   guidata
% state : string
%   'On' or 'Off'

set(handles.DurationEditText, 'Enable', state)
set(handles.NISampleRateEditText, 'Enable', state)
set(handles.VNavSampleRateEditText, 'Enable', state)
set(handles.WaitEditText, 'Enable', state)
set(handles.BaudRateEditText, 'Enable', state)

function plot_data(handles)
% plots the data that is currently stored in handles.VNavData and
% handles.NIData to the graph in the gui

% find out if the graph is raw or scaled data
switch get(handles.ScaledRawButton, 'Value')
    case 0.0
        legtype = 'RawLegends';
    case 1.0
        legtype = 'ScaledLegends';
end

% set the plot axes to the graph
axes(handles.Graph)

% see what graphs buttons are pressed
ButtonName = get(get(handles.GraphTypeButtonGroup, 'SelectedObject'), 'Tag');

if strcmp(ButtonName, 'VnavMomentButton')
    plot(handles.VNavData)
else
    % create a vector with the analog input numbers for this graph
    datavals = zeros(1, length(handles.(legtype).(ButtonName)));
    for i = 1:length(handles.(legtype).(ButtonName))
        input = char(handles.(legtype).(ButtonName)(i));
        datavals(i) = handles.InputPairs.(input);
    end
    plot(handles.nidata(:, datavals+1))
end
legend(handles.(legtype).(ButtonName))

function set_run_id(handles)
% Sets the run id to a number that isn't already in the data directory.
% handles : structure with handles and user data

dirinfo = what('data/');
MatFiles = dirinfo.mat;

if length(MatFiles) == 0 % if there are no mat files
    set(handles.RunIDEditText, 'String', '00000')
else % make new sequential run id
    filelist = sort(dirinfo.mat);
    lastfile = filelist{end}; % get the last file
    lastnum = str2double(lastfile(1:end-4)); % number of the last file
    newnum = num2str(lastnum + 1);
    % pad with zeros
    for i = 1:5-length(newnum)
        newnum = ['0' newnum];
    end
    set(handles.RunIDEditText, 'String', newnum)
end


% --- Executes during object creation, after setting all properties.
function NotesEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NotesEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

handles.par.VNavComPort = get(hObject, 'String')


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
function RunIDEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RunIDEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
function ManueverPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManueverPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EnvironmentPopupmenu.
function EnvironmentPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EnvironmentPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns EnvironmentPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EnvironmentPopupmenu


% --- Executes during object creation, after setting all properties.
function EnvironmentPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EnvironmentPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NewEnvironmentEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewEnvironmentEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewEnvironmentEditText as text
%        str2double(get(hObject,'String')) returns contents of NewEnvironmentEditText as a double

add_to_popupmenu(hObject, handles)

% --- Executes during object creation, after setting all properties.
function NewEnvironmentEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewEnvironmentEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function enable_graph_buttons(handles, state)

buttons = fieldnames(handles.RawLegends);
for i = 1:length(buttons)
    set(handles.(buttons{i}), 'Enable', state)
end

function save_data(handles)
% save the data to file

save(['data\' handles.par.RunID '.mat'], ...
     '-struct', 'handles.par')

save(['data\' handles.par.RunID '.mat'], ...
      'handles.VNData', 'handles.VNDataText', 'handles.NIData', ...
      '-append')

function [handles, success] = set_vnav_sample_rate(handles)
% set the samplerate
% rate : 
% Returns
% success : 0 or 1
%           0 : failed a setting the rate
%           1 : success a setting the rate

PossibleRates = [1 2 4 5 10 20 25 40 50 100 200];

rate = handles.par.VNavSampleRate;

if find(PossibleRates==rate)
    response = send_command(handles.s, ['VNWRG,07,' num2str(rate)]);
    display_hr()
    display('VNav sample rate is now set to:')
    display(sprintf(response))
    display(sprintf('%d bytes in input buffer after setting the sample rate', get(handles.s, 'BytesAvailable')))
    display_hr()
    success = 1;
else
    display(sprintf('%d is an invalid rate\n', rate))
    display_hr()
    display('Valid rates are:')
    display(PossibleRates)
    response = send_command(handles.s, 'VNRRG,07');
    display('VNav sample rate is currently set to:')
    display(sprintf(response))
    display_hr()
    success = 0;
    parse = sscanf(response, '%*6c,%g,%g');
    set(handles.VNavSampleRateEditText, 'String', num2str(parse(2)))
end

function display_hr()
display(['--------------------------------------' ...
         '-------------------------------------'])

function handles = set_ni_samples_per_trigger(handles)
duration = handles.par.Duration;
rate = handles.par.NISampleRate;

set(handles.ai, 'SampleRate', rate)
actualrate = get(handles.ai, 'SampleRate');
set(handles.ai, 'SamplesPerTrigger', duration*actualrate)

handles.par.NISampleRate = actualrate;
handles.par.NINumSamples = get(handles.ai, 'SamplesPerTrigger');

set(handles.NISampleRateEditText, 'String', num2str(actualrate))
display_hr()
display(sprintf('Duration is now set to %d', duration))
display(sprintf('NI sample is now set to %d hz', actualrate))
display(sprintf('NI samples per trigger now set to %d', get(handles.ai, 'SamplesPerTrigger')))
display_hr()

handles = store_current_parameters(handles);

function set_trigger(handles)
% trigger details
set(handles.ai, 'TriggerType', 'Software')
set(handles.ai, 'TriggerChannel', handles.chan(1))
set(handles.ai, 'TriggerCondition', 'Rising')
set(handles.ai, 'TriggerConditionValue', 4.9)
set(handles.ai, 'TriggerDelay', 0.00)
set(handles.ai, 'TriggerFcn', {@trigger_callback, handles})

function set_baudrate(s, baudrate, handles)
% set the baudrate on the VNav and the laptop

BaudRates = [9600 19200 38400 57600 115200 128000 230400 460800 921600];

if find(BaudRates==baudrate)
    response = send_command(s, ['VNWRG,05,' num2str(baudrate)]);
    set(s, 'BaudRate', baudrate) % set the laptop baud rate to match
    display_hr()
    display('VNav baud rate is now set to:')
    display(sprintf(response))
    display(sprintf('%d bytes in input buffer after setting the baud rate', get(s, 'BytesAvailable')))
    display_hr()
else
    display(sprintf('%d is an invalid baud rate\n', baudrate))
    display_hr()
    display('Valid rates are:')
    display(BaudRates)
    response = send_command(s, 'VNRRG,05');
    display('VNav baud rate is currently set to:')
    display(sprintf(response))
    display_hr()
    parse = sscanf(response, '%*6c,%g,%g');
    set(handles.BaudRateEditText, 'String', num2str(parse(2)))
end

function set_async(s, value)
% turn the async off on the VectorNav
% value : string e.g. '0' for off
send_command(s, ['VNWRG,06,' value]);
pause(0.1)
flush_buffer(s)
display_hr()
display('The VectorNav async mode is off')
display(sprintf('%d bytes in input buffer after turning async off and flushing', get(s, 'BytesAvailable')))
display_hr()

function handles = store_current_parameters(handles)
% Cycles through each of the user input parameters and stores there current
% values in a structure.
par = struct();

menus = {'Rider' 'Speed' 'Bicycle' 'Manuever' 'Environment'};
type = {'String' 'Double' 'String' 'String' 'String'};

% for each popupmenu
for i = 1:length(menus)
    list = get(handles.([menus{i} 'Popupmenu']), 'String');
    % if the popupmenu is not a cell then make it one
    if iscell(list) ~= 1
        list = {list};
    end
    if strcmp(type{i}, 'Double')
        par.(menus{i}) = ...
            str2double(list{get(handles.([menus{i} 'Popupmenu']), ...
                                          'Value')});
    elseif strcmp(type{i}, 'String')
        par.(menus{i}) = ...
            list{get(handles.([menus{i} 'Popupmenu']), 'Value')};
    end
end

editboxes = {'RunID', 'Notes', 'Duration', 'NISampleRate', ...
             'VNavSampleRate', 'VNavComPort', 'Wait', 'BaudRate'};
type = {'Double', 'String', 'Double', 'Double', 'Double', ...
        'String', 'Double', 'Double'};

for i = 1:length(editboxes)
    if strcmp(type{i}, 'Double')
         par.(editboxes{i}) = ...
             str2double(get(handles.([editboxes{i} 'EditText']), ...
                                     'String'));
    elseif strcmp(type{i}, 'String')
        par.(editboxes{i}) = get(handles.([editboxes{i} 'EditText']), ...
                                          'String');
    end
end

par.VNavNumSamples = par.Duration*par.VNavSampleRate;
par.NINumSamples = par.Duration*par.NISampleRate;

handles.par = par;

function BaudRateEditText_Callback(hObject, eventdata, handles)
% hObject    handle to BaudRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaudRateEditText as text
%        str2double(get(hObject,'String')) returns contents of BaudRateEditText as a double

handles = store_current_parameters(handles);
set_baudrate(handles.s, handles.par.BaudRate, handles);
handles = store_current_parameters(handles);

guidata(hObject, handles)

% --- Executes during object creation, after setting all properties.
function BaudRateEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaudRateEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function add_to_popupmenu(hObject, handles)
% get the name of the new menu item
newitem = get(hObject, 'String');

% NewBlankEditText
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');

menu = tag(4:begin-1);

% get the items in the popmenu
items = get(handles.([menu 'Popupmenu']), 'String');

% if the popupmenu is not a cell then make it one
if iscell(items) ~= 1
    items = {items};
end

% how many are already in the list
number = length(items);

% add the new item to the end of the list
items{number + 1} = newitem;

% rewrite the popupmenu and set the value to the new item
set(handles.([menu 'Popupmenu']), 'String', items)
set(handles.([menu 'Popupmenu']), 'Value', number + 1)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

function populate_gui(handles)
% populate the gui with either the default parameters or the appended ones

dirinfo = what() % get the matlab files in the current directory
% check for an AppendedParamters.mat and load, otherwise load the default
if sum(ismember(dirinfo.mat, 'AppendedParameters.mat'))
    load('AppendedParameters.mat')
else
    load('DefaultParameters.mat')
end

EditTexts = {'RunID' 'Notes' 'Duration' 'NISampleRate'
             'VNavSampleRate' 'VNavComport' 'BaudRate' 'Wait'}

Popupmenus = {'Rider' 'Speed' 'Bicycle' 'Manuever' 'Environment'}

for i = 1:length(EditTexts)
    set(handles.([EditTexts{i} 'EditText']), 'String', eval(EditTexts{i}))
end

for i = 1:length(Popupmenus)
    set(handles.([Popupmenus{i} 'Popupmenu']), 'String', eval(Popupmenus{i}))
end

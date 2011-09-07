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

% Last Modified by GUIDE v2.5 22-Feb-2011 13:55:20

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
default_populate_gui(handles)

% update the run id number
set_run_id(handles)

% this is what is plugged into each analog input on the NI USB-6218
handles.InputPairs = struct('PushButton',          0, ...
                            'SteerPotentiometer',  1, ...
                            'HipPotentiometer',    2, ...
                            'LeanPotentiometer',   3, ...
                            'TwistPotentiometer',  4, ...
                            'SteerRateGyro',       5, ...
                            'WheelSpeedMotor',     6, ...
                            'FrameAccelZ',         7, ...
                            'FrameAccelY',         8, ...
                            'FrameAccelX',         9, ...
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
                            'FiveVolts',          23, ...
                            'RollPotentiometer',  24);

% graph legends
% the struct command doesn't seem to like values of different length so I
% had to put all the cells in double brackets
handles.RawLegends = ...
    struct('PotAngleButton', {{'SteerPotentiometer'
                               'HipPotentiometer'
                               'LeanPotentiometer'
                               'TwistPotentiometer'
                               'RollPotentiometer'}}, ...
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
handles.ScaledLegends = ...
    struct('PotAngleButton', {{'Steer Angle'
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
handles.UnfilteredRawLegends = handles.RawLegends;
handles.UnfilteredRawLegends.VnavMomentButton = {'Mag X'
                                                 'Mag Y'
                                                 'Mag Z'
                                                 'Acceleration X'
                                                 'Acceleration Y'
                                                 'Acceleration Z'
                                                 'Angular Rate X'
                                                 'Angular Rate Y'
                                                 'Angular Rate Z'
                                                 'Temperature'};

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

handles.par.Notes = get(hObject, 'String');

guidata(hObject, handles)


function NewSpeedEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpeedEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewSpeedEditText as text
%        str2double(get(hObject,'String')) returns contents of NewSpeedEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the name of the popup menu
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');
menu = tag(4:begin-1);

add_to_popupmenu(newitem, menu, handles)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

handles.par.Speed = str2double(get(hObject, 'String'));

guidata(hObject, handles)

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

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the name of the popup menu
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');
menu = tag(4:begin-1);

add_to_popupmenu(newitem, menu, handles)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

handles.par.Rider = get(hObject, 'String');

guidata(hObject, handles)


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

% get the name of the popup menu
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');
menu = tag(4:begin-1);

add_to_popupmenu(newitem, menu, handles)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

handles.par.Bicycle = get(hObject, 'String');

guidata(hObject, handles)

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
Rider = sort(get(handles.RiderPopupmenu, 'String'));
Speed = sort(get(handles.SpeedPopupmenu, 'String'));
Bicycle = sort(get(handles.BicyclePopupmenu, 'String'));
Maneuver = sort(get(handles.ManeuverPopupmenu, 'String'));
Environment = sort(get(handles.EnvironmentPopupmenu, 'String'));

% make a copy of the default parameters file
copyfile('DefaultParameters.mat', 'AppendedParameters.mat')

% overwrite popup menu data
save('AppendedParameters.mat', ...
    'Rider', 'Speed', 'Bicycle', 'Maneuver', 'Environment', ...
    '-append')

build_run_list()

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
        set(handles.s, 'InputBufferSize', 512*10)
        get(handles.s) % display the attributes of the port
        display_hr()

        % open the serial port
        fopen(handles.s);
        display_hr()
        display('Serial port is open')
        display_hr()

        % determine the VNav baud rate and set the serial port baud rate to
        % match
        CurrentBaudRate = determine_vnav_baud_rate(handles.s)
        set(handles.s, 'BaudRate', CurrentBaudRate)

        % turn the async off on the VectorNav
        set_async(handles.s, '0')

        set_baudrate(handles.s, handles.par.BaudRate, handles);

        % get Model Number, Hardware Revision, Serial Number, Firmware Version
        handles.par.ModelNumber = send_command(handles.s, 'VNRRG,01');
        handles.par.HardwareRevision = send_command(handles.s, 'VNRRG,02');
        handles.par.SerialNumber = send_command(handles.s, 'VNRRG,03');
        handles.par.FirmwareVersion = send_command(handles.s, 'VNRRG,04');

        display_hr()
        display('Details of the VN-100')
        display(handles.par.ModelNumber)
        display(handles.par.HardwareRevision)
        display(handles.par.SerialNumber)
        display(handles.par.FirmwareVersion)
        display_hr()

        % rotate the reference frame from the VectorNav to the body fixed
        % frame used in our models (positive z is aligned with the steer
        % axis tube and pointing down, positive x is normal to the steer
        % axis, pointing forward and in the plane of symmetry of the
        % bicycle, positive y follows and is normal to x and y pointing to
        % the right sideo the bicycle
        handles.par.ReferenceFrameRotation = ...
            send_command(handles.s, 'VNWRG,26,1,0,0,0,0,1,0,-1,0');

        % rotate the reference frame from the VectorNav to the body fixed
        % frame that aligns with the benchmark bicycle in the upright
        % configuration
%         a = 37.943; % rear wheel offset [in]
%         b = 1.8825; % front wheel offset [in]
%         c = 13.521; % steer axis length [in]
%         lambda = atan(c/(a+b)); % steer axis tilt [rad]
%         clam = num2str(cos(lambda));
%         nclam = num2str(-cos(lambda));
%         nslam = num2str(-sin(lambda));
%         handles.par.ReferenceFrameRotation = ...
%             send_command(handles.s, ['VNWRG,26,' ...
%                                      clam ',' nslam ',0' ...
%                                      ',0,0,1,' ...
%                                      nslam ',' nclam ',0']);

        display_hr()
        display('The Reference Frame Rotation matrix is:')
        display(handles.par.ReferenceFrameRotation)
        display_hr()

        % connect to the NI USB-6218
        handles.ai = analoginput('nidaq', 'Dev1');

        % configure the DAQ
        set(handles.ai, 'InputType', 'SingleEnded') % Differential is default

        % NI channels
        channelnames = fieldnames(handles.InputPairs);
        % important that this comes after set(ai, 'InputType', ...)
        handles.chan = addchannel(handles.ai, ...
                                  0:length(channelnames)-1, ...
                                  channelnames);

        % set all the input ranges
        set(handles.chan, 'InputRange', [-5 5])
        % set the wheel speed, pull force, and steer torque
        set(handles.chan(7), 'InputRange', [-10 10])
        set(handles.chan(11), 'InputRange', [-10 10])
        set(handles.chan(22), 'InputRange', [-10 10])

        % display the daq's attributes
        get(handles.ai)

        set(hObject, 'Enable', 'On')
        set(hObject, 'String', sprintf('Disconnect'))
        set(hObject, 'BackgroundColor', 'Red')
        set(handles.RecordButton, 'Enable', 'On')
        set(handles.TareButton, 'Enable', 'On')
        enable_parameters(handles, 'On')

    case 0.0 % disconnect
        set(hObject, 'String', 'Connect')
        set(hObject, 'BackgroundColor', 'Green')
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
        display(sprintf('%d bytes in input buffer after reseting to factory', ...
                        get(handles.s, 'BytesAvailable')))
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

contents = get(hObject,'String');
handles.par.Rider = contents{get(hObject,'Value')};

guidata(hObject, handles)

% --- Executes on selection change in SpeedPopupmenu.
function SpeedPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to SpeedPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SpeedPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SpeedPopupmenu

contents = get(hObject,'String');
handles.par.Speed = str2double(contents{get(hObject,'Value')});

guidata(hObject, handles)


% --- Executes on selection change in BicyclePopupmenu.
function BicyclePopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to BicyclePopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BicyclePopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BicyclePopupmenu

contents = get(hObject,'String');
handles.par.Bicycle = contents{get(hObject,'Value')};

guidata(hObject, handles)


function NewManeuverEditText_Callback(hObject, eventdata, handles)
% hObject    handle to NewManeuverEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NewManeuverEditText as text
%        str2double(get(hObject,'String')) returns contents of NewManeuverEditText as a double

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the name of the popup menu
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');
menu = tag(4:begin-1);

add_to_popupmenu(newitem, menu, handles)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

handles.par.Maneuver = get(hObject, 'String');

guidata(hObject, handles)


% --- Executes on selection change in ManeuverPopupmenu.
function ManeuverPopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to ManeuverPopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ManeuverPopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ManeuverPopupmenu

contents = get(hObject,'String');
handles.par.Maneuver = contents{get(hObject,'Value')};

guidata(hObject, handles)


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

handles.par.VNavComPort = get(hObject, 'String');

guidata(hObject, handles)


function trigger_callback(obj, events, handles)
% Records data from the VectorNav when the NI DAQ is triggered.
%
% Parameters
% ----------
% obj : the analog input object
% events : structure
%   trigger event details
% handles : structure
%   contains the gui handles and user data

% mark a time stamp
handles.par.DateTime = datestr(clock);

display('Trigger called')

set(handles.RecordButton, 'String', 'Recording')
set(handles.RecordButton, 'BackgroundColor', 'Red')

% set the async type and turn it on
set_async(handles.s, num2str(handles.par.ADOT))

% record data
for i = 1:handles.par.Duration
    for j = 1:handles.par.VNavSampleRate
        handles.VNavDataText{(i-1)*handles.par.VNavSampleRate+j} = ...
            fgets(handles.s);
    end
    display(sprintf('Data recorded for %d seconds', i))
end

% turn the async off on the VectorNav
set_async(handles.s, '0')

% the trigger is anonymous so it can't return anything so store the data in the
% ai object
obj.UserData = handles;
display('VN data done')


function baudrate = determine_vnav_baud_rate(s)
% Returns the baudrate that the VectorNav is set to or NaN if it can't be
% determined.
%
% Parameters
% ----------
% s : serial port object for the VectorNav

% the possible baud rates the VectorNav can connect with
baudrates = [9600 19200 38400 57600 115200 128000 230400 460800 921600];

% intialize the baud rate
baudrate = NaN;

% set the timeout property low so the search goes fast
DefaultTimeout = get(s, 'Timeout');
set(s, 'Timeout', 0.1)

% try to connect at each baud rate
for i = 1:length(baudrates)
    % set the serial object baudrate
    s.BaudRate = baudrates(i);
    % first set the async to off
    set_async(s, '0')
    % flush the buffer
    flush_buffer(s)
    display_hr()
    display(sprintf('%d bytes in input buffer after turning async off and flushing', get(s, 'BytesAvailable')))
    display_hr()
    % see if it will return the version number
    response = send_command(s, 'VNRRG,01');
    if strcmp(response, sprintf('$VNRRG,01,VN-100_v4*47'))
        % then the baudrate is correct and we should save it
        baudrate = baudrates(i);
        display(sprintf('The VNav baud rate is %d', baudrate))
        break
    end
end

% set the Timeout back to default
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

% calculate the checksum and send the command
fprintf(s, sprintf('$%s*%s\n', command, VNchecksum(command)))
% wait a little for the response
pause(0.1)
% get the response
% the response from the VectorNav always ends in \r\n
response = fgetl(s); % fgetl removes the \n
response = sscanf(response, '%s\r');


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

set(hObject, 'String', 'Taring')

response = send_command(handles.s, 'VNTAR');

if strcmp(response, sprintf('$VNTAR*5F'))
    display('Device was tared')
else
    display('Device did not tare')
end

set(handles.LoadButton, 'Enable', 'On')
set(handles.RecordButton, 'Enable', 'On')

set(hObject, 'String', 'Tare')

function RecordButton_Callback(hObject, eventdata, handles)
% Executes on button press of RecordButton.
%
% Arguments
% ---------
% hObject : push button object
%   handle to RecordButton (see GCBO)
% eventdata : 
%   reserved - to be defined in a future version of MATLAB
% handles : structure
%   structure with handles and user data (see GUIDATA)

% give the user some feedback
set(hObject, 'BackgroundColor', 'Yellow')
set(hObject, 'String', 'Initializing')

% make sure you can't click things while the recording is happening
toggle_enable(handles, {'LoadButton', 'TareButton', 'RecordButton'}, 'Off')

toggle_enable_metadata(handles, 'Off')
toggle_enable_daq_settings(handles, 'Off')

% make sure the run id is set correctly
set_run_id(handles);

% get all the parameters from the text boxes and edit menus
handles = store_current_parameters(handles);

% set the baudrate on the VNav and the laptop
set_baudrate(handles.s, handles.par.BaudRate)

% set the VectorNavsamplerate
[handles, success] = set_vnav_sample_rate(handles);

% get the filter tuning parameters
handles.par.FilterTuningParameters = send_command(handles.s, 'VNRRG,22');

% set the filter tuning parameters
% tune out magnetometers
handles.par.FilterTuningParameters = ...
    send_command(handles.s, ...
                 'VNWRG,22,1E-8,1E-8,1E-8,1E-8,1E-1,1E-1,1E1,1E-5,1E-5,1E-5');
display_hr()
display('The filter tuning parameters are set to:')
display(handles.par.FilterTuningParameters)
display_hr()

% get the hard/soft iron parameters
handles.par.HardSoftIronParameters = ...
    send_command(handles.s, 'VNRRG,23');

display_hr()
display('The hard/soft iron parameters are set to:')
display(handles.par.HardSoftIronParameters)
display_hr()

% get the filter active tuning parameters
handles.par.FilterActiveTuningParameters = ...
    send_command(handles.s, 'VNRRG,24');

% set the filter active tuning parameters
handles.par.FilterActiveTuningParameters = ...
    send_command(handles.s, 'VNWRG,24,0.0,1.0,0.99,0.99');

display_hr()
display('The filter active tuning parameters are set to:')
display(handles.par.FilterActiveTuningParameters)
display_hr()

% get the accelerometer compensation
handles.par.AccelerometerCompensation = ...
    send_command(handles.s, 'VNRRG,25');

display_hr()
display('The accelerometer compensation is:')
display(handles.par.AccelerometerCompensation)
display_hr()

% get the accelerometer gain
handles.par.AccelerometerGain = ...
    send_command(handles.s, 'VNRRG,28');

display_hr()
display('The accelerometer gain is:')
display(handles.par.AccelerometerGain)

% initialize the VectorNav data
if handles.par.ADOT == 14
    legends = 'RawLegends';
elseif handles.par.ADOT == 253
    legends = 'UnfilteredRawLegends';
end
handles.VNavData = zeros(handles.par.VNavNumSamples, ...
                         length(handles.(legends).VnavMomentButton));
handles.VNavDataText = cell(handles.par.VNavNumSamples, 1);

% set the sample rate for the NI daq
handles = set_ni_samples_per_trigger(handles);

% trigger details
set_trigger(handles)

% start up the DAQ
start(handles.ai)
display('DAQ started, waiting for trigger...')
set(hObject, 'String', 'Waiting for trigger...')
set(hObject, 'BackgroundColor', 'Green')

% give the person some time to hit the button
wait(handles.ai, handles.par.Wait)

set(hObject, 'String', 'Processing')
set(hObject, 'BackgroundColor', 'Yellow')

% get the data from both devices
handles = get(handles.ai, 'UserData');
handles.NIData = getdata(handles.ai);

stop(handles.ai)

% parse the text data and return numerical values
handles = parse_vnav_text_data(handles);

% save the data just taken to file
save_data(handles)

% plot the data just taken
plot_data(handles)

enable_graph_buttons(handles, 'On')

set(hObject, 'String', 'Record')
set(hObject, 'BackgroundColor', [0.831 0.816 0.784])
set(handles.LoadButton, 'Enable', 'On')
set(handles.TareButton, 'Enable', 'On')
set(handles.RecordButton, 'Enable', 'On')

toggle_enable_metadata(handles, 'Off')
toggle_enable_daq_settings(handles, 'Off')

guidata(hObject, handles)

function toggle_enable(handles, tags, onOrOff)
% Toggles the ability to interact with the specified gui objects.
%
% Arugments
% ---------
% handles : structure
%   Contains the gui data.
% tags : cell array of characters
%   A list of the tags that need to be enabled/disabled.
% onOrOff : char
%   Either 'On' for enable or 'Off' for disable.

for i = 1:length(tags)
    set(handles.(tags{i}), 'Enable', onOrOff)
end

function toggle_enable_metadata(handles, onOrOff)
% Toggles the ability to interact with the menus and text boxes for the
% metadata.
%
% Arguments
% ---------
% handles : structure
%   Contains the gui data.
% onOrOff : char
%   Either 'On' or 'Off'.

tags = {'RiderPopupmenu', ...
        'SpeedPopupmenu', ...
        'BicyclePopupmenu', ...
        'ManeuverPopupmenu', ...
        'EnvironmentPopupmenu', ...
        'NotesEditText', ...
        'NewRiderEditText', ...
        'NewSpeedEditText', ...
        'NewBicycleEditText', ...
        'NewManeuverEditText', ...
        'NewEnvironmentEditText'};

toggle_enable(handles, tags, onOrOff)
    
function toggle_enable_daq_settings(handles, onOrOff)
% Toggles the ability to interact with the menus and text boxes for the
% metadata.
%
% Arguments
% ---------
% handles : structure
%   Contains the gui data.
% onOrOff : char
%   Either 'On' or 'Off'.

tags = {'WaitEditText', ...
        'DurationEditText', ...
        'VNavSampleRateEditText', ...
        'NISampleRateEditText', ...
        'BaudRateEditText'};

toggle_enable(handles, tags, onOrOff)

function WaitEditText_Callback(hObject, eventdata, handles)
% hObject    handle to WaitEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WaitEditText as text
%        str2double(get(hObject,'String')) returns contents of WaitEditText as a double

handles.par.Wait = str2double(get(hObject,'String'));

guidata(hObject, handles)


function WaitEditText_CreateFcn(hObject, eventdata, handles)
% Executes during object creation, after setting all properties.
%
% Parameters
% ----------
% hObject    handle to WaitEditText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = parse_vnav_text_data(handles)
% Converts the ASCII string data from the VectorNav to Matlab arrays.
%
% Parameters
% ----------
% handles : structure
%   Handles to gui objects and user data.
%
% Returns
% -------
% handles : structure
%   Handles to gui objects and user data.

% create parse string
ps = '%*6c';
for i=1:size(handles.VNavData, 2)
    ps = [ps ',%g'];
end

% process the text data
for i=1:handles.par.VNavNumSamples
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
% Plots the data that is currently stored in handles.VNavData and
% handles.NIData to the graph in the gui.
%
% Parameters
% ----------
% handles : structure
%   Handles to gui objects and user data.

% find out if the graph is raw or scaled data
switch get(handles.ScaledRawButton, 'Value')
    case 0.0
        if handles.par.ADOT == 14
            legtype = 'RawLegends';
        elseif handles.par.ADOT == 253
            legtype = 'UnfilteredRawLegends';
        end
    case 1.0
        legtype = 'ScaledLegends';
end

% set the plot axes to the graph
axes(handles.Graph)

% see what graphs buttons are pressed
ButtonName = get(get(handles.GraphTypeButtonGroup, 'SelectedObject'), 'Tag');

% grab the legend titles for this button and legend type
legendlist = handles.(legtype).(ButtonName);

if strcmp(ButtonName, 'VnavMomentButton')
    timestep = handles.par.VNavSampleRate^(-1);
    plot(timestep:timestep:handles.par.Duration, handles.VNavData)
else
    % create a vector with the analog input numbers for this graph
    datavals = zeros(1, length(legendlist));
    for i = 1:length(legendlist)
        % a vector with channel numbers that correspond to the legend name
        datavals(i) = handles.InputPairs.(legendlist{i});
    end
    % this is a hack because early runs didn't have the roll pot signal, it
    % adds a data line with NaNs to NIData
    [m, n] = size(handles.NIData);
    if datavals(end)+1 > n
        handles.NIData(:, n+1) = NaN*ones(m, 1);
    end
    % plot the data
    timestep = handles.par.NISampleRate^(-1);
    plot(timestep:timestep:handles.par.Duration, ...
         handles.NIData(:, datavals+1))
    ylabel('Voltage [V]')
end
xlabel('Time [s]')
legend(legendlist)


function set_run_id(handles)
% Sets the run id to a number that isn't already in the data directory.
% handles : structure with handles and user data

dirinfo = what('data/');
MatFiles = dirinfo.mat;

if isempty(MatFiles) % if there are no mat files
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
function NewManeuverEditText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NewManeuverEditText (see GCBO)
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
function ManeuverPopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManeuverPopupmenu (see GCBO)
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
contents = get(hObject,'String');
handles.par.Environment = contents{get(hObject,'Value')};

guidata(hObject, handles)

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

% get the name of the new menu item
newitem = get(hObject, 'String');

% get the name of the popup menu
tag = get(hObject, 'Tag');
begin = strfind(tag, 'EditText');
menu = tag(4:begin-1);

add_to_popupmenu(newitem, menu, handles)

% put the old text back in the edit box
set(hObject, 'String', ['Add a new ' lower(menu)])

handles.par.Enviroment = get(hObject, 'String');

guidata(hObject, handles)

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
% Save the data to file.
%
% Parameters
% ----------
% handles : structure
%   handles to gui objects and user data

% get the run id number and make a string padded with zeros
RunIDString = pad_with_zeros(num2str(handles.par.RunID), 5);

if handles.par.ADOT == 14
    handles.VNavCols = handles.RawLegends.VnavMomentButton;
elseif handles.par.ADOT == 253
    handles.VNavCols = handles.UnfilteredRawLegends.VnavMomentButton;
else
    handles.VNavCols = 'eeeeeeeeeeeh, you have no ADOT';
end

save(['data\' RunIDString '.mat'], '-struct', 'handles', ...
     'par', 'VNavData', 'VNavDataText', 'NIData', 'InputPairs', ...
     'VNavCols')


function [handles, success] = set_vnav_sample_rate(handles)
% Set the VectorNav sample rate
%
% Parameters
% ----------
% handles : structure
%   handles to gui objects and user data
%
% Returns
% -------
% handles : structure
%   handles to gui objects and user data
% success : integer
%   0 or 1
%   0 : failed a setting the rate
%   1 : success a setting the rate

% the VectorNav can only connect at these rates
PossibleRates = [1 2 4 5 10 20 25 40 50 100 200];

rate = handles.par.VNavSampleRate;

% if the user input rate is valid then set it, otherwise leave it as is
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
    % read what the rate is currently set to
    response = send_command(handles.s, 'VNRRG,07');
    display('VNav sample rate is currently set to:')
    display(sprintf(response))
    display_hr()
    success = 0;
    % extract the sample rate
    parse = sscanf(response, '%*6c,%g,%g');
    % set the text box and parameter value to the current setting
    set(handles.VNavSampleRateEditText, 'String', num2str(parse(2)))
    handles.par.VNavSampleRate = str2double(parse(2));
end

function display_hr()
display(['--------------------------------------' ...
         '-------------------------------------'])

function handles = set_ni_samples_per_trigger(handles)
% Sets the sample rate and samples per trigger on the NI daq box and
% updates the handles.par accordingly.
%
% Parameters
% ----------
% handles : structure
%   handles to gui objects and user data
%
% Returns
% -------
% handles : structure
%   handles to gui objects and user data

% grab the user inputed duration and sample rate
duration = handles.par.Duration;
rate = handles.par.NISampleRate;

% set the values on the device
set(handles.ai, 'SampleRate', rate)
actualrate = get(handles.ai, 'SampleRate');
set(handles.ai, 'SamplesPerTrigger', duration*actualrate)

% update the stored parameters
handles.par.NISampleRate = actualrate;
handles.par.NINumSamples = get(handles.ai, 'SamplesPerTrigger');

% update the display box
set(handles.NISampleRateEditText, 'String', num2str(actualrate))
display_hr()
display(sprintf('Duration is now set to %d', duration))
display(sprintf('NI sample is now set to %d hz', actualrate))
display(sprintf('NI samples per trigger now set to %d', ...
                get(handles.ai, 'SamplesPerTrigger')))
display_hr()

function set_trigger(handles)
% Sets the NI daq trigger details.
%
% Parameters
% ----------
% handles : structure
%   handles to gui objects and user data

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
    display(sprintf('%d bytes in input buffer after setting the baud rate', ...
                    get(s, 'BytesAvailable')))
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
display(sprintf('%d bytes in input buffer after turning async off and flushing', ...
                get(s, 'BytesAvailable')))
display_hr()

function handles = store_current_parameters(handles)
% Cycles through each of the user input parameters and stores their current
% values in a structure, par.
%
% Parameters:
% -----------
% handles : structure
%   handles to gui objects and user data
%
% Returns:
% --------
% handles : structure
%   handles to gui objects and user data

% initialize the parameter structure
if isfield(handles, 'par')
    display('Found the parameters structure, will append.')
    par = handles.par;
else
    display('Did not find parameters structure, will create new.')
    par = struct();
end

% a list of the gui menus and what type of data they are
menus = {'Rider' 'Speed' 'Bicycle' 'Maneuver' 'Environment'};
type = {'String' 'Double' 'String' 'String' 'String'};

% for each popupmenu
for i = 1:length(menus)
    % get the current popupmenu
    list = get(handles.([menus{i} 'Popupmenu']), 'String');
    % if the popupmenu is not a cell then make it one
    if iscell(list) ~= 1
        list = {list};
    end
    % grab the currently selected item in the menu and store it
    if strcmp(type{i}, 'Double')
        par.(menus{i}) = ...
            str2double(list{get(handles.([menus{i} 'Popupmenu']), ...
                                          'Value')});
    elseif strcmp(type{i}, 'String')
        par.(menus{i}) = ...
            list{get(handles.([menus{i} 'Popupmenu']), 'Value')};
    end
end

% now make a list of the edit boxes and their types
editboxes = {'RunID', 'Notes', 'Duration', 'NISampleRate', ...
             'VNavSampleRate', 'VNavComPort', 'Wait', 'BaudRate'};
type = {'Double', 'String', 'Double', 'Double', 'Double', ...
        'String', 'Double', 'Double'};

% grab the current value in the edit box and store it
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

% calculate the number of samples and store
par.VNavNumSamples = par.Duration*par.VNavSampleRate;
par.NINumSamples = par.Duration*par.NISampleRate;

% store the ADOT
if get(handles.UnfilteredCheckbox, 'Value')
    par.ADOT = 253;
else
    par.ADOT = 14;
end

% store the parameters in handles so it can be returned
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

function add_to_popupmenu(newitem, menu, handles)
% Checks a string against the current popup menu. If the string already
% exits it sets the popup menu to that string. If it doesn't exist, it adds
% it and sets the popup menu to that string.
% get the name of the new menu item
% Parameters
% ----------
% newitem : string
%   A string for the pop up menu list.
% menu : string
%   Pop up menu label. (e.g. 'Rider')
% handles : structure
%   Handles to gui objects and user data.

% get the items in the popmenu
items = get(handles.([menu 'Popupmenu']), 'String');

% if the popupmenu is not a cell then make it one
if iscell(items) ~= 1
    items = {items};
end

% if the string is already in the list
cellnum = find(ismember(items, newitem));
if cellnum
    set(handles.([menu 'Popupmenu']), 'Value', cellnum)
else
    % how many are already in the list
    number = length(items);

    % add the new item to the end of the list
    items{number + 1} = newitem;

    % rewrite the popupmenu and set the value to the new item
    set(handles.([menu 'Popupmenu']), 'String', items)
    set(handles.([menu 'Popupmenu']), 'Value', number + 1)

end

function default_populate_gui(handles)
% populate the gui with either the default parameters or the appended ones

dirinfo = what(); % get the matlab files in the current directory
% check for an AppendedParamters.mat and load, otherwise load the default
if sum(ismember(dirinfo.mat, 'AppendedParameters.mat'))
    load('AppendedParameters.mat')
else
    load('DefaultParameters.mat')
end

EditTexts = {'RunID' 'Notes' 'Duration' 'NISampleRate' ...
             'VNavSampleRate' 'VNavComPort' 'BaudRate' 'Wait'};

Popupmenus = {'Rider' 'Speed' 'Bicycle' 'Maneuver' 'Environment'};

for i = 1:length(EditTexts)
    set(handles.([EditTexts{i} 'EditText']), 'String', eval(EditTexts{i}))
end

for i = 1:length(Popupmenus)
    set(handles.([Popupmenus{i} 'Popupmenu']), 'String', eval(Popupmenus{i}))
end

function handles = populate_gui(handles, filename)
% Populate the gui with data from a file.
%
% Parameters
% ----------
% handles : structure
%   handles to gui objects and user data
% filename : string
%   path to the file with the data for populating the gui
%
% Returns
% -------
% handles : structure
%   handles to gui objects and user data

load(filename)

handles.par = par;
handles.NIData = NIData;
handles.VNavData = VNavData;
handles.VNavDataText = VNavDataText;

EditTexts = {'RunID' 'Notes' 'Duration' 'NISampleRate' 'VNavSampleRate' ...
             'VNavComPort' 'BaudRate' 'Wait'};
type = {'Double', 'String', 'Double', 'Double', 'Double', ...
        'String', 'Double', 'Double'};
for i = 1:length(EditTexts)
    if strcmp(type{i}, 'String')
        text = handles.par.(EditTexts{i});
    elseif strcmp(type{i}, 'Double')
        text = num2str(handles.par.(EditTexts{i}));
    end
    if strcmp(EditTexts{i}, 'RunID')
        text = pad_with_zeros(text, 5);
    end
    set(handles.([EditTexts{i} 'EditText']), 'String',...
        text)
end

Popupmenus = {'Rider' 'Speed' 'Bicycle' 'Maneuver' 'Environment'};
type = {'String' 'Double' 'String' 'String' 'String'};

for i = 1:length(Popupmenus)
    if strcmp(type{i}, 'String')
        newitem = handles.par.(Popupmenus{i});
    elseif strcmp(type{i}, 'Double')
        newitem = num2str(handles.par.(Popupmenus{i}));
    end
    add_to_popupmenu(newitem, Popupmenus{i}, handles)
end

if handles.par.ADOT == 14
    set(handles.UnfilteredCheckbox, 'Value', 0)
elseif handles.par.ADOT == 253
    set(handles.UnfilteredCheckbox, 'Value', 1)
end

% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(hObject, 'Enable', 'Off')
[filename, path] = uigetfile('*.mat', 'Select a run', 'data/');
if filename==0
else
    handles = populate_gui(handles, [path filename]);
    plot_data(handles)
    enable_graph_buttons(handles, 'On')
    guidata(hObject, handles)
end
set(hObject, 'Enable', 'On')


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

RunID = pad_with_zeros(num2str(handles.par.RunID), 5);
question = sprintf('Do you really want to overwrite run %s?', RunID);
button = questdlg(question, 'Box', 'Yes', 'No', 'No');

switch button
    case 'Yes'
        save_data(handles)
    case 'No'
        % do nothing
    otherwise
        % do nothing
end

function num = pad_with_zeros(num, digits)
% Adds zeros to the front of a string needed to produce the number of
% digits.
%
% Parameters
% ----------
% num : string
%   A string representation of a number (i.e. '25')
% digits : integer
%   The total number of digits desired.
%
% If digits = 4 and num = '25' then the function returns '0025'.

for i = 1:digits-length(num)
    num = ['0' num];
end


% --- Executes on button press in UnfilteredCheckbox.
function UnfilteredCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to UnfilteredCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UnfilteredCheckbox

function build_run_list()
% Checks the directory for the database csv file and creates or updates it
% with the latest runs.

directory = 'data';
filename = 'runlist.txt';

% get a list of the mat files in the directory
dirinfo = what(directory);
matfiles = sort(dirinfo.mat);

% get the column names from the newest file
try
    load([directory filesep matfiles{end}])
    colnames = sort(fieldnames(par));
    clear NIData VNavData VNavDataText par
catch
    display(['There are no files in the directory.' ...
             'Save at least one run, then close'])
end

% if the file exists
if exist([pwd filesep directory filesep filename], 'file')
    display('Runlist.txt exists so just append.')
    % find the column number for RunID
    fid = fopen([pwd filesep directory filesep filename], 'r');
    firstline = fgetl(fid);
    fclose(fid);
    firstlinesplit = regexp(firstline, ';', 'split');
    [tf, index] = ismember('RunID', firstlinesplit);
    % determine the run number of the last line in the file
    lastline = get_last_line([directory filesep filename]);
    splitline = regexp(lastline, ';', 'split');
    lastlineid = str2num(splitline{index});
    % get the last mat file in the directory
    lastmatfile = str2num(matfiles{end}(1:end-4));
    % make a list of files to append
    filestoappend = lastlineid+1:lastmatfile;
    % append the data to the file
    fid = fopen([directory filesep filename], 'a');
    for i=1:length(filestoappend)
        display(sprintf('Adding %s', matfiles{filestoappend(i)+1}))
        % load the mat file
        load([directory filesep matfiles{filestoappend(i)+1}])
        % for each column get the data and add to the line
        for j=1:length(colnames)
            if j==1
                try
                    line = num2str(par.(colnames{j}));
                catch
                    line = 'NA';
                end
            else
                try
                    line = [line ';' num2str(par.(colnames{j}))];
                catch
                    line = [line ';NA'];
                end
            end
        end
        fprintf(fid, '%s\n', line);
        clear line
    end
    fclose(fid);

else
    display('the file does not exist')
    fid = fopen([directory filesep filename], 'w');
    % write the header
    for i=1:length(colnames)
        if i==1
            header = colnames{i};
        else
            header = [header ';' colnames{i}];
        end
    end
    fprintf(fid, '%s\n', header);
    % write the data to the file
    for i=1:length(matfiles)
        display(sprintf('Adding %s', matfiles{i}))
        % load the mat file
        load([directory filesep matfiles{i}])
        % for each column get the data and add to the line
        for j=1:length(colnames)
            if j==1
                try
                    line = num2str(par.(colnames{j}));
                catch
                    line = 'NA';
                end
            else
                try
                    line = [line ';' num2str(par.(colnames{j}))];
                catch
                    line = [line ';NA'];
                end
            end
        end
        fprintf(fid, '%s\n', line);
        clear line
    end
    fclose(fid);
end

function lastLine = get_last_line(pathtofile)
% Returns the last line of a text file. Taken from
% http://stackoverflow.com/questions/2659375/matlab-command-to-access-the-last-line-of-each-file
fid = fopen(pathtofile,'r');     %# Open the file as a binary
lastLine = '';                   %# Initialize to empty
offset = 1;                      %# Offset from the end of file
fseek(fid,-offset,'eof');        %# Seek to the file end, minus the offset
newChar = fread(fid,1,'*char');  %# Read one character
while (~strcmp(newChar,char(10))) || (offset == 1)
  lastLine = [newChar lastLine];   %# Add the character to a string
  offset = offset+1;
  fseek(fid,-offset,'eof');        %# Seek to the file end, minus the offset
  newChar = fread(fid,1,'*char');  %# Read one character
end
fclose(fid);  %# Close the file

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

% Last Modified by GUIDE v2.5 24-Nov-2010 16:02:46

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
handles.InputPairs = struct('SteerPotentiometer',  0, ...
                            'HipPotentiometer',    1, ...
                            'LeanPotentionmeter',  2, ...
                            'TwistPotentionmeter', 3, ...
                            'SteerRateGyro',       4, ...
                            'WheelSpeedMotor',     5, ...
                            'SteerTorqueSensor',   6, ...
                            'SeatpostBridge1',     7, ...
                            'SeatpostBridge2',     8, ...
                            'SeatpostBridge3',     9, ...
                            'SeatpostBridge4',    10, ...
                            'SeatpostBridge5',    11, ...
                            'SeatpostBridge6',    12, ...
                            'RightFootBridge1',   13, ...
                            'RightFootBridge2',   14, ...
                            'LeftFootBridge1',    15, ...
                            'LeftFootBridge2',    16, ...
                            'PushButton',         17);
                            
% graph legends
% the struct command doesn't seem to like values of different length so I
% had to put all the cells in double brackets
handles.RawLegends = struct('SteerAngleButton', {{'SteerPotentiometer'
                                                  'SteerRateGyro'
                                                  'SteerTorqueSensor'
                                                  'WheelSpeedMotor'
                                                  'PushButton'}}, ...
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
                               'SeatpostAccelerationButton', {{'X'
                                                               'Y'
                                                               'Z'}}, ...
                               'FeetForceButton', {{'Seat Fx'
                                                    'Seat Fy'
                                                    'Seat Fz'
                                                    'Right Foot'
                                                    'Left Foot'}}, ...
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
        set(hObject, 'String', 'Disconnect')
        set(hObject, 'BackgroundColor', 'Red')
        % create a serial object for the VectorNav
        handles.s = VNserial('COM3');
        
        % create an analog input object for the USB-6218
        handles.ai = analoginput('nidaq','Dev1');
        
        % set the properties for data viewing
        handles.duration = 600; % seconds
        set(handles.ai,'SampleRate',100)
        ActualRate = get(handles.ai,'SampleRate');
        set(handles.ai,'SamplesPerTrigger',handles.duration*ActualRate);
        set(handles.ai,'TriggerType','Manual');
        set(handles.ai,'InputType','SingleEnded');
        handles.aichan = addchannel(handles.ai,0:17);
        
        % tells the graph loop to keep going
        handles.stopgraph = 0;
                
    case 0.0 % disconnect
        set(hObject, 'String', 'Connect')
        set(hObject, 'BackgroundColor', 'Green')
        % tells the graph loop to stop
        handles.stopgraph = 1;
        %rmfield(handles, 'ai')
        %delete(handles.ai)
        stop(handles.ai)
        daqreset
        % close the VectorNav
        VNclearports();

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
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
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

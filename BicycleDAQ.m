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

% Last Modified by GUIDE v2.5 11-Nov-2010 18:28:17

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
set(handles.GraphTypeButtonGroup,'SelectionChangeFcn',@GraphTypeButtonGroup_SelectionChangeFcn);
set(handles.ActionButtonGroup,'SelectionChangeFcn',@ActionButtonGroup_SelectionChangeFcn);

% load the VectorNav library
addpath('VectorNavLib')
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
handles.aichan = addchannel(handles.ai,0:16);

% button to keyword pairs
handles.pairs = struct('AngleButton', 'angles', ...
                       'RateButton', 'rates', ...
                       'MomentButton', 'moments', ...
                       'ForceButton', 'forces', ...
                       'AccelerationButton', 'accelerations', ...
                       'MagneticButton', 'magnetic');
% graph legends
handles.legends = struct('angles', {{'Steer Angle'
                                    'Roll Angle'
                                    'Yaw Angle'
                                    'Pitch Angle'
                                    'Hip Pot'
                                    'Lean Pot'
                                    'Twist Pot'}}, ...
                          'rates', {{'Steer Rate'
                                    'Roll Rate'
                                    'Yaw Rate'
                                    'Pitch Rate'
                                    'Wheel Rate'}}, ...
                          'forces', {{'Seat Fx'
                                     'Seat Fy'
                                     'Seat Fz'
                                     'Right Foot'
                                     'Left Foot'}}, ...
                          'moments', {{'Steer Torque'
                                      'Seat Mx'
                                      'Seat My'
                                      'Seat Mz'
                                      'Right Foot'
                                      'Left Foot'}}, ...
                          'accelerations', {{'X'
                                            'Y'
                                            'Z'}}, ...
                          'magnetic', {{'X'
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


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RawButton.
function RawButton_Callback(hObject, eventdata, handles)
% hObject    handle to RawButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RawButton



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
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
    case 'AngleButton'
        display('angles')
    case 'RateButton'
        display('angles')
    case 'AccelerationButton'
        display('accelerations')
    case 'MagneticButton'
        display('magnetic')
    case 'ForceButton'
        display('forces')
    case 'MomentButton'
        display('moments')
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
        % find out what data is being plotted
%         ButtonName = get(handles.GraphTypeButtonGroup.SelectedObject, 'Tag')
        ButtonName = get(get(handles.GraphTypeButtonGroup, 'SelectedObject'), 'Tag')
        class(ButtonName)
        handles.pairs
        % clear the graph for new data
        axes(handles.Graph)
        % plot blank data
        %keyword = get(handles.pairs, ButtonName);
        keyword = 'angles'
        data = zeros(100, length(eval(['handles.legends.' keyword])));
        lines = plot(data); % plot the raw data
        ylabel('Voltage')
        leg = legend(eval(['handles.legends.' keyword]));
%         labels = {'', '', '', '', ''};
        
        % update the plot while the data is being taken
        while (1)
            % return the latest 100 samples
            data = peekdata(handles.ai,100);
            for i = 1:length(eval(['handles.legends.' keyword]))
                set(lines(i), 'YData', data(1:length(eval(['handles.legends.' keyword])), i))
            end
%             meanData = mean(data);
%             labels{1} = sprintf('Steer Angle = %1.2f V', meanData(1));
%             labels{2} = sprintf('Steer Rate = %1.2f V', meanData(2));
%             labels{3} = sprintf('Steer Torque = %1.2f V', meanData(3));
%             labels{4} = sprintf('Wheel Speed = %1.2f V', meanData(4));
%             labels{5} = sprintf('Button = %1.2f V', meanData(5));
%             set(leg, 'String', labels)
            drawnow
        end
    case 'RecordButton'
        % records data to file
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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

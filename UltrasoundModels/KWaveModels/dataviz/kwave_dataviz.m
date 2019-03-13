function varargout = kwave_dataviz(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kwave_dataviz_OpeningFcn, ...
                   'gui_OutputFcn',  @kwave_dataviz_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function kwave_dataviz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kwave_dataviz (see VARARGIN)

handles.data = varargin{1};
handles.axes1 = axes('Position',[0.40 0.55 0.45 0.44]);
handles.axes2 = axes('Position',[0.40 0.05 0.45 0.44]);
ylim(handles.axes2,[-10,10]);
numSteps = size(handles.data,3);
sl = handles.slider_time;
set(sl, 'Min', 1);
set(sl, 'Max', numSteps);
set(sl, 'Value', 1);
set(sl, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
% Update handles structure
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes kwave_dataviz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kwave_dataviz_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_time_Callback(hObject, eventdata, handles)
   handles.t_index = int16(get(handles.slider_time,'Value'));
   plot_kwave_slice(handles)


% --- Executes during object creation, after setting all properties.
function slider_time_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in DispIntensityProfile.
function DispIntensityProfile_Callback(hObject, eventdata, handles)
% hObject    handle to DispIntensityProfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DispIntensityProfile


% --- Executes on button press in flip_profile_dimension.
function flip_profile_dimension_Callback(hObject, eventdata, handles)
% hObject    handle to flip_profile_dimension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of flip_profile_dimension

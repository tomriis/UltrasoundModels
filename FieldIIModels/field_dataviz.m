function varargout = field_dataviz(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @field_dataviz_OpeningFcn, ...
                   'gui_OutputFcn',  @field_dataviz_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before field_dataviz is made visible.
function field_dataviz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to field_dataviz (see VARARGIN)

handles.filename = varargin{1};
handles.data = matfile(handles.filename);
handles.axes1 = axes('Position',[0.40 0.57 0.45 0.42]);
handles.axes2 = axes('Position',[0.40 0.05 0.45 0.42]);
handles.parameters = unique_vals_from_mat(handles.data);

% Set slider values
field = fieldnames(handles.parameters);
% Copy the parameters structure
handles.current_params = cell2struct(cell(length(field),1),field);
for i =1:length(field)
    sl = handles.(strcat('slider',num2str(i)));
    numSteps = length(handles.parameters.(field{i}));
    if numSteps > 1
        set(sl, 'Min', 1);
        set(sl, 'Max', numSteps);
        set(sl, 'Value', 1);
        set(sl, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
    else
        set(sl,'Min',1);
        set(sl,'Max',2);
        set(sl,'Value',1);
        set(sl, 'Visible',false);
    end
end
% Hack for when data is such that ROC = R_focus
handles.ROC_equals_R_focus = true;
if handles.ROC_equals_R_focus
    set(handles.slider8,'Visible',false);
end
% Initialize all silders
handles.plot_flag = false;
slider1_Callback(handles.slider1, eventdata,handles);
handles=guidata(hObject);
slider2_Callback(handles.slider2, eventdata,handles);
handles=guidata(hObject);
slider3_Callback(handles.slider3, eventdata,handles);
handles=guidata(hObject);
slider4_Callback(handles.slider4, eventdata,handles);
handles=guidata(hObject);
slider5_Callback(handles.slider5, eventdata,handles);
handles=guidata(hObject);
slider6_Callback(handles.slider6, eventdata,handles);
handles=guidata(hObject);
slider7_Callback(handles.slider7, eventdata,handles);
handles=guidata(hObject);
slider8_Callback(handles.slider8, eventdata,handles);
handles=guidata(hObject); 
handles.plot_flag = true;
slider9_Callback(handles.slider9, eventdata,handles);
handles=guidata(hObject);

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = field_dataviz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


function slider1_Callback(hObject, ~, handles)
    value = handles.parameters.N(int16(get(hObject,'Value')));
    caption = sprintf('N Elements: %d', value);
    set(handles.text2, 'String', caption);
    handles.current_params.N = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function slider1_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function slider2_Callback(hObject, ~, handles)
    slider_val = int16(get(hObject,'Value'));
    if handles.ROC_equals_R_focus
        value = handles.parameters.Ro(int16(get(hObject,'Value')));
        caption = sprintf('R Focus: %d (mm)', value);
        set(handles.text8, 'String', caption);
        handles.current_params.Ro = value;
    end
    value = handles.parameters.ROC(slider_val);
    caption = sprintf('ROC: %d (mm)', value);
    set(handles.text3, 'String', caption);
    handles.current_params.ROC = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function slider2_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function slider3_Callback(hObject, ~, handles)
    handles = width_pitch_callback(hObject,handles);
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function slider3_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function slider4_Callback(hObject, ~, handles)
    value = handles.parameters.Y(int16(get(hObject,'Value')));
    caption = sprintf('Y: %.2f (mm)', value);
    set(handles.text5, 'String', caption);
    handles.current_params.Y = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function slider4_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function slider5_Callback(hObject, ~, handles)
    value = handles.parameters.F(int16(get(hObject,'Value')));
    caption = sprintf('Focus: [%d, 0, -ROC] (mm)', value);
    set(handles.text6, 'String', caption);
    handles.current_params.F = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, ~, ~)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, ~, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = width_pitch_callback(hObject,handles);
handles = find_params_in_data(handles);
guidata(hObject, handles);
if handles.plot_flag
    plot_xyplane_and_ypeaks(handles);
end

% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, ~, ~)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function slider7_Callback(hObject, ~, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = handles.parameters.ElGeo(int16(get(hObject,'Value')));
name_map = {'Flat','Focused','Spherical'};
caption = sprintf('Element Geometry: %s', name_map{value});
set(handles.text9, 'String', caption);
handles.current_params.ElGeo = value;
handles = find_params_in_data(handles);
guidata(hObject, handles);
if handles.plot_flag
    plot_xyplane_and_ypeaks(handles);
end

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function slider8_Callback(hObject, ~, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = handles.parameters.Ro(int16(get(hObject,'Value')));
caption = sprintf('R Focus: %d (mm)', value);
set(handles.text8, 'String', caption);
handles.current_params.Ro = value;
handles = find_params_in_data(handles);
guidata(hObject, handles);
if handles.plot_flag
    plot_xyplane_and_ypeaks(handles);
end


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, ~, ~)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on slider movement.
function slider9_Callback(hObject, ~, handles)
    value = handles.parameters.Slice{int16(get(hObject,'Value'))};
    caption = sprintf('Plane: %s', value);
    set(handles.text10, 'String', caption);
    handles.current_params.Slice = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles)
    set(hObject, 'Enable','off');

    fname = fieldname_from_params(handles.current_params);
    try
        handles.xdc_geometry = handles.data.(strcat('G_',fname(1:end-8)));
        handles.plot_geo_flag = true;
    catch
        set(handles.text10,'String',strcat(fname(1:end-8),sprintf('\n Geometry not available')));
        handles.plot_geo_flag = false;
    end
    if handles.plot_geo_flag
        show_transducer('data',handles.xdc_geometry);
    end
    set(hObject,'Enable','on');
    

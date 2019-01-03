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
p = inputParser;
addRequired(p,'datafile')
addOptional(p,'extent_equals_pi',false);
parse(p, varargin{:})
f = waitbar(0, 'Loading Data File');
handles.filename = p.Results.datafile;
handles.data = matfile(handles.filename);
handles.axes1 = axes('Position',[0.40 0.55 0.50 0.44]);
handles.axes2 = axes('Position',[0.40 0.05 0.50 0.44]);
handles.parameters = unique_vals_from_mat(handles.data);
waitbar(1/2,f,'Load Complete');
handles.extent_equals_pi = p.Results.extent_equals_pi;
% Set slider values
field = fieldnames(handles.parameters);
% Copy the parameters structure
handles.current_params = cell2struct(cell(length(field),1),field);
field_slider_map={'NX','ROC','W','H','F','M','ElGeo','NY','Slice'};
for i =1:9
        sl = handles.(strcat('slider',num2str(i)));
        numSteps = length(handles.parameters.(field_slider_map{i}));
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

if handles.extent_equals_pi
    set(handles.slider1,'Visible','off');
end
% Initialize Pop Up Menu
handles.txfield_norm='dB';
set(handles.popupmenu1,'String',{'dB','Normalize'});
% Initialize all silders
handles.plot_flag = false;
waitbar(1/2+0.5*1/9,f,'Initializing GUI');
slider1_Callback(handles.slider1, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*2/9,f);
slider2_Callback(handles.slider2, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*3/9,f);
slider3_Callback(handles.slider3, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*4/9,f);
slider4_Callback(handles.slider4, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*5/9,f);
slider5_Callback(handles.slider5, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*6/9,f);
slider6_Callback(handles.slider6, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*7/9,f);
slider7_Callback(handles.slider7, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*8/9,f);
slider8_Callback(handles.slider8, eventdata,handles);
handles=guidata(hObject); 
handles.plot_flag = true;
close(f);
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
    value = handles.parameters.NX(int16(get(hObject,'Value')));
    caption = sprintf('NX: %d', value);
    set(handles.text2, 'String', caption);
    handles.current_params.NX = value;
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
%     if handles.current_params.M == 1
%         caption = sprintf('R Focus: %d (mm)', value)
%         set(handles.text8,'String',caption);
%     elseif handles.current_params.M == 
    value = handles.parameters.ROC(slider_val);
    caption = sprintf('ROC: %d (mm)', value);
    set(handles.text3, 'String', caption);
    handles.current_params.ROC = value;
    if handles.extent_equals_pi
       handles = extent_equals_pi_callback(handles);
    end
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
    index = int16(get(hObject,'Value'));
    valueX = handles.parameters.W(index);
    captionX = sprintf('X: %.2f (mm)', valueX);
    set(handles.text4, 'String', captionX);
    set(handles.slider3,'Value', index);
    handles.current_params.W = valueX;
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
    value = handles.parameters.H(int16(get(hObject,'Value')));
    caption = sprintf('Y: %.2f (mm)', value);
    set(handles.text5, 'String', caption);
    handles.current_params.H = value;
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
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function slider6_Callback(hObject, ~, handles)
    value = handles.parameters.M(int16(get(hObject,'Value')));
    namemap = {'Field II','FOCUS'};
    caption = sprintf('Platform:  %s', namemap{value});
    set(handles.text1, 'String', caption);
    handles.current_params.M = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

function slider6_CreateFcn(hObject, ~, ~)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider7_Callback(hObject, ~, handles)
    value = handles.parameters.ElGeo(int16(get(hObject,'Value')));
    name_map = {'Flat','Focused'};
    caption = sprintf('Geometry: %s', name_map{value});
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
    set(handles.text11, 'String', caption);
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
        disp('Plotting transducers...')
        if handles.current_params.M ==1
            show_transducer('data',handles.xdc_geometry);
        else
            figure; focus_draw_array(handles.xdc_geometry);hold on;
            colormap(cool(128));
            %view(3)
            xlabel('x [m] (Lateral)')
            ylabel('y [m] (Elevation)')
            zlabel('z [m] (Axial)')
            grid
            axis('image')
            hold off
            view([90, 90, 90]); 
        end
        disp('Complete');
    end
    set(hObject,'Enable','on');

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, ~, handles)
        contents = cellstr(get(hObject,'String'));
        handles.txfield_norm = contents{get(hObject,'Value')};
        handles = find_params_in_data(handles);
        guidata(hObject, handles);
        if handles.plot_flag
            plot_xyplane_and_ypeaks(handles);
        end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
    value = handles.parameters.NY(int16(get(hObject,'Value')));
    caption = sprintf('NY: %d', value);
    set(handles.text7, 'String', caption);
    handles.current_params.NY = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

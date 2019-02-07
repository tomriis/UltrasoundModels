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
addOptional(p,'NX_NY_coupled',true);
parse(p, varargin{:})
f = waitbar(0, 'Loading Data File');
handles.filename = p.Results.datafile;
handles.data = matfile(handles.filename);
handles.axes1 = axes('Position',[0.40 0.55 0.50 0.44]);
handles.axes2 = axes('Position',[0.40 0.05 0.50 0.44]);
handles.parameters = unique_vals_from_mat(handles.data);
waitbar(1/2,f,'Load Complete');
handles.NX_NY_coupled = p.Results.NX_NY_coupled;
% Set slider values
field = fieldnames(handles.parameters);
% Copy the parameters structure
handles.current_params = cell2struct(cell(length(field),1),field);
field_slider_map={'NR','A','W','H','FX','FY','ElGeo','NZ','Slice','FZ','B'};
for i =1:10
        sl = handles.(strcat('slider',field_slider_map{i}));
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
        set(sl, 'Visible','off');
    end
end
% Hack for when data is such that ROC = R_focus

if handles.NX_NY_coupled
    set(handles.sliderNR, 'Visible','off');
end
% Initialize Pop Up Menu
handles.txfield_norm='dB';
set(handles.popupmenu1,'String',{'dB','Normalize'});
% Initialize all silders
handles.plot_flag = false;
numSliders = 10;
waitbar(1/2+0.5*1/numSliders,f,'Initializing GUI');
sliderNR_Callback(handles.sliderNR, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*2/numSliders,f);
sliderA_Callback(handles.sliderA, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*3/numSliders,f);
sliderW_Callback(handles.sliderW, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*4/numSliders,f);
sliderH_Callback(handles.sliderH, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*5/numSliders,f);
sliderFX_Callback(handles.sliderFX, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*6/numSliders,f);
sliderFY_Callback(handles.sliderFY, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*7/numSliders,f);
sliderElGeo_Callback(handles.sliderElGeo, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*8/numSliders,f);
sliderNZ_Callback(handles.sliderNZ, eventdata,handles);
handles=guidata(hObject); 
waitbar(1/2+0.5*9/numSliders,f);
sliderSlice_Callback(handles.sliderSlice, eventdata,handles);
handles=guidata(hObject);
handles.plot_flag = true;
slider10_Callback(handles.sliderFZ, eventdata,handles);
handles=guidata(hObject);
close(f);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = field_dataviz_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
%varargout{1} = handles.output;


function sliderNR_Callback(hObject, ~, handles)
    value = handles.parameters.NR(int16(get(hObject,'Value')));
    caption = sprintf('NR: %d', value);
    set(handles.text2, 'String', caption);
    handles.current_params.NR = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderNR_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function sliderA_Callback(hObject, ~, handles)
    slider_val = int16(get(hObject,'Value'));
    value = handles.parameters.A(slider_val);
    caption = sprintf('Major Axis: %d (mm)', value);
    set(handles.text3, 'String', caption);
    handles.current_params.A = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderA_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function sliderW_Callback(hObject, ~, handles)
    index = int16(get(hObject,'Value'));
    valueX = handles.parameters.W(index);
    captionX = sprintf('X: %.2f (mm)', valueX);
    set(handles.text4, 'String', captionX);
    set(handles.sliderW,'Value', index);
    handles.current_params.W = valueX;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderW_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function sliderH_Callback(hObject, ~, handles)
    value = handles.parameters.H(int16(get(hObject,'Value')));
    caption = sprintf('Y: %.2f (mm)', value);
    set(handles.text5, 'String', caption);
    handles.current_params.H = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderH_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function sliderFX_Callback(hObject, ~, handles)
    value = handles.parameters.FX(int16(get(hObject,'Value')));
    caption = sprintf('FX: %.2f (mm)',value);
    set(handles.text6, 'String', caption);
    handles.current_params.FX = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderFX_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% --- Executes on slider movement.
function sliderFY_Callback(hObject, ~, handles)
    value = handles.parameters.FY(int16(get(hObject,'Value')));

    caption = sprintf('FY: %.2f', value);
    set(handles.text1, 'String', caption);
    handles.current_params.FY = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

function sliderFY_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function sliderElGeo_Callback(hObject, ~, handles)
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

function sliderElGeo_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

function radiobutton2_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

function radiobutton3_Callback(hObject, ~, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

function sliderSlice_Callback(hObject, ~, handles)
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
function sliderSlice_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, ~, handles)
    set(hObject, 'Enable','off');

    fname = fieldname_from_params(handles.current_params);
    try
        k = strfind(fname,'Slice_');
        fname = fname(1:k-1);
        handles.xdc_geometry = handles.data.(strcat('G_',fname));
        handles.plot_geo_flag = true;
    catch
        set(handles.text10,'String',strcat(fname,sprintf('\n Geometry not available')));
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
function sliderNZ_Callback(hObject, eventdata, handles)
    value = handles.parameters.NY(int16(get(hObject,'Value')));
    caption = sprintf('NZ: %d', value);
    set(handles.text7, 'String', caption);
    handles.current_params.NY = value;
    if handles.NX_NY_coupled
        kerf = 0.4;
        handles.current_params.NR = floor(256/handles.current_params.NZ);
        p = ellipse_perimeter(handles.current_params.A,handles.current_params.B);
        if handles.current_params.NR*(handles.current_params.W+kerf) > p
            handles.current_params.NR = floor(p/(handles.current_params.W+kerf));
        end
        caption = sprintf('NR: %d', handles.current_params.NR);
        set(handles.text2, 'String', caption);
    end
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderNZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderNZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderFZ_Callback(hObject, ~, handles)
    value = handles.parameters.FZ(int16(get(hObject,'Value')));
    caption = sprintf('FZ: %.2f (mm)', value);
    set(handles.text12, 'String', caption);
    handles.current_params.FZ = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderFZ_CreateFcn(hObject, ~, ~)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on slider movement.
function sliderB_Callback(hObject, eventdata, handles)
    slider_val = int16(get(hObject,'Value'));
    value = handles.parameters.A(slider_val);
    caption = sprintf('Major Axis: %d (mm)', value);
    set(handles.text3, 'String', caption);
    handles.current_params.A = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

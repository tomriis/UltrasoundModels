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
for i =1:length(field_slider_map)
        sl = handles.(strcat('slider',field_slider_map{i}));
        if field_slider_map{i} == 'B'
            numSteps = 2;
        else
            numSteps = length(handles.parameters.(field_slider_map{i}));
        end
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
handles.total_elements =256;
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
sliderFZ_Callback(handles.sliderFZ, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*10/numSliders,f);
handles.plot_flag = true;
sliderB_Callback(handles.sliderB, eventdata, handles);
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


function sliderA_Callback(hObject, eventdata, handles)
    slider_val = int16(get(hObject,'Value'));
    value = handles.parameters.A(slider_val);
    caption = sprintf('Major Axis: %d (mm)', value);
    set(handles.text3, 'String', caption);
    handles.current_params.A = value;
    
    if handles.current_params.ElGeo == 2
        caption = sprintf('R Focus: %s (mm)', num2str(handles.current_params.A));
        set(handles.text8,'String',caption);
        handles.current_params.Ro = handles.current_params.A;
    end
    sliderB_Callback(hObject, eventdata, handles)
    guidata(hObject, handles);



function sliderA_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
function sliderNZ_Callback(hObject, eventdata, handles)
    value = handles.parameters.NZ(int16(get(handles.sliderNZ,'Value')));
    caption = sprintf('NY: %d', value);
    set(handles.text7, 'String', caption);
    handles.current_params.NZ = value;
    if handles.NX_NY_coupled
        handles.current_params.NR = find_NR_from_geo(handles.total_elements, handles.current_params.NZ,...,
            handles.current_params.A, handles.current_params.B, handles.current_params.W);
        
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
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function sliderW_Callback(hObject, eventdata, handles)
    index = int16(get(handles.sliderW,'Value'));
    valueX = handles.parameters.W(index);
    captionX = sprintf('Dx: %.2f (mm)', valueX);
    set(handles.text4, 'String', captionX);
    set(handles.sliderW,'Value', index);
    handles.current_params.W = valueX;
    handles = find_params_in_data(handles);
    sliderB_Callback(hObject, eventdata, handles)
    guidata(hObject, handles);


function sliderW_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end


function sliderH_Callback(hObject, ~, handles)
    value = handles.parameters.H(int16(get(hObject,'Value')));
    caption = sprintf('Dy: %.2f (mm)', value);
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
    if value == 1
        handles.current_params.Ro = Inf;
    else
        handles.current_params.Ro = handles.current_params.A;
    end
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
        show_transducer('data',handles.xdc_geometry);
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

function sliderFZ_Callback(hObject, ~, handles)
    value = handles.parameters.FZ(int16(get(hObject,'Value')));
    caption = sprintf('FZ: %.2f (mm)', value);
    set(handles.text13, 'String', caption);
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
    Semi_Minor_Axis_Ratio = [135/170 1];
    slider_val = int16(get(handles.sliderB,'Value'));
    value = Semi_Minor_Axis_Ratio(slider_val)*handles.current_params.A;
    caption = sprintf('Minor Axis: %.2f (mm)', value);
    set(handles.textMinorAxis, 'String', caption);
    handles.current_params.B = value;
    handles = find_params_in_data(handles);
    sliderNZ_Callback(hObject, eventdata, handles)
    guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sliderB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

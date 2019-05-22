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
handles.axes2 = axes('Position',[0.40 0.05 0.45 0.44]);
handles.parameters = unique_vals_from_mat(handles.data);
waitbar(1/2,f,'Load Complete');
handles.NX_NY_coupled = p.Results.NX_NY_coupled;
% Set slider values
field = fieldnames(handles.parameters);
% Copy the parameters structure
handles.current_params = cell2struct(cell(length(field),1),field);
field_slider_map={'A','W','H','FX','FY','ElGeo','NY','Slice','FZ','B','K'};
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
 
% Initialize Pop Up Menu
handles.txfield_norm='dB';
set(handles.popupmenu1,'String',{'dB','Normalize'});
% Initialize all silders
handles.plot_flag = false;
numSliders = 10;
waitbar(1/2+0.5*1/numSliders,f,'Initializing GUI');
handles.current_params.T = 256;
handles = NY_Callback(handles);
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
sliderNY_Callback(handles.sliderNY, eventdata,handles);
handles=guidata(hObject); 
waitbar(1/2+0.5*9/numSliders,f);
sliderFZ_Callback(handles.sliderFZ, eventdata,handles);
handles=guidata(hObject);
sliderSlice_Callback(handles.sliderSlice, eventdata,handles);
handles=guidata(hObject);
sliderK_Callback(handles.sliderK, eventdata,handles);
handles=guidata(hObject);
waitbar(1/2+0.5*10/numSliders,f);
try
    handles.current_params.EX = handles.parameters.EX{1};
    handles.current_params.SUM = handles.parameters.SUM{1};
    if strcmp(handles.current_params.EX,'g')
        handles.gaussian_pulse_button.Value = 1;
    else
        handles.sine_wave_button.Value =1;
        handles.current_params.EX = 's';
    end
    switch handles.current_params.SUM
        case 'ms'
            handles.max_button.Value = 1;
        case 'ma'
            handles.max_abs_button.Value = 1;
        case 'mh'
            handles.max_hilbert_button.Value = 1;
        otherwise 'sh'
            handles.sum_hilbert_button.Value = 1;
            handles.current_params.SUM = 'sh';
    end
catch
field_sum_group_SelectionChangedFcn(handles.field_sum_group,eventdata, handles);
handles = guidata(hObject);
excitation_group_SelectionChangedFcn(handles.excitation_group,eventdata,handles);
handles = guidata(hObject);
end
handles.plot_flag = true;
sliderB_Callback(handles.sliderB, eventdata, handles);
handles=guidata(hObject);
close(f);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = field_dataviz_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
%varargout{1} = handles.output;


function sliderT_Callback(hObject, ~, handles)

    value = handles.parameters.T(int16(get(hObject,'Value')));
    caption = sprintf('N Total ~ %.2f', value);
    set(handles.textNTotal, 'String', caption);
    handles.current_params.T = value;
    handles = NY_Callback(handles);
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderT_CreateFcn(hObject, ~, ~)
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
%         caption = sprintf('R Focus: %s (mm)', num2str(handles.current_params.A));
%         set(handles.text8,'String',caption);
%         handles.current_params.Ro = handles.current_params.A;
    end
    handles = semiminor_callback(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


function sliderA_CreateFcn(hObject, ~, ~)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

    
function sliderNY_Callback(hObject, eventdata, handles)
    handles = NY_Callback(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end

    
function sliderNY_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function sliderW_Callback(hObject, eventdata, handles)
    index = int16(get(handles.sliderW,'Value'));
    valueX = handles.parameters.W(index);
    captionX = sprintf('Width Y: %.2f (mm)', valueX);
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


function sliderH_Callback(hObject, eventdata, handles)
    value = handles.parameters.H(int16(get(hObject,'Value')));
    caption = sprintf('Width R: %.2f (mm)', value);
    set(handles.text5, 'String', caption);
    handles.current_params.H = value;
    handles = find_params_in_data(handles);
    sliderB_Callback(hObject, eventdata, handles)
    guidata(hObject, handles);



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

    caption = sprintf('FY: %.2f (mm)', value);
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
        
        try
            fname = strcat(fname,'EX',handles.current_params.EX,'SUM',handles.current_params.SUM);
            handles.xdc_geometry = handles.data.(strcat('G_',fname));
            handles.plot_geo_flag = true;
        catch
            set(handles.text10,'String',strcat(fname,sprintf('\n Geometry not available')));
            handles.plot_geo_flag = false;
        end
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
    value = handles.parameters.FZ(int16(get(handles.sliderFZ,'Value')));
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
    handles = semiminor_callback(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderB_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when selected object is changed in excitation_group.
function excitation_group_SelectionChangedFcn(hObject, ~, handles)
    if handles.gaussian_pulse_button.Value
        handles.current_params.EX = 'g';
    else
        handles.current_params.EX = 's';
    end
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end
    


% --- Executes when selected object is changed in field_sum_group.
function field_sum_group_SelectionChangedFcn(hObject, ~, handles)
    if handles.max_button.Value
        handles.current_params.SUM= 'ms';
    elseif handles.max_abs_button.Value
        handles.current_params.SUM = 'ma';
    elseif handles.max_hilbert_button.Value
        handles.current_params.SUM = 'mh';
    else
        handles.current_params.SUM = 'sh';
    end
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes on slider movement.
function sliderRFocus_Callback(hObject, eventdata, handles)
    value = handles.parameters.Ro(int16(get(handles.sliderRFocus,'Value')));
    caption = sprintf('Ro: %.2f (mm)', value);
    set(handles.RFocusText, 'String', caption);
    handles.current_params.Ro = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderRFocus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderRFocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderK_Callback(hObject, eventdata, handles)
    value = handles.parameters.K(int16(get(handles.sliderK,'Value')));
     caption = sprintf('Kerf: %.2f (mm)', value);
     set(handles.KerfText, 'String', caption);
    handles.current_params.K = value;
    handles = find_params_in_data(handles);
    guidata(hObject, handles);
    if handles.plot_flag
        plot_xyplane_and_ypeaks(handles);
    end


% --- Executes during object creation, after setting all properties.
function sliderK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

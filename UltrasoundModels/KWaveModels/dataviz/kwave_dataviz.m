function varargout = kwave_dataviz(varargin)
% KWAVE_DATAVIZ MATLAB code for kwave_dataviz.fig
%      KWAVE_DATAVIZ, by itself, creates a new KWAVE_DATAVIZ or raises the existing
%      singleton*.
%
%      H = KWAVE_DATAVIZ returns the handle to a new KWAVE_DATAVIZ or the handle to
%      the existing singleton*.
%
%      KWAVE_DATAVIZ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KWAVE_DATAVIZ.M with the given input arguments.
%
%      KWAVE_DATAVIZ('Property','Value',...) creates a new KWAVE_DATAVIZ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kwave_dataviz_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kwave_dataviz_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kwave_dataviz

% Last Modified by GUIDE v2.5 13-Mar-2019 12:17:44

% Begin initialization code - DO NOT EDIT
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
% End initialization code - DO NOT EDIT


% --- Executes just before kwave_dataviz is made visible.
function kwave_dataviz_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kwave_dataviz (see VARARGIN)

% Choose default command line output for kwave_dataviz
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kwave_dataviz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = kwave_dataviz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
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

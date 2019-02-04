function varargout = Ellipse_Angles_GUI(varargin)
% 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Ellipse_Angles_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Ellipse_Angles_GUI_OutputFcn, ...
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


% --- Executes just before Ellipse_Angles_GUI is made visible.
function Ellipse_Angles_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Ellipse_Angles_GUI (see VARARGIN)

% Choose default command line output for Ellipse_Angles_GUI
handles.output = hObject;
handles.show_perp_line = 0;
handles.focus=Ellipse_Angles(handles);
% Update handles structure
guidata(hObject, handles);
    set(handles.figure1,'toolbar','figure');
    set(handles.figure1,'menubar','figure');
%addNewPositionCallback(focus,@Ellipse_Angles);
% UIWAIT makes Ellipse_Angles_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Ellipse_Angles_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
    handles.focus=Ellipse_Angles(handles);
    % Update handles structure
    guidata(hObject, handles);


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
    if get(hObject,'Value')
        handles.show_perp_line = 1;
    else
        handles.show_perp_line = 0;
    end
    handles.focus=Ellipse_Angles(handles);
    guidata(hObject,handles);

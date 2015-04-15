function varargout = measurementUI(varargin)
%MEASUREMENTUI M-file for measurementUI.fig
%      MEASUREMENTUI, by itself, creates a new MEASUREMENTUI or raises the existing
%      singleton*.
%
%      H = MEASUREMENTUI returns the handle to a new MEASUREMENTUI or the handle to
%      the existing singleton*.
%
%      MEASUREMENTUI('Property','Value',...) creates a new MEASUREMENTUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to measurementUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      MEASUREMENTUI('CALLBACK') and MEASUREMENTUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in MEASUREMENTUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help measurementUI

% Last Modified by GUIDE v2.5 31-Mar-2015 20:29:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @measurementUI_OpeningFcn, ...
                   'gui_OutputFcn',  @measurementUI_OutputFcn, ...
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


% --- Executes just before measurementUI is made visible.
function measurementUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for measurementUI
handles.output = hObject;

% Initial component state
set(handles.buttonExportData, 'enable', 'off');
set(handles.buttonAutomatic, 'enable', 'off');
set(handles.buttonManual, 'enable', 'off');
set(handles.buttonLoad1, 'enable', 'off');
set(handles.imageAxes1, 'Visible', 'off');
set(handles.imageAxes2, 'Visible', 'off');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes measurementUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = measurementUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonLoadData.
function buttonLoadData_Callback(hObject, eventdata, handles)

    S = readMatFile();
    
    if ~isempty(S)
        
        handles.cameraParams = S.cParams;
        guidata(hObject, handles);
        messageManager(handles.msgMng, 'success', 'Data loaded successful');
        
        % Update component state
        set(handles.buttonLoad1, 'enable', 'on');
        
    else
        messageManager(handles.msgMng, 'info', 'No file selected');
    end


% --- Executes on button press in buttonExportData.
function buttonExportData_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonLoad1.
function buttonLoad1_Callback(hObject, eventdata, handles)
    
    messageManager(handles.msgMng, 'info', 'Reading images');
    
    image1 = readImage();
    image2 = readImage();
    
    if ~isempty(image1) && ~isempty(image2)
                
        [rect1, P1] = imageUndistort(image1, handles.cameraParams);
        [rect2, P2] = imageUndistort(image2, handles.cameraParams);
        
        if ~isempty(P1) && ~isempty(P2)
                
            handles.image1 = rect1;
            handles.image2 = rect2;

            handles.P1 = P1;
            handles.P2 = P2;

            messageManager(handles.msgMng, 'success', 'Images loaded and undistorted successful');

            % Update component state
            set(handles.buttonAutomatic, 'enable', 'on');
            set(handles.buttonManual, 'enable', 'on');
            set(handles.imageAxes1, 'Visible', 'on');
            set(handles.imageAxes2, 'Visible', 'on');
            handles.points1 = [];
            handles.points2 = [];
            handles.p3d = [];

            % Update axes
            updateAxes(handles.imageAxes1, handles.image1, handles.points1);
            updateAxes(handles.imageAxes2, handles.image2, handles.points2);

            guidata(hObject, handles);
                
        else
            messageManager(handles.msgMng, 'error', 'Error undistorting images: can''t find checkerboard');
        end
    else
        messageManager(handles.msgMng, 'error', 'Error reading images');
    end

% --- Executes on button press in buttonHelp.
function buttonHelp_Callback(hObject, eventdata, handles)
% hObject    handle to buttonHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonAutomatic.
function buttonAutomatic_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAutomatic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in buttonManual.
function buttonManual_Callback(hObject, eventdata, handles)

    warning('OFF');

    [points1, points2] = readStereoPoints(handles.image1, handles.image2);
    
    if ~isempty(points1)
        handles.points1 = [handles.points1; points1];
        handles.points2 = [handles.points2; points2];
        
        % Triangulation
        handles.p3d = [handles.p3d; triangulations(handles.P1, points1, handles.P2, points2)];
    
        % Measurements
        handles.measures = measures(handles.p3d);
        
        % Update axes
        updateAxes(handles.imageAxes1, handles.image1, handles.points1);
        updateAxes(handles.imageAxes2, handles.image2, handles.points2);
    
        % Update components
        set(handles.dataTable, 'data',[colon(1, size(handles.points1, 1))' handles.points1 handles.points2 handles.p3d])
        set(handles.measuresTable, 'data', handles.measures)
        
        guidata(hObject, handles);
    
        messageManager(handles.msgMng, 'success', [num2str(size(points1, 1)) ' points read successful']);
    end
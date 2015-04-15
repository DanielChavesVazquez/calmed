function varargout = calibrationUI(varargin)
% CALIBRATIONUI MATLAB code for calibrationUI.fig
%      CALIBRATIONUI, by itself, creates a new CALIBRATIONUI or raises the existing
%      singleton*.
%
%      H = CALIBRATIONUI returns the handle to a new CALIBRATIONUI or the handle to
%      the existing singleton*.
%
%      CALIBRATIONUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATIONUI.M with the given input arguments.
%
%      CALIBRATIONUI('Property','Value',...) creates a new CALIBRATIONUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calibrationUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calibrationUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calibrationUI

% Last Modified by GUIDE v2.5 28-Mar-2015 14:02:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calibrationUI_OpeningFcn, ...
                   'gui_OutputFcn',  @calibrationUI_OutputFcn, ...
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


% --- Executes just before calibrationUI is made visible.
function calibrationUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calibrationUI (see VARARGIN)

% Choose default command line output for calibrationUI
handles.output = hObject;

% Starting components state
set(handles.buttonExport, 'enable', 'off');
set(handles.buttonCalib, 'enable', 'off');
set(handles.imagesListbox, 'enable', 'off');
set(handles.buttonDelete, 'enable', 'off');

set(handles.mainAxes, 'Visible', 'off');
set(handles.errorAxes, 'Visible', 'off');
set(handles.extrinsicsAxes, 'Visible', 'off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calibrationUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calibrationUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)

[filename, pathname] = uigetfile( ...
{  '*.tif','TIFF images (*.tif)'; ...
   '*.jpg;*.jpeg','JPG images (*.jpg, *.jpeg)'; ...
   '*.*',  'All Files (*.*)'}, ...
   'Pick a file', ...
   'MultiSelect', 'on');

if pathname ~= 0
    
    handles.squareSize = 0;
    while handles.squareSize < 1
        answer = inputdlg({'Size pattern squares (mm): '},'Input',1,{'20'});
        handles.squareSize = str2num(answer{1});
    end
    
    [handles.imagePoints, handles.boardSize, handles.images, files] = ...
    loadCalibImages(pathname, filename);

    handles.worldPoints = generateCheckerboardPoints(handles.boardSize, ...
        handles.squareSize);

    % Update component state
    set(handles.buttonDelete, 'enable', 'on');
    set(handles.imagesListbox, 'enable', 'on');
    set(handles.imagesListbox, 'String', files, 'Value', 1);
    set(handles.buttonCalib,'enable', 'on');
        
    updateMainAxes(handles.mainAxes, handles.images{get(handles.imagesListbox,'Value')}, handles.imagePoints(:,:,1));
    
    % Info dialog
    msgbox({'Summary:', ['Added: ', num2str(length(handles.images))], ['Rejected: ' num2str(length(filename) - length(handles.images))]}, 'Info');
    
    messageManager(handles.msgMng, 'success', ['Done: ', num2str(length(files)) , ' images loaded from ', pathname]);
    
    guidata(hObject, handles);
    
else 
    messageManager(handles.msgMng, 'info', 'No file selected');
end




% --- Executes on button press in buttonExport.
function buttonExport_Callback(hObject, eventdata, handles)

cParams = handles.cameraParams;
errors = handles.estimationErrors;

save('cameraParameters.mat', 'cParams', 'errors');
messageManager(handles.msgMng, 'success', 'Data export successfull');


% --- Executes on button press in buttonCalib.
function buttonCalib_Callback(hObject, eventdata, handles)

radioButtonSelected = get(get(handles.uibuttongroup1, 'SelectedObject'), 'Tag');
if strcmp(radioButtonSelected, 'radiobutton2coef')
    numCoeff = 2;
else
    numCoeff = 3;
end

[cameraParams] = estimateCameraParameters(handles.imagePoints,handles.worldPoints, ...
                'EstimateSkew', num2bool(get(handles.skewCheck, 'Value')), ...
                'NumRadialDistortionCoefficients', numCoeff, ...
                'EstimateTangentialDistortion', num2bool(get(handles.tangentialCheck, 'Value')));

% Update component state
set(handles.buttonExport, 'enable', 'on');
set(handles.errorAxes, 'Visible', 'on');
showReprojectionErrors(cameraParams, 'Parent', handles.errorAxes);
set(handles.extrinsicsAxes, 'Visible', 'on');
showExtrinsics(cameraParams, 'Parent', handles.extrinsicsAxes);

messageManager(handles.msgMng, 'success', 'Calibration done successfull');
guidata(hObject, handles);


% --- Executes on selection change in imagesListbox.
function imagesListbox_Callback(hObject, eventdata, handles)

updateMainAxes(handles.mainAxes, handles.images{get(hObject,'Value')}, handles.imagePoints(:,:,get(hObject,'Value')));
messageManager(handles.msgMng, 'success', '');

% --- Executes during object creation, after setting all properties.
function imagesListbox_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in buttonDelete.
function buttonDelete_Callback(hObject, eventdata, handles)

selected = get(handles.imagesListbox,'Value');
prev_str = get(handles.imagesListbox, 'String');
len = length(prev_str);

if len > 0
    if selected(1) == 1
        indices = [(selected(end)+1):length(prev_str)];
    else
        indices = [1:(selected(1)-1) (selected(end)+1):length(prev_str)];
    end
    prev_str = prev_str(indices);
    set(handles.imagesListbox, 'String', prev_str, 'Value', min(selected, length(prev_str)));
    handles.images = handles.images(indices);
    handles.imagePoints = handles.imagePoints(:,:,indices);
    
    %Update component state
    if isempty(handles.images)
        set(handles.buttonDelete, 'enable', 'off');
        set(handles.imagesListbox, 'enable', 'off');
        set(handles.buttonCalib,'enable', 'off');
        updateMainAxes(handles.mainAxes, 'null');
        set(handles.imagesListbox, 'String', 'Load images to start','Value', 1);
        messageManager(handles.msgMng, 'info', 'No file selected');
    else
        updateMainAxes(handles.mainAxes, handles.images{get(handles.imagesListbox,'Value')}, handles.imagePoints(:,:,get(handles.imagesListbox,'Value')));
        messageManager(handles.msgMng, 'success', 'Image remove succesfull');
    end
    
    
    guidata(hObject, handles);
end


% --- Executes on button press in buttonHelp.
function buttonHelp_Callback(hObject, eventdata, handles)
% hObject    handle to buttonHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function skewCheck_Callback(hObject, eventdata, handles)
function tangentialCheck_Callback(hObject, eventdata, handles)

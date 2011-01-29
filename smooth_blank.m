function varargout = smooth_blank(varargin)
% SMOOTH_BLANK M-file for smooth_blank.fig
%      SMOOTH_BLANK, by itself, creates a new SMOOTH_BLANK or raises the existing
%      singleton*.
%
%      H = SMOOTH_BLANK returns the handle to a new SMOOTH_BLANK or the handle to
%      the existing singleton*.
%
%      SMOOTH_BLANK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMOOTH_BLANK.M with the given input arguments.
%
%      SMOOTH_BLANK('Property','Value',...) creates a new SMOOTH_BLANK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smooth_blank_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smooth_blank_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smooth_blank

% Last Modified by GUIDE v2.5 19-Jan-2011 14:03:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smooth_blank_OpeningFcn, ...
                   'gui_OutputFcn',  @smooth_blank_OutputFcn, ...
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


% --- Executes just before smooth_blank is made visible.
function smooth_blank_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smooth_blank (see VARARGIN)

% Choose default command line output for smooth_blank
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes smooth_blank wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = smooth_blank_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Open_file_Callback(hObject, eventdata, handles)
% hObject    handle to Open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Open_file as text
%        str2double(get(hObject,'String')) returns contents of Open_file as a double


% --- Executes during object creation, after setting all properties.
function Open_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Open_file_button.
function Open_file_button_Callback(hObject, eventdata, handles)
% hObject    handle to Open_file_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.csv','Choose the data csv file...');
global X;
global Y;
global Y2;
global BFILE;
BFILE=strcat(pathname,filename);
set(handles.Open_file,'String',filename);
BASELINE=csvread(BFILE,12,0);
X=BASELINE(:,5);
Y=BASELINE(:,1);
span=str2num(get(handles.span_number,'String'));
Y2=smooth_b(Y,span); % Smooth the curve
show_all(X,Y,Y2,hObject, eventdata, handles); % Plot the curve
guidata(hObject, handles);

function span_number_Callback(hObject, eventdata, handles)
% hObject    handle to span_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of span_number as text
%        str2double(get(hObject,'String')) returns contents of span_number as a double
global X;
global Y;
global Y2;
span=str2num(get(handles.span_number,'String'));
Y2=smooth_b(Y,span); % Smooth the curve
show_all(X,Y,Y2,hObject, eventdata, handles); % Plot the curve
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function span_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to span_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Save_file.
function Save_file_Callback(hObject, eventdata, handles)
% hObject    handle to Save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X;
global Y;
global Y2;
global BFILE;
[a b]=size(Y2);
mat=zeros(a,2);
mat(:,1)=X;
mat(:,2)=Y;
[path, DESFILE_NAME, ext, versn]=fileparts(BFILE);
DESFILE=strcat(DESFILE_NAME,'-smooth.csv');
%DFILE=strcat(path,DESFILE);
csvwrite(DESFILE,mat);
guidata(hObject, handles);

function result=smooth_b(source,interval)
% This is the function built in to smooth the curve by using moving average
% method and a settled span number.

result=smooth(source,interval);

function show_all(x,y,y_p,hObject, eventdata, handles)
% The purpose of this function is to show the original curve as well as the
% smoothed curve.
axes(handles.axes1);
plot(x,y,'+',x,y_p,'r-');

function varargout = cal_mech(varargin)
%CAL_MECH M-file for cal_mech.fig
%      CAL_MECH, by itself, creates a new CAL_MECH or raises the existing
%      singleton*.
%
%      H = CAL_MECH returns the handle to a new CAL_MECH or the handle to
%      the existing singleton*.
%
%      CAL_MECH('Property','Value',...) creates a new CAL_MECH using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to cal_mech_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      CAL_MECH('CALLBACK') and CAL_MECH('CALLBACK',hObject,...) call the
%      local function named CALLBACK in CAL_MECH.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cal_mech

% Last Modified by GUIDE v2.5 28-Jan-2011 15:31:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cal_mech_OpeningFcn, ...
                   'gui_OutputFcn',  @cal_mech_OutputFcn, ...
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


% --- Executes just before cal_mech is made visible.
function cal_mech_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for cal_mech
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cal_mech wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cal_mech_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function base_file_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to base_file_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of base_file_edit1 as text
%        str2double(get(hObject,'String')) returns contents of base_file_edit1 as a double


% --- Executes during object creation, after setting all properties.
function base_file_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to base_file_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in baseline_file_pushbutton.
function baseline_file_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to baseline_file_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.csv','Choose the baseline csv file...');
global BFILE;
global BMATRIX;
global ISBASEFILE;
global BMATSIZE;
BFILE=strcat(pathname,filename);
BMATRIX=csvread(BFILE);
if (~exist('BMATRIX','var'))
    errordlg('Please check the basefile name!');
    guidata(hObject,handles);
    return;
end
set(handles.base_file_edit1,'String',BFILE);
ISBASEFILE=1;
[BMATSIZE,l]=size(BMATRIX);
guidata(hObject, handles);

% --- Executes on slider movement.
function plot_range_slider1_Callback(hObject, eventdata, handles)
% hObject    handle to plot_range_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
startValue=get(handles.start_range_slider,'Value');
startRange=floor(startValue)+1;
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(startRange:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(startRange:sliderRange,1)-BMATRIX(startRange:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');


% --- Executes during object creation, after setting all properties.
function plot_range_slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot_range_slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function length_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to length_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length_edit1 as text
%        str2double(get(hObject,'String')) returns contents of length_edit1 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function length_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function length_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to length_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length_edit2 as text
%        str2double(get(hObject,'String')) returns contents of length_edit2 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function length_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function length_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to length_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length_edit3 as text
%        str2double(get(hObject,'String')) returns contents of length_edit3 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function length_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_edit1_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit1 as text
%        str2double(get(hObject,'String')) returns contents of width_edit1 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function width_edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_edit2_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit2 as text
%        str2double(get(hObject,'String')) returns contents of width_edit2 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function width_edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function width_edit3_Callback(hObject, eventdata, handles)
% hObject    handle to width_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of width_edit3 as text
%        str2double(get(hObject,'String')) returns contents of width_edit3 as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function width_edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width_edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function init_length_edit_Callback(hObject, eventdata, handles)
% hObject    handle to init_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of init_length_edit as text
%        str2double(get(hObject,'String')) returns contents of init_length_edit as a double
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function init_length_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to init_length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calculate_pushbutton.
function calculate_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(1:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(1:sliderRange,1)-BMATRIX(1:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
slope=strain\stress;
set(handles.modulus_result,'String',num2str(slope*100));
strength=max((DMATRIX(1:BMATSIZE,1)-BMATRIX(1:BMATSIZE,2)).*4447.5./(avg_length*avg_width)+compensation);
set(handles.tensile_strength_result,'String',num2str(strength));
axes(handles.axes1);
plot(strain,stress,'r*',strain,slope*strain,'b-');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

function data_file_edit_Callback(hObject, eventdata, handles)
% hObject    handle to data_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of data_file_edit as text
%        str2double(get(hObject,'String')) returns contents of data_file_edit as a double


% --- Executes during object creation, after setting all properties.
function data_file_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_file_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in open_data_file_pushbutton.
function open_data_file_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to open_data_file_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.csv','Choose the data csv file...');
global DFILE;
global DMATRIX;
global ISDATAFILE;
global BMATRIX;
global BMATSIZE;
DFILE=strcat(pathname,filename);
DMATRIX=csvread(DFILE,12,0);
if (~exist('DMATRIX','var'))
    errordlg('Please check the datafile name!');
    guidata(hObject,handles);
    return;
end
set(handles.data_file_edit,'String',DFILE);
ISDATAFILE=1; % Make sure that the datafile is selected.
% Calculate the average width
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
[DMATSIZE l]=size(DMATRIX);
if DMATSIZE <= BMATSIZE
    BMATSIZE=DMATSIZE;
end
strain=(DMATRIX(1:BMATSIZE,5)).*2540./init_length;
stress=(DMATRIX(1:BMATSIZE,1)-BMATRIX(1:BMATSIZE,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');
set(handles.plot_range_slider1,'Value',100)
set(handles.calculate_pushbutton,'Enable','on');
guidata(hObject, handles);


function modulus_result_Callback(hObject, eventdata, handles)
% hObject    handle to modulus_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modulus_result as text
%        str2double(get(hObject,'String')) returns contents of modulus_result as a double


% --- Executes during object creation, after setting all properties.
function modulus_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modulus_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tensile_strength_result_Callback(hObject, eventdata, handles)
% hObject    handle to tensile_strength_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tensile_strength_result as text
%        str2double(get(hObject,'String')) returns contents of tensile_strength_result as a double


% --- Executes during object creation, after setting all properties.
function tensile_strength_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tensile_strength_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function avg_width=mean_width(handles)
% Calculate the mean width by inputed value
width1=str2double(get(handles.width_edit1,'String'));
width2=str2double(get(handles.width_edit2,'String'));
width3=str2double(get(handles.width_edit3,'String'));
avg_width=(width1+width2+width3)/3.0;

function avg_length=mean_length(handles)
% Calculate the mean width by inputed value
length1=str2double(get(handles.length_edit1,'String'));
length2=str2double(get(handles.length_edit2,'String'));
length3=str2double(get(handles.length_edit3,'String'));
avg_length=(length1+length2+length3)/3.0;


% --- Executes on slider movement.
function start_range_slider_Callback(hObject, eventdata, handles)
% hObject    handle to start_range_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global BMATRIX;
global DMATRIX;
global BMATSIZE;
sliderValue=get(handles.plot_range_slider1,'Value');
sliderRange=floor(sliderValue/100*BMATSIZE);
startValue=get(handles.start_range_slider,'Value');
startRange=floor(startValue)+1;
avg_width=mean_width(handles);
avg_length=mean_length(handles);
init_length=str2double(get(handles.init_length_edit,'String'));
strain=(DMATRIX(startRange:sliderRange,5)).*2540./init_length;
stress=(DMATRIX(startRange:sliderRange,1)-BMATRIX(startRange:sliderRange,2)).*4447.5./(avg_length*avg_width);
compensation=stress(1);
stress=stress-compensation;
axes(handles.axes1);
plot(strain,stress,'r*');
xlabel('Strain (%)');
ylabel('Stress (KPa)');

% --- Executes during object creation, after setting all properties.
function start_range_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_range_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



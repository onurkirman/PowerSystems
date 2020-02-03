function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 30-Dec-2019 14:23:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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




% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;
clc; % cleans the command window

    % --- Data extraction starts here
    bus_table = readtable('myExcel.xlsx','Sheet','BUS');
    branch_table = readtable('myExcel.xlsx','Sheet','BRANCH');



    handles.BUS1_V = bus_table{3,2};
    handles.BUS1_TETA = bus_table{4,2};
    handles.BUS2_P = bus_table{1,3};
    handles.BUS2_Q = bus_table{2,3};
    handles.BUS3_P = bus_table{1,4};
    handles.BUS3_Q = bus_table{2,4};


    % impedance taken from the excel array
    handles.Z12 = str2double(cell2mat(branch_table{1,3}));
    handles.Z13 = str2double(cell2mat(branch_table{1,4}));
    handles.Z23 = str2double(cell2mat(branch_table{2,4}));

    % YBUS creation
    handles.Y12 = 1/handles.Z12;
    handles.Y13 = 1/handles.Z13;
    handles.Y23 = 1/handles.Z23;

    handles.Y_BUS = [   -(handles.Y12 + handles.Y13),          handles.Y12,          handles.Y13; 
                         handles.Y12, -(handles.Y23 + handles.Y12),          handles.Y23;
                         handles.Y13,          handles.Y23, -(handles.Y13 + handles.Y23); ]


    % Real
    handles.G21 = real(handles.Y_BUS(2,1));
    handles.G22 = real(handles.Y_BUS(2,2));
    handles.G23 = real(handles.Y_BUS(2,3));

    handles.G31 = real(handles.Y_BUS(3,1));
    handles.G32 = real(handles.Y_BUS(3,2));
    handles.G33 = real(handles.Y_BUS(3,3));

    handles.G11 = real(handles.Y_BUS(1,1));
    handles.G12 = real(handles.Y_BUS(1,2));
    handles.G13 = real(handles.Y_BUS(1,3));
    handles.G1 = [handles.G11,handles.G12,handles.G13];
    

    % Imaginary
    handles.B21 = imag(handles.Y_BUS(2,1));
    handles.B22 = imag(handles.Y_BUS(2,2));
    handles.B23 = imag(handles.Y_BUS(2,3));

    handles.B31 = imag(handles.Y_BUS(3,1));
    handles.B32 = imag(handles.Y_BUS(3,2));
    handles.B33 = imag(handles.Y_BUS(3,3));

    handles.B11 = imag(handles.Y_BUS(1,1));
    handles.B12 = imag(handles.Y_BUS(1,2));
    handles.B13 = imag(handles.Y_BUS(1,3));
    handles.B1 = [handles.B11,handles.B12,handles.B13];
    

    syms V2 V3 TETA2 TETA3
    handles.P2 = V2*(handles.G21*cos(TETA2)+handles.B21*sin(TETA2)) + V2.^2*(handles.G22) + V2*V3*(handles.G23*cos(TETA2-TETA3)+handles.B23*sin(TETA2-TETA3));
    handles.P3 = V3*(handles.G31*cos(TETA3)+handles.B31*sin(TETA3)) + V3*V2*(handles.G32*cos(TETA3-TETA2)+handles.B32*sin(TETA3-TETA2)) + V3.^2*(handles.G33);

    handles.Q2 = V2*(handles.G21*sin(TETA2)-handles.B21*cos(TETA2)) - V2.^2*(handles.B22) + V2*V3*(handles.G23*sin(TETA2-TETA3)-handles.B23*cos(TETA2-TETA3));
    handles.Q3 = V3*(handles.G31*sin(TETA3)-handles.B31*cos(TETA3)) + V3*V2*(handles.G32*sin(TETA3-TETA2)-handles.B32*cos(TETA3-TETA2)) - V3.^2*(handles.B33);

    handles.J = jacobian([handles.P2; handles.P3; handles.Q2; handles.Q3],[V2; V3; TETA2; TETA3]);
    handles.X = [V2; V3; TETA2; TETA3];
    handles.fArray = [handles.P2 + handles.BUS2_P; handles.P3 + handles.BUS3_P; handles.Q2 + handles.BUS2_Q; handles.Q3 + handles.BUS3_Q];
    % --- Data extraction ends here
    set(handles.text18,'String',handles.BUS1_V);
    set(handles.text17,'String',handles.BUS1_TETA);
    set(handles.text21,'String',handles.BUS2_P);
    set(handles.text23,'String',handles.BUS3_P);
    set(handles.text22,'String',handles.BUS2_Q);
    set(handles.text24,'String',handles.BUS3_Q);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% NEWTON RAPHSON BUTTON
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
out = NewtonRaphson(handles.X, handles.fArray, handles.J);
powerOut = slackPower(handles.B1,handles.G1,out(1), out(2), out(3),out(4));
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String',out(1));
set(handles.text3,'String',out(2));
set(handles.text4,'String',out(3));
set(handles.text5,'String',out(4));
set(handles.text20,'String',double(powerOut(1)));
set(handles.text19,'String',double(powerOut(2)));



% DISHONEST NR BUTTON
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
out = dishonestNewtonRaphson(handles.X, handles.fArray, handles.J);
powerOut = slackPower(handles.B1,handles.G1,out(1), out(2), out(3),out(4));
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String',out(1));
set(handles.text3,'String',out(2));
set(handles.text4,'String',out(3));
set(handles.text5,'String',out(4));
set(handles.text20,'String',double(powerOut(1)));
set(handles.text19,'String',double(powerOut(2)));



% GAUSS SEIDEL BUTTON
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
out = GaussSeidel(handles.Y_BUS,handles.BUS2_P, handles.BUS3_P, handles.BUS2_Q, handles.BUS3_Q, handles.BUS1_V)
powerOut = slackPower(handles.B1,handles.G1,out(1), out(2), out(3),out(4));
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String',out(1));
set(handles.text3,'String',out(2));
set(handles.text4,'String',out(3));
set(handles.text5,'String',out(4));
set(handles.text20,'String',double(powerOut(1)));
set(handles.text19,'String',double(powerOut(2)));


% DECOUPLED BUTTON
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
out = DecoupledPF(handles.X, handles.fArray, handles.J);
powerOut = slackPower(handles.B1,handles.G1,out(1), out(2), out(3),out(4));
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String',out(1));
set(handles.text3,'String',out(2));
set(handles.text4,'String',out(3));
set(handles.text5,'String',out(4));
set(handles.text20,'String',double(powerOut(1)));
set(handles.text19,'String',double(powerOut(2)));


% RESET BUTTON
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'String','');
set(handles.text3,'String','');
set(handles.text4,'String','');
set(handles.text5,'String','');
set(handles.text19,'String','');
set(handles.text20,'String','');

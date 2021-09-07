% MATLAB controller for Webots
% File:          Ned_Matlab.m
% Date:
% Description:
% Author: yo
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

TIME_STEP = 64;

% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);
%  motor = wb_robot_get_device('motor');

m1=wb_robot_get_device('motor1');
m2=wb_robot_get_device('motor2');
m3=wb_robot_get_device('motor3');

%HOME
wb_motor_set_position(m1,0)
wb_motor_set_position(m2,0)
wb_motor_set_position(m3,0)

fig = uifigure('Name','Sliders Ned');
fig.WindowStyle='modal';
fig.Position=[500 500 600 500];

% Creación de Matrices
uit=uitable(fig,'Data',zeros(4),'ColumnName',{},'Position',[50 255 200 90],...
    'ColumnWidth','1x','RowName',{},'RowStriping',0);
uit1=uitable(fig,'Data',zeros(4),'ColumnName',{},'Position',[250 255 200 90],...
    'ColumnWidth','1x','RowName',{},'RowStriping',0);
uit2=uitable(fig,'Data',zeros(4),'ColumnName',{},'Position',[50 375 200 90],...
    'ColumnWidth','1x','RowName',{},'RowStriping',0);
uit3=uitable(fig,'Data',zeros(4),'ColumnName',{},'Position',[250 375 200 90],...
    'ColumnWidth','1x','RowName',{},'RowStriping',0);

%Labels Tablas
uilabel(fig,'Position',[50 357 60 22],'Text','A0->1');
uilabel(fig,'Position',[250 357 60 22],'Text','A1->2');
uilabel(fig,'Position',[250 237 60 22],'Text','AT');
uilabel(fig,'Position',[50 237 60 22],'Text','A3->4');

%Variables 
global t1_a d1_a a1_a alf1_a t2_a d2_a a2_a alf2_a t3_a d3_a a3_a alf3_a
t1_a=0;
d1_a=0;
a1_a=0;
alf1_a=pi/2; 
t2_a=0+pi/2;
d2_a=0; 
a2_a=0.2106;
alf2_a=0; 
t3_a=0-pi/2;
d3_a=0; 
a3_a=0.23376;
alf3_a=0;

%Labels
lbl1=uilabel(fig,'Position',[10 150 31 22]);
lbl2=uilabel(fig,'Position',[210 150 31 22]);

lbl3=uilabel(fig,'Position',[410 150 31 22])

%Slider
sld1= uislider(fig,'Position',[10 100 150 3],'ValueChangedFcn',@(sld1, event) sliderChanged1(sld1,lbl1,uit1,uit2));
sld1.Limits=[-3 1];
sld2= uislider(fig,'Position',[210 100 150 3],'ValueChangedFcn',@(sld2, event) sliderChanged2(sld2,lbl2,uit1,uit3));
sld2.Limits=[-1 1];
sld3= uislider(fig,'Position',[410 100 150 3],'ValueChangedFcn',@(sld3, event) sliderChanged3(sld3,lbl3,uit1,uit));
sld3.Limits=[-1 1];

%Textos
text=uieditfield(fig,'numeric','ValueChangedFcn',@(text, event) numberChanged(text, sld1,uit1,uit2));
text.Position=[10 200 100 22];
text2=uieditfield(fig,'numeric','ValueChangedFcn',@(text2, event) numberChanged2(text2, sld2,uit1,uit3));
text2.Position=[210 200 100 22];
text3=uieditfield(fig,'numeric','ValueChangedFcn',@(text3, event) numberChanged3(text3, sld3,uit1,uit));
text3.Position=[410 200 100 22];

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination

global A0_1A A1_2A A2_3A AtA
A0_1A=[cos(t1_a) -sin(t1_a)*cos(alf1_a) sin(t1_a)*sin(alf1_a) a1_a*cos(t1_a);
    sin(t1_a) cos(t1_a)*cos(alf1_a) -cos(t1_a)*sin(alf1_a) a1_a*sin(t1_a);
    0 sin(alf1_a) cos(alf1_a) d1_a;0 0 0 1];

A1_2A=[cos(t2_a) -sin(t2_a)*cos(alf2_a) sin(t2_a)*sin(alf2_a) a2_a*cos(t2_a);
    sin(t2_a) cos(t2_a)*cos(alf2_a) -cos(t2_a)*sin(alf2_a) a2_a*sin(t2_a);
    0 sin(alf2_a) cos(alf2_a) d2_a;0 0 0 1];

A2_3A=[cos(t3_a) -sin(t3_a)*cos(alf3_a) sin(t3_a)*sin(alf3_a) a3_a*cos(t3_a);
    sin(t3_a) cos(t3_a)*cos(alf3_a) -cos(t3_a)*sin(alf3_a) a3_a*sin(t3_a);
    0 sin(alf3_a) cos(alf3_a) d3_a;0 0 0 1];
AtA=A0_1A*A1_2A*A2_3A;
uit2.Data=A0_1A;
uit1.Data=AtA;
uit3.Data=A1_2A;
uit.Data=A2_3A;

while wb_robot_step(TIME_STEP) ~= -1
    t1_a=sld1.Value;
    t2_a=sld2.Value+pi/2;
    t3_a=sld3.Value-pi/2;
    wb_motor_set_position(m1,t1_a)
    wb_motor_set_position(m2,t2_a-pi/2)
    wb_motor_set_position(m3,t3_a+pi/2)
    lbl1.Text=num2str(round(t1_a,2));
    lbl2.Text=num2str(round(t2_a-pi/2,2));
    lbl3.Text=num2str(round(t3_a+pi/2,2));
  % read the sensors, e.g.:
  
  
  % if your code plots some graphics, it needs to flushed like this:
  drawnow;

end

function numberChanged(text, sld1, uit1,uit2)
    global t1_a A0_1A d1_a a1_a alf1_a AtA A2_3A A1_2A
    sld1.Value=text.Value;
    t1_a=text.Value;
    A0_1A=[cos(t1_a) -sin(t1_a)*cos(alf1_a) sin(t1_a)*sin(alf1_a) a1_a*cos(t1_a);sin(t1_a) cos(t1_a)*cos(alf1_a) -cos(t1_a)*sin(alf1_a) a1_a*sin(t1_a);0 sin(alf1_a) cos(alf1_a) d1_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit2.Data=A0_1A;
    uit1.Data=AtA;
end
function numberChanged2(text2, sld2, uit1,uit3)
    global A1_2A t2_a d2_a a2_a alf2_a AtA A0_1A A2_3A
    sld2.Value=text2.Value;
    t2_a=text2.Value+pi/2;
    A1_2A=[cos(t2_a) -sin(t2_a)*cos(alf2_a) sin(t2_a)*sin(alf2_a) a2_a*cos(t2_a);sin(t2_a) cos(t2_a)*cos(alf2_a) -cos(t2_a)*sin(alf2_a) a2_a*sin(t2_a);0 sin(alf2_a) cos(alf2_a) d2_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit3.Data=A1_2A;
    uit1.Data=AtA;
end
function numberChanged3(text3, sld3, uit1,uit)
    global A2_3A t3_a d3_a a3_a alf3_a AtA A0_1A A1_2A
    sld3.Value=text3.Value;
    t3_a=text3.Value-pi/2;
    A2_3A=[cos(t3_a) -sin(t3_a)*cos(alf3_a) sin(t3_a)*sin(alf3_a) a3_a*cos(t3_a);sin(t3_a) cos(t3_a)*cos(alf3_a) -cos(t3_a)*sin(alf3_a) a3_a*sin(t3_a);0 sin(alf3_a) cos(alf3_a) d3_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit.Data=A2_3A;
    uit1.Data=AtA;
end
% cleanup code goes here: write data to files, etc.

function sliderChanged1(sld1, lbl1, uit1,uit2)
    global t1_a A0_1A d1_a a1_a alf1_a AtA A2_3A A1_2A
    t1_a=sld1.Value;
    lbl1.Text=num2str(sld1.Value);
    A0_1A=[cos(t1_a) -sin(t1_a)*cos(alf1_a) sin(t1_a)*sin(alf1_a) a1_a*cos(t1_a);sin(t1_a) cos(t1_a)*cos(alf1_a) -cos(t1_a)*sin(alf1_a) a1_a*sin(t1_a);0 sin(alf1_a) cos(alf1_a) d1_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit2.Data=A0_1A;
    uit1.Data=AtA;
end
function sliderChanged2(sld2, lbl2, uit1,uit3)
    global A1_2A t2_a d2_a a2_a alf2_a AtA A0_1A A2_3A
    t2_a=sld2.Value+pi/2;
    lbl2.Text=num2str(sld2.Value);
    A1_2A=[cos(t2_a) -sin(t2_a)*cos(alf2_a) sin(t2_a)*sin(alf2_a) a2_a*cos(t2_a);sin(t2_a) cos(t2_a)*cos(alf2_a) -cos(t2_a)*sin(alf2_a) a2_a*sin(t2_a);0 sin(alf2_a) cos(alf2_a) d2_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit3.Data=A1_2A;
    uit1.Data=AtA;
end
function sliderChanged3(sld3, lbl3, uit1,uit)
    global A2_3A t3_a d3_a a3_a alf3_a AtA A0_1A A1_2A
    t3_a=sld3.Value-pi/2;
    lbl3.Text=num2str(sld3.Value);
    A2_3A=[cos(t3_a) -sin(t3_a)*cos(alf3_a) sin(t3_a)*sin(alf3_a) a3_a*cos(t3_a);sin(t3_a) cos(t3_a)*cos(alf3_a) -cos(t3_a)*sin(alf3_a) a3_a*sin(t3_a);0 sin(alf3_a) cos(alf3_a) d3_a;0 0 0 1];
    AtA=A0_1A*A1_2A*A2_3A;
    uit.Data=A2_3A;
    uit1.Data=AtA;
end
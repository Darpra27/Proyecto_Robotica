% MATLAB controller for Webots
% File:          Scara_Matlab.m
% Date:
% Description:
% Author:
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

TIME_STEP = 64;

% get and enable devices, e.g.:

m1=wb_robot_get_device('Eje_1');
m2=wb_robot_get_device('Eje_2');
m3=wb_robot_get_device('Actuador');

%HOME
wb_motor_set_position(m1,0)
wb_motor_set_position(m2,0)
wb_motor_set_position(m3,0)

aux=0;

fig = uifigure('Name','Sliders Scara');
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
global t1_s d1_s a1_s alf1_s t2_s d2_s a2_s alf2_s t3_s d3_s a3_s alf3_s
t1_s=0.0;
d1_s=0;
a1_s=0.325;
alf1_s=0;
t2_s=0.0; 
d2_s=0;
a2_s=0.275;
alf2_s=0;
t3_s=0;
d3_s=-0.04;
a3_s=0;
alf3_s=0;
%


lbl1=uilabel(fig,'Position',[10 150 31 22]);
lbl2=uilabel(fig,'Position',[210 150 31 22]);
lbl3=uilabel(fig,'Position',[410 150 31 22]);

sld1= uislider(fig,'Position',[10 100 150 3],'ValueChangedFcn',@(sld1, event) sliderChanged1(sld1,lbl1,uit1,uit2));
sld1.Limits=[-1.5 2];
sld2= uislider(fig,'Position',[210 100 150 3],'ValueChangedFcn',@(sld2, event) sliderChanged2(sld2,lbl2,uit1,uit3));
sld2.Limits=[-2.5 1.5];
sld3= uislider(fig,'Position',[410 100 150 3],'ValueChangedFcn',@(sld3, event) sliderChanged3(sld3,lbl3,uit1,uit));
sld3.Limits=[-0.15 0];

text=uieditfield(fig,'numeric','ValueChangedFcn',@(text, event) numberChanged(text, sld1, uit1,uit2));
text.Position=[10 200 100 22];
text2=uieditfield(fig,'numeric','ValueChangedFcn',@(text2, event) numberChanged2(text2, sld2, uit1,uit3));
text2.Position=[210 200 100 22];
text3=uieditfield(fig,'numeric','ValueChangedFcn',@(text3, event) numberChanged3(text3, sld3));
text3.Position=[410 200 100 22];

global A0_1S A1_2S A2_3S AtS
A0_1S=[cos(t1_s) -sin(t1_s)*cos(alf1_s) sin(t1_s)*sin(alf1_s) a1_s*cos(t1_s);sin(t1_s) cos(t1_s)*cos(alf1_s) -cos(t1_s)*sin(alf1_s) a1_s*sin(t1_s);0 sin(alf1_s) cos(alf1_s) d1_s;0 0 0 1];
A1_2S=[cos(t2_s) -sin(t2_s)*cos(alf2_s) sin(t2_s)*sin(alf2_s) a2_s*cos(t2_s);sin(t2_s) cos(t2_s)*cos(alf2_s) -cos(t2_s)*sin(alf2_s) a2_s*sin(t2_s);0 sin(alf2_s) cos(alf2_s) d2_s;0 0 0 1];
A2_3S=[cos(t3_s) -sin(t3_s)*cos(alf3_s) sin(t3_s)*sin(alf3_s) a3_s*cos(t3_s);sin(t3_s) cos(t3_s)*cos(alf3_s) -cos(t3_s)*sin(alf3_s) a3_s*sin(t3_s);0 sin(alf3_s) cos(alf3_s) d3_s;0 0 0 1];
AtS=A0_1S*A1_2S*A2_3S;
uit2.Data=A0_1S;
uit1.Data=AtS;
uit3.Data=A1_2S;
uit.Data=A2_3S;
while wb_robot_step(TIME_STEP) ~= -1
  %Variables
  t1_s=sld1.Value;
  t2_s=sld2.Value;
  d3_s=-0.04+sld3.Value;
  
  wb_motor_set_position(m1,t1_s)
  wb_motor_set_position(m2,t2_s)
  wb_motor_set_position(m3,d3_s+0.04)
  lbl1.Text=num2str(round(t1_s,2));
  lbl2.Text=num2str(round(t2_s,2));
  lbl3.Text=num2str(round(d3_s+0.04,2));
  
  
  %Mostrar matrices
   
  % if your code plots some graphics, it needs to flushed like this:
  drawnow;

end

function numberChanged(text, sld1, uit1,uit2)
    global t1_s A0_1S d1_s a1_s alf1_s AtS A2_3S A1_2S
    sld1.Value=text.Value;
    t1_s=text.Value;
    A0_1S=[cos(t1_s) -sin(t1_s)*cos(alf1_s) sin(t1_s)*sin(alf1_s) a1_s*cos(t1_s);sin(t1_s) cos(t1_s)*cos(alf1_s) -cos(t1_s)*sin(alf1_s) a1_s*sin(t1_s);0 sin(alf1_s) cos(alf1_s) d1_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit2.Data=A0_1S;
    uit1.Data=AtS;
end
function numberChanged2(text2, sld2, uit1,uit3)
    global A1_2S t2_s d2_s a2_s alf2_s AtS A0_1S A2_3S
    sld2.Value=text2.Value;
    t2_s=text2.Value;
    A1_2S=[cos(t2_s) -sin(t2_s)*cos(alf2_s) sin(t2_s)*sin(alf2_s) a2_s*cos(t2_s);sin(t2_s) cos(t2_s)*cos(alf2_s) -cos(t2_s)*sin(alf2_s) a2_s*sin(t2_s);0 sin(alf2_s) cos(alf2_s) d2_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit3.Data=A1_2S;
    uit1.Data=AtS;
end
function numberChanged3(text3, sld3, uit1,uit)
    global A2_3S t3_s d3_s a3_s alf3_s AtS A0_1S A1_2S
    sld3.Value=text3.Value;
    d3_s=text3.Value;
    A2_3S=[cos(t3_s) -sin(t3_s)*cos(alf3_s) sin(t3_s)*sin(alf3_s) a3_s*cos(t3_s);sin(t3_s) cos(t3_s)*cos(alf3_s) -cos(t3_s)*sin(alf3_s) a3_s*sin(t3_s);0 sin(alf3_s) cos(alf3_s) d3_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit.Data=A2_3S;
    uit1.Data=AtS;
end

function sliderChanged1(sld1, lbl1, uit1,uit2)
    global t1_s A0_1S d1_s a1_s alf1_s AtS A2_3S A1_2S
    t1_s=sld1.Value;
    lbl1.Text=num2str(sld1.Value);
    A0_1S=[cos(t1_s) -sin(t1_s)*cos(alf1_s) sin(t1_s)*sin(alf1_s) a1_s*cos(t1_s);sin(t1_s) cos(t1_s)*cos(alf1_s) -cos(t1_s)*sin(alf1_s) a1_s*sin(t1_s);0 sin(alf1_s) cos(alf1_s) d1_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit2.Data=A0_1S;
    uit1.Data=AtS;
end
function sliderChanged2(sld2, lbl2, uit1,uit3)
    global A1_2S t2_s d2_s a2_s alf2_s AtS A0_1S A2_3S
    t2_s=sld2.Value;
    lbl2.Text=num2str(sld2.Value);
    A1_2S=[cos(t2_s) -sin(t2_s)*cos(alf2_s) sin(t2_s)*sin(alf2_s) a2_s*cos(t2_s);sin(t2_s) cos(t2_s)*cos(alf2_s) -cos(t2_s)*sin(alf2_s) a2_s*sin(t2_s);0 sin(alf2_s) cos(alf2_s) d2_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit3.Data=A1_2S;
    uit1.Data=AtS;
end
function sliderChanged3(sld3, lbl3, uit1,uit)
    global A2_3S t3_s d3_s a3_s alf3_s AtS A0_1S A1_2S
    d3_s=-0.04+sld3.Value;
    lbl3.Text=num2str(sld3.Value);
    A2_3S=[cos(t3_s) -sin(t3_s)*cos(alf3_s) sin(t3_s)*sin(alf3_s) a3_s*cos(t3_s);sin(t3_s) cos(t3_s)*cos(alf3_s) -cos(t3_s)*sin(alf3_s) a3_s*sin(t3_s);0 sin(alf3_s) cos(alf3_s) d3_s;0 0 0 1];
    AtS=A0_1S*A1_2S*A2_3S;
    uit.Data=A2_3S;
    uit1.Data=AtS;
end
% cleanup code goes here: write data to files, etc.

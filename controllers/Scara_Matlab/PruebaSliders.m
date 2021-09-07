fig = uifigure('Name','Sliders');
fig.WindowStyle='modal';
fig.Position=[500 500 600 500];

lbl1=uilabel(fig,'Position',[10 150 31 22]);

sld1= uislider(fig,'Position',[10 100 150 3],'ValueChangedFcn',@(sld1, event) numberChanged(sld1,lbl1));
sld1.Limits=[-3 1];
sld2= uislider(fig,'Position',[210 100 150 3]);
sld2.Limits=[-1 1];
sld3= uislider(fig,'Position',[410 100 150 3]);
sld3.Limits=[-2 1];

text=uieditfield(fig,'numeric');
text.Position=[100 200 100 22];

uit=uitable(fig,'Data',zeros(4));
uit.ColumnName={};
uit.Position=[10 250 200 90];
uit.ColumnWidth='1x';
uit.RowName={};
uit.RowStriping=0;

sep_w=9;
edit_w=50;
edit_h=20;
n=4;
m=4;
sep_h=5;
edit=zeros(n,m);
t1_s=0.000000000000;
d1_s=0;
a1_s=0.325;
alf1_s=0;
t2_s=0.00000000000000; 
d2_s=0;
a2_s=0.275;
alf2_s=0;
t3_s=0.0000000000000000;
d3_s=0.04+0.0000000000000; 
a3_s=0;
alf3_s=0;


A0_1S=[cos(t1_s) -sin(t1_s)*cos(alf1_s) sin(t1_s)*sin(alf1_s) a1_s*cos(alf1_s);sin(t1_s) cos(t1_s)*cos(alf1_s) -cos(t1_s)*sin(alf1_s) a1_s*sin(t1_s);0 sin(alf1_s) cos(alf1_s) d1_s;0 0 0 1];

A1_2S=[cos(t2_s) -sin(t2_s)*cos(alf2_s) sin(t2_s)*sin(alf2_s) a2_s*cos(alf2_s);sin(t2_s) cos(t2_s)*cos(alf2_s) -cos(t2_s)*sin(alf2_s) a2_s*sin(t2_s);0 sin(alf2_s) cos(alf2_s) d2_s;0 0 0 1];

A2_3S=[cos(t3_s) -sin(t3_s)*cos(alf3_s) sin(t3_s)*sin(alf3_s) a3_s*cos(alf3_s);sin(t3_s) cos(t3_s)*cos(alf3_s) -cos(t3_s)*sin(alf3_s) a3_s*sin(t3_s);0 sin(alf3_s) cos(alf3_s) d3_s;0 0 0 1];

AtS=A0_1S*A1_2S*A2_3S;
global cosa;
cosa=0;
uit.Data=A0_1S;
function numberChanged(sld1, lbl1)
global cosa    
lbl1.Text=num2str(sld1.Value);
    cosa=4+1
end

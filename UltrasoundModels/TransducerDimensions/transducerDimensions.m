% transducerDimensions - Generate the key dimensions of our transducer
% to plug into solidworks
% 
field_init(-1)


a = 120/1000;
b = 100/1000;
D = [9.5,9.5]/1000;
kerf= 1/1000;
n_elements_r = 43;
n_elements_z = 6;
R_focus = a;

len_z = (D(2)+kerf)*n_elements_z;
AngExtent_z = len_z/ R_focus;
angle_inc_z = AngExtent_z/n_elements_z;
index_z = -1*(-1+0.5:5-0.5);%-n_elements_z+0.9:0;
angle_z = index_z* angle_inc_z;
angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);

rectangles=[];
i = 1;
focused_rectangles = [];
for k=1:length(angle_z)
    x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
    rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
    rect = rect';
    rot = makexrotform(angle_z(k));
    rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+R_focus;
    positioned_rect = apply_affine_to_rect(rot, rect);
%           Append to transducer geometry
    focused_rectangles = horzcat(focused_rectangles, positioned_rect);
end

cent = focused_rectangles(end-2:end,:);
Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
show_xdc(Th);

Z = [4,7,10,13];
Y = [3,6,9,12];
mv = min(focused_rectangles(Z,:),[],'all');
fR = focused_rectangles;
fR([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;


columnCoordinates = 1000*horzcat(fR(Z(1),:)', fR(Y(1),:)',fR(Z(4),:)',fR(Y(4),:)');
columnCoordinates = horzcat((0:5)',zeros(6,1),flipud(columnCoordinates));


T = table(columnCoordinates);
writetable(T,'ColumnCoordinates.xlsm','Sheet',1,'Range','A3:F9','WriteVariableNames',0)


format long;
disp("firstElementTopX--- ")
disp(focused_rectangles(10,1))
disp("firstElementTopY--- ")
disp(focused_rectangles(9,1))
disp("firstElementBottomY--- ")
disp(focused_rectangles(3,1))
disp("firstElementBottomX--- ")
disp(focused_rectangles(4,1))
disp("elementSpaceingDegrees--- ")
disp(rad2deg(angle_inc_z))

% Generate the xy table for column placement
xy = [a*cos(angle_r(i)),b*sin(angle_r(i))]*1000;

test_xlm = [0,0,100,42,23; 1,0, 50,10,10; 2,0, 0, 0,0];
T = table(test_xlm);
writetable(T,'file.xlsm','Sheet',1,'Range','A3:E6','WriteVariableNames',0)

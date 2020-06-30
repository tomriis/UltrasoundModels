% transducerDimensions - Generate the key dimensions of our transducer
% to plug into solidworks
% 
field_init(-1)


a = 120/1000;
b = 100/1000;
D = [9.5,9.5]/1000;
kerf= 1/1000;
n_elements_r = 44;
n_elements_z = 6;
R_focus = a;
filebase = 'C:\Users\Tom\Documents\MATLAB\UltrasoundModels\UltrasoundModels\TransducerDimensions\';
len_z = (D(2)+kerf)*n_elements_z;
AngExtent_z = len_z/ R_focus;
angle_inc_z = AngExtent_z/n_elements_z;
index_z = -1*(-1+0.5:5-0.5);%-n_elements_z+0.9:0;
angle_z = index_z* angle_inc_z;
% angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);

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



Z = [4,7,10,13];
Y = [3,6,9,12];
X = [2,5,8,11];
mv = min(focused_rectangles(Z,:),[],'all');
fR = focused_rectangles;
fR([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
offsetY = abs(min(fR(Y,:),[],'all'))+0.010;
fR([Y,18],:) = fR([Y,18],:)+offsetY;


columnCoordinates = 1000*horzcat(fR(Z(1),:)', fR(Y(1),:)',fR(Z(4),:)',fR(Y(4),:)');
columnCoordinates = horzcat((0:5)',zeros(6,1),flipud(columnCoordinates));
cent = fR(end-2:end,:);
Th = xdc_rectangles(fR', cent', [0,0,0]);
show_xdc(Th);

T = table(columnCoordinates);
% writetable(T,[filebase,'ColumnCoordinates.xlsm'],'Sheet',1,'Range','A3:F9','WriteVariableNames',0)
% %%
% 
field_init(-1)
[Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b);
rect = xdc_pointer_to_rect(Th);
show_transducer('Th',Th);
set(gca,'fontSize',11)
% set(findall(h,'type','text'),'color','k')
set(gcf,'color','w')
field_end();
% Parse rect for (X3, Z3) and (X4,Z4) of the innermost element
% columnDepth = 31;
% arrayColumnCoordinates = [];
% for i =1:size(rect,2)
%     if mod(i,6) == 0
%         rectCoordinates =1000*[rect(X(3), i), rect(Z(3),i),...
%             rect(X(4),i), rect(Z(4),i)];
%         v3 = rectCoordinates(1:2);
%         v3norm = v3/norm(v3);
%         vBack = v3 + columnDepth*v3norm;
%         %rectCoordinates = [rectCoordinates, vBack(2)];
%         arrayColumnCoordinates = vertcat(arrayColumnCoordinates,rectCoordinates);
%     end
% end
% % Start at column with all positive coordinates
% posInd = find(sum(arrayColumnCoordinates>0,2)==4);
% posInd = posInd(1);
% arrayColumnCoordinates = circshift(arrayColumnCoordinates,-1*posInd,1);
% arrayColumnCoordinates = [(0:(n_elements_r-1))', zeros(n_elements_r,1),...
%     arrayColumnCoordinates];
% T = table(arrayColumnCoordinates);
% arrayColumnCoordinates(1:3,:)
% writetable(T,[filebase,'ArrayColumnCoordinates.xlsm'],...
%     'Sheet',1,'Range',['A3:F',num2str(2+n_elements_r)],...
%     'WriteVariableNames',0);

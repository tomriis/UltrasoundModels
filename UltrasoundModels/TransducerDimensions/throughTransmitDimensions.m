field_init(-1)


a = 110/1000;
b = 90/1000;
D = [9.2,9.2]/1000; %[9.55,9.55]/1000;
kerf= 0.35/1000; %0.40/1000;
n_elements_r = 32;
n_elements_z = 8;
R_focus = 1.5*a;
columnAngle = 0.5;
filebase = 'C:\Users\Tom\Documents\MATLAB\UltrasoundModels\UltrasoundModels\TransducerDimensions\';

angle_z = arrayColumnAngleZ(R_focus, kerf,D,n_elements_z,n_elements_z/2);

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
offsetY = abs(min(fR(Y,:),[],'all'))+0.0080;
fR([Y,18],:) = fR([Y,18],:)+offsetY;

columnCoordinates = 1000*horzcat(fR(Z(1),:)', fR(Y(1),:)',fR(Z(4),:)',fR(Y(4),:)');
columnCoordinates = horzcat((0:(n_elements_z-1))',zeros(n_elements_z,1),flipud(columnCoordinates));
cent = fR(end-2:end,:);
Th = xdc_rectangles(fR', cent', [0,0,0]);
figure; show_xdc(Th);

% T = table(columnCoordinates);
% writetable(T,[filebase,'throughTransmitColumnCoordinates.xlsm'],'Sheet',1,'Range','A3:F19','WriteVariableNames',0)
% %%
% 
field_init(-1)
[Th] = throughTransmitArray(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,columnAngle);
rect = xdc_pointer_to_rect(Th);
figure; show_transducer('Th',Th,'plotEl',[72-8,72]);
disp(sqrt(sum((rect(8:10,72-8)-rect(11:13,72)).^2))*1000);
set(gca,'fontSize',11)
% set(findall(h,'type','text'),'color','k')
set(gcf,'color','w')
field_end();
% Parse rect for (X3, Z3) and (X4,Z4) of the innermost element
columnDepth = 31;
arrayColumnCoordinates = [];
for i =1:size(rect,2)
    if mod(i,n_elements_z) == 0
        rectCoordinates =1000*[rect(X(3), i), rect(Z(3),i),...
            rect(X(4),i), rect(Z(4),i)];
        arrayColumnCoordinates = vertcat(arrayColumnCoordinates,rectCoordinates);
    end
end
% Start at column with all positive coordinates
posInd = find(sum(arrayColumnCoordinates>0,2)==4);
posInd = posInd(1);
circShiftInd = -1*(posInd-1);
arrayColumnCoordinates = circshift(arrayColumnCoordinates,circShiftInd,1);
%% circshift rect to match arrayColumnCoordinates
rect2 = circshift(rect,circShiftInd*n_elements_z,2);


% Generate Excell file
arrayColumnCoordinates = [(0:(n_elements_r-1))', zeros(n_elements_r,1),...
    arrayColumnCoordinates];
T = table(arrayColumnCoordinates);
arrayColumnCoordinates(1:3,:)
% writetable(T,[filebase,'throughTransmitArrayColumnCoordinates.xlsm'],...
%     'Sheet',1,'Range',['A3:F',num2str(2+n_elements_r)],...
%     'WriteVariableNames',0);




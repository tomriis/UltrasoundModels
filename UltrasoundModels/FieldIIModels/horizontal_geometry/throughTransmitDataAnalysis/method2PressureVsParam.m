S = load("D:\modularGeometryOptimization\testMethod2Geometry.mat");
data = S.data;
R_Focus_Ratio = [1, 1.5, 2, 4, 100000];
xdr_angle = [0,0.5,1,2,100000];
I = [];
R_focus = [];
for i = 1:length(data)
    if data(i).columnAngle == 1
        if strcmp(data(i).plane,'xy')
            I(end+1)=max(data(i).max_hp,[],'all');
            R_focus(end+1) = data(i).R_focus;
        end
    end
end
x1 = 1:length(R_focus);
rFocusLabels= {'R','1.5R','2R','4R','Flat'};
plotIVsParam(I,x1, 'Radius of Focus')
xticks(x1)
xticklabels(rFocusLabels)

I2 = [];
columnAngle = [];
for i = 1:length(data)
    if data(i).R_focus == 0.2
        if strcmp(data(i).plane,'xy')
            I2(end+1)=max(data(i).max_hp,[],'all');
            columnAngle(end+1) = data(i).columnAngle;
        end
    end
end
x2= 1:length(columnAngle);
columnAngleLabels = {'Focused','0.5','Ellipse','2','Flat'};
plotIVsParam(I2,x2, 'Angle of Columns to Center')
xticks(1:length(columnAngle))
xticklabels(columnAngleLabels)

h = figure;
I3 = zeros(length(R_focus),length(columnAngle));
for i = 1:length(data)
    m = find(data(i).R_focus==R_focus);
    n = find(data(i).columnAngle == columnAngle);
    I3(m,n) = max(data(i).max_hp,[],'all');
end
I3 = I3/max(I3,[],'all');

[X,Y] = meshgrid(x2,x1);
figure; surf(X,Y,I3)
xticklabels(columnAngleLabels);
yticklabels(rFocusLabels);
zlabel('Normalized Pressure');
xlabel('Column Angle');
ylabel('Radius Of Focus');
makeFigureBig(h);

% 
% for i = 1:length(data)
%     if data(i).R_focus == 100000*0.1
%         if data(i).columnAngle == 1
%             figure; show_transducer('data',data(i).xdcData,'plotEl',1:256);
%         end
%     end
% end
%     

            
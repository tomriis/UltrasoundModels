%% Array Geometry
array = struct();
W = [6 6]/1000;
f = 650000;
c = 1500;
Nw = 11;
Nh = 11;
Rw = 165/1000;
Rh = 165/1000;
xArrayToSagitalPlane = 95/1000; 
kerf = 1/1000;
K = W(1)*f/c;

[array.rect, elementMapping] = condensedThroughTransmitArray(Nw, Nh, Rw, Rh, W, kerf, xArrayToSagitalPlane); 
array = calculateArrayNormalVectors(array);

%% Element Contributions
% Define grid
x = linspace(-40, 40, 100)/1000; y = x; z = x;
planesData = struct();
planesData(1).axis = 'XY'; 
[planesData(1).X, planesData(1).Y, planesData(1).Z] = meshgrid(x,y,0);
planesData(2).axis = 'XZ'; 
[planesData(2).X, planesData(2).Y, planesData(2).Z] = meshgrid(x,0,z);
planesData(3).axis = 'YZ';
[planesData(3).X, planesData(3).Y, planesData(3).Z] = meshgrid(0,y,z);
for i = 1:length(planesData)
    planesData(i).X = squeeze(planesData(i).X);
    planesData(i).Y = squeeze(planesData(i).Y);
    planesData(i).Z = squeeze(planesData(i).Z);
end

tic;
for p = 1:length(planesData)
    X = planesData(p).X;
    Y = planesData(p).Y;
    Z = planesData(p).Z;
    planesData(p).N1 = size(X, 1); planesData(p).N2 = size(X, 2);
    P = zeros(planesData(p).N1, planesData(p).N2, Nw, Nh);
    Ptotal = zeros(planesData(p).N1,planesData(p).N2);

    for i = 1:planesData(p).N1
        for j = 1:planesData(p).N2
            for ew = 1:Nw
                for eh = 1:Nh
                    xyz = [X(i,j), Y(i,j), Z(i,j)]';
                    element = array.element(elementMapping(ew,eh));
                    elementToPointV = (xyz-element.center);
                    projectionXYZtoNormal = dot(elementToPointV,element.normalVector)*element.normalVector;
                    de = norm(projectionXYZtoNormal);
                    
                    orthogXYZtoNormal = elementToPointV-projectionXYZtoNormal;
                    re = distancePointToLine(element.normalVector, element.center, xyz);
                    rx = norm(dot(orthogXYZtoNormal, element.xNorm));
                    ry = norm(dot(orthogXYZtoNormal, element.yNorm));             
                    P(i,j,ew,eh) = 1/de * sinc(K * rx / de) * sinc(K * ry / de); %sinc(K * re / de); 
                end
            end
            Ptotal(i,j) = sum(P(i, j, :, :), 'all');
        end
    end
    planesData(p).P = P;
    planesData(p).Ptotal = Ptotal;
end
T=toc;
%% Visualize Contributions
h = fullfig;
subplot(2,3, 1);
show_transducer('data',array.rect);
Y = [3,6,9,12,18]; Z = [4,7,10,13,19];
Width = max(array.rect(Y,:), [], 'all')-min(array.rect(Y,:), [], 'all');
Height = max(array.rect(Z,:), [], 'all')-min(array.rect(Z,:), [], 'all');
title(['Width: ', num2str(Width*1000), ' (mm)  Height: ', num2str(Height*1000)]);
subplot(2, 3, [2, 3]);
P = planesData(1).P;
center = round([planesData(1).N1/2, planesData(1).N2/2]);
contributions = squeeze(P(center(1), center(2), :, :));
contributions = contributions/max(contributions,[],'all');
imagesc(contributions');
chArray = colorbar();
caxis([0 1]);
title('Element Contribution to Center');
xlabel('Array Column');
ylabel('Array Row');
axis image;
makeFigureBig(h);

for p = 1:length(planesData)
    center = round([planesData(p).N1/2, planesData(p).N2/2]);
    Ptotal = squeeze(planesData(p).Ptotal);
    subplot(2,3,3+p);
    if p == 1
        imagesc(x*1000,y*1000, Ptotal);
        xlabel('X (mm)');
        ylabel('Y (mm)');
    elseif p == 2
        imagesc(x*1000,z*1000, Ptotal');
        xlabel('X (mm)');
        ylabel('Z (mm)');
    else
        imagesc(y*1000,z*1000, Ptotal);
        xlabel('Y (mm)');
        ylabel('Z (mm)');
    end
    title(planesData(p).axis);
    ch = colorbar();
    caxis([0 max(Ptotal,[],'all')]);
    axis image;
    makeFigureBig(h);
end


    
%% Array Geometry
array = struct();
W = [6 6]/1000;
f = 650000;
c = 1500;
Nw = 11;
Nh = 11;
Rw = 165/1000;
Rh = 165/1000;
kerf = 1/1000;
K = pi*W(1)*f/c;
xArrayToSagitalPlane = 95/1000; 
array.rect = condensedThroughTransmitArray(Nh, Nw,Rh, Rw, W, kerf, xArrayToSagitalPlane); 
array = calculateArrayNormalVectors(array);

%% Element Contributions
% Define grid
x = linspace(-40, 40, 200); y = x; z = x;
[X,Y,Z] = meshgrid(x,y,z);
Nx = size(X, 1); Ny = size(Y, 1); Nz = size(Z, 1);
P = zeros(Nx, Ny, Nz, Nw, Nh);
Ptotal = zeros(Nx,Ny,Nz);
for i = 1:Nx
    for j = 1:Ny
        for k = 1:Nz
            for ew = 1:Nw
                for eh = 1:Nh
                    xyz = [X(i,j,k), Y(i,j,k), Z(i,j,k)];
                    element = array.element(elementMapping(ew,ey));
                    re = distancePointToLine(element.normalVector, element.center, xyz);
                    de = sqrt((elementCoordinate(ew,ey) - xyz).^2);
                    P(i,j,k,ew,eh) = 1 / de * sin(K * re / de) / (K * re / de);
                end
            end
            Ptotal(i,j,k) = sum(P(i, j, k, :, :), 'all');
        end
    end
end

%% Visualize Contributions
h = fullfig;
center = round([Nx/2, Ny/2, Nz/2]);
subplot([2, 3], [1 : 3]);
imagesc(squeeze(P(center(1), center(2), center(3), :, :)));
chArray = colorbar();
title('Element Contribution to Center');
xlabel('Array Column');
ylabel('Array Row');
axis image;
makeFigureBig(h);

planes = {'XY', 'XZ', 'YZ'};
for i = 1:length(planes)
    subplot([2,3],3+i);
    if i == 1
        imagesc(squeeze(Ptotal(center(i), :, :)));
        xlabel('X (mm)');
        ylabel('Y (mm)');
    elseif i == 2
        imagesc(squeeze(Ptotal(:, center(i), :)));
        xlabel('X (mm)');
        ylabel('Z (mm)');
    else
        imagesc(squeeze(Ptotal(:, :, center(i))));
        xlabel('Y (mm)');
        ylabel('Z (mm)');
    end
    title(planes{i});
    ch = colorbar();
    axis image;
    makeFigureBig(h);
end


    
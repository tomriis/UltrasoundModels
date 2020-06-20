
% Transducer array dimensions from array column and column coordinates

X = load('arrayColumnX3Z3X4Z4.mat','X');
Y = load('columnCoordinatesZ1Y1Z4Y4.mat','Y');
arrayColumnCoords = X.X;
columnCoords = Y.Y;
X = [2,5,8,11];
Y = [3,6,9,12];
Z = [4,7,10,13];
rect = zeros(19,size(arrayColumnCoords,1)*size(columnCoords,1));
count = 1;
for i = 1:size(arrayColumnCoords,1)
    zc = sum(arrayColumnCoords(i,[2,4]))/2;
    xc = sum(arrayColumnCoords(i,[1,3]))/2;
    theta = atan2(zc, xc);
    
    for j = size(columnCoords,1):-1:1
        rect(X(1),count) = arrayColumnCoords(i,3)+columnCoords(j,1)*cos(theta);
        rect(X(2),count) = arrayColumnCoords(i,1)+columnCoords(j,1)*cos(theta);
        rect(X(3),count) = arrayColumnCoords(i,1)+columnCoords(j,3)*cos(theta);
        rect(X(4),count) = arrayColumnCoords(i,3)+columnCoords(j,3)*cos(theta);
        
        rect(Y([1,2]),count) = columnCoords(j,2);
        rect(Y([3,4]),count) = columnCoords(j,4);
        
        rect(Z(1),count) = arrayColumnCoords(i,4)+columnCoords(j,1)*sin(theta);
        rect(Z(2),count) = arrayColumnCoords(i,2)+columnCoords(j,1)*sin(theta);
        rect(Z(3),count) = arrayColumnCoords(i,2)+columnCoords(j,3)*sin(theta);
        rect(Z(4),count) = arrayColumnCoords(i,4)+columnCoords(j,3)*sin(theta);
  
        rect(17,count) = mean(rect(X,count));
        rect(18,count) = mean(rect(Y,count));
        rect(19,count) = mean(rect(Z,count));
        
        count = count + 1;
    end
end
rect = rect/1000;

figure; show_transducer('data',rect);
positions = rect(17:19,:)';
% save('horizontalElementPositions','positions');


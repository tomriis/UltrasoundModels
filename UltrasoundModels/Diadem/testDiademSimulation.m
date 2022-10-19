
W = [6 6]/1000;
f = 650000;
c = 1500;
Nw = 14;
Nh = 9;
Rw = 165/1000;
Rh = 165/1000;
xArrayToSagitalPlane = 93/1000; 

kerf = 1/1000;

focus = [0,0,0]/1000;
outputdim = 'xy';%{'xz','xy'};
dualArrayFlag = 0;
atsp = [88.5+6]/1000;
data = struct();
field_init(-1);
[allrect, txfieldmax,fieldDim] = Diadem(Nw, Nh, Rw, Rh, focus, xArrayToSagitalPlane, outputdim, dualArrayFlag);
switch outputdim
    case 'xz'
        y = fieldDim{3};
        x = fieldDim{1};
    case 'yz'
        y = fieldDim{3};
        x = fieldDim{2};
    case 'xy'
        y = fieldDim{2};
        x = fieldDim{1};
end
figure; imagesc(y,x,txfieldmax); axis image;
% figure; show_transducer('data',allrect');
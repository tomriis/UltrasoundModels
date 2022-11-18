
W = [6 6]/1000;
f = 650000;
c = 1500;
Nw = 14;
Nh = 9;
Rw = 165/1000;
Rh = 165/1000;
xArrayToSagitalPlane = 93/1000; 
saveField =1;
kerf = 1/1000;

focus = [0,0,0]/1000;
outputdim = 'yz';%{'xz','xy'};
dualArrayFlag = 1;
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
normField = txfieldmax*1e9;%./max(txfieldmax,[],'all');
normField = txfieldmax./max(txfieldmax,[],'all');
intensityField = normField.^2;
h =figure; imagesc(y*1000,x*1000,intensityField); axis image;
title(max(intensityField,[],'all'));
colorbar;
colormap hot;
makeFigureBig(h);
if saveField
    ch = colorbar;
    makeFigureBig(gcf);
    export_fig(['C:\Users\Tom\Documents\Papers\DiademDevicePaper\Figures\FieldOverlays\Intensity',num2str(outputdim),'FieldFull.pdf'],'-pdf');
end

% figure; show_transducer('data',allrect');
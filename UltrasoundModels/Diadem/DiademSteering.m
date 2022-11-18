function [txFieldMax, fieldDim] = DiademSteering(focus, planeCoordinates, planeVolume)
    W = [6 6]/1000;
    f = 650000;
    c = 1500;
    Nw = 14;
    Nh = 9;
    Rw = 165/1000;
    Rh = 165/1000;
    xArrayToSagitalPlane = 93/1000; 
    focus = focus/1000;
    outputdim = 'yz';%{'xz','xy'};
    dualArrayFlag = 1;
    field_init(-1);
    
    [~, txFieldMax,fieldDim] = Diadem(Nw, Nh, Rw, Rh, focus, xArrayToSagitalPlane, outputdim, dualArrayFlag,planeCoordinates,planeVolume);
   
    txFieldMax = txFieldMax*1e9;%./max(txfieldmax,[],'all');
end
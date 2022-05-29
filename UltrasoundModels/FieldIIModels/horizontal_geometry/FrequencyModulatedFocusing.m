
W = [6 6]/1000;
f = 650000;
c = 1500;
Nw = 14;
Nh = 9;
Rw = 165/1000;
Rh = 165/1000;
xArrayToSagitalPlane = 85/1000; 
kerf = 1/1000;
K = W(1)*f/c;
focus = [0,0,0];
[allrect,allcent] = diademGeometry(Nw, Nh, Rw, Rh, W, kerf, xArrayToSagitalPlane);
Tx = xdc_rectangles(allrect, allcent, focus);

rect = xdc_pointer_to_rect(Tx);
figure; show_transducer('data',rect,'plotEl',[1,127]);

[max_hp, sum_hilbert, xdc_data] = diadem_array_simulation(Tx);

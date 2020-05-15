nR = 26;
nY = 10;
ROC = 110;
rFocus = 1.2*ROC;
D = [6,6];
kerf = [4.6,10];

slice = {'xy','xz','yz'};
m = 3;
n = 3;
figure;
focusPoint=[0,0,0];
sim = 1;
if ~sim
    vTrans = true;
    [txfielddb, xdc_data,x,y,z] = human_array_simulation(nR,nY,ROC,D,focusPoint,'kerf',kerf,...,
        'R_focus',rFocus,'vTrans',vTrans,'Slice',plane);
end

if sim
    vTrans = false;
for i = 1:length(slice)
    plane = slice{i};
    [txfielddb, xdc_data,x,y,z] = human_array_simulation(nR,nY,ROC,D,focusPoint,'kerf',kerf,...,
        'R_focus',rFocus,'vTrans',vTrans,'Slice',plane);
    subplot(m,n,i);
    

    switch plane
        case 'xy'
            imagesc(x*1e3, y*1e3, txfielddb);
            axis equal tight;
            xlabel('x (mm)');
            ylabel('y (mm)');
            ch = colorbar; ylabel(ch, 'dB'); 
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
          
            XL = min(x)*1e3;
            XH = max(x)*1e3;
            subplot(m,n,i+3);
            plot(x*1e3, txfielddb(round(length(txfielddb) / 2), :)); 
            xlim([XL XH]); hold on; plot([XL, XH], [-6 -6], 'k--', 'linewidth', 2);
            xlabel('x (mm)');
        case 'xz'
            imagesc(x*1e3, z*1e3, txfielddb); colorbar;
            xlabel('x (mm)');
            ylabel('z (mm)');
            ch = colorbar; ylabel(ch, 'dB');        
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            subplot(m,n,i+3);
            ZL1 = min(z)*1000; ZL2 = max(z)*1000; 
            plot(z*1e3, txfielddb(:, round(length(txfielddb) / 2)));
            xlim([ZL1 ZL2]); hold on; plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
            xlabel('z (mm)');
        case 'yz' 
            imagesc(y*1e3, z*1e3, txfielddb); colorbar;
            xlabel('y (mm)');
            ylabel('z (mm)');
            ch = colorbar; ylabel(ch, 'dB');        
            set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
            
            %Adjust for changing focus in x and y direction . map to
            %indexes
            subplot(m,n,i+3);
            ZL1 = min(z)*1000; ZL2 = max(z)*1000; 
            plot(y*1e3, txfielddb(:, round(length(txfielddb) / 2))); 
            xlim([ZL1 ZL2]); hold on; plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
            xlabel('z (mm)');
    end
    ylabel('Pressure (dB)');
    set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
end
end
h = figure; show_transducer('data',xdc_data);
makeFigureBig(h);
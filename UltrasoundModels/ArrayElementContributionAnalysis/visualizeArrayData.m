function visualizeArrayData(data)
    Nw = data.Nw; Nh = data.Nh; Rw = data.Rw; Rh = data.Rh;
    xArrayToSagitalPlane = data.atsp; elContribution = data.elContribution;
    allrect = data.allrect'; rect = data.rect;
    
    h = fullfig;
    cols = 3; rows = 3;
    subplot(cols,rows, 1);
    show_transducer('data',allrect);
    title([num2str(Nh),' x ' num2str(Nw), ' with Rh : ', num2str(Rh*1000),' (mm) and Rw : ', num2str(Rw*1000), ' (mm)']);
    subplot(rows, cols, [2, 3]);
    
    contributions = elContribution;
    contributions = contributions/max(contributions,[],'all');
    imagesc(contributions');
    chArray = colorbar();
    caxis([0 1]);
    title('Element Contribution to Center');
        Y = [3,6,9,12,18]; Z = [4,7,10,13,19];
    Width = max(rect(Y,:), [], 'all')-min(rect(Y,:), [], 'all');
    Height = max(rect(Z,:), [], 'all')-min(rect(Z,:), [], 'all');
    total = sum(contributions,'all');
    title(['Width: ', num2str(Width*1000), ' (mm)  Height: ', num2str(Height*1000), ' Total Contributions : ' num2str(total)]);
    xlabel('Array Column');
    ylabel('Array Row');
    axis image;
    makeFigureBig(h);

    
        res = 0.25;
        xyx = (-50 : res : 50);
        xyy = (-50 : res : 50);
      

        xzx = (-20 : res : 20);
        xzy = 0;
        xzz = (-60 : res : 40);
    
    subplot(rows, cols, 4)
    tx = data.txfield{1,1};
    totaltx = max(tx,[],'all');
    txdb = 20*log10(tx/max(tx,[],'all'));
    imagesc(xzz, xzx, txdb); hold on; contour(xzz, xzx,txdb,[-6,-6],'k--'); hold on; 
    xlabel('Z (mm)');
    ylabel('X (mm)');
    title(['Focus : ' num2str(data.focusSpots{1}*1000),'  Plane : ' data.outputdims{1}])
    ch = colorbar();
    axis image;
    makeFigureBig(h);
    
    subplot(rows, cols, 5)
        tx = data.txfield{1,2};
    totaltx = max(tx,[],'all')*1e9;
    txdb = 20*log10(tx/max(tx,[],'all'));
    imagesc(xyx, xyy, txdb); hold on; contour(xyx, xyy,txdb,[-6,-6],'k--'); hold on;
    xlabel('X (mm)');
    ylabel('Y (mm)');
    title(['Focus : ' num2str(data.focusSpots{1}*1000),'  Plane : ' data.outputdims{2},' Max : ',num2str(totaltx), ' (a.u.)'])
    ch = colorbar();
    axis image;
    makeFigureBig(h);
    
    subplot(rows, cols, 6)
        tx = data.txfield{2,1};
    totaltx = max(tx,[],'all');
    txdb = 20*log10(tx/max(tx,[],'all'));
    imagesc(xzz, xzx, txdb); hold on; contour(xzz, xzx,txdb,[-6,-6],'k--'); hold on; 
    xlabel('Z (mm)');
    ylabel('X (mm)');
    title(['Focus : ' num2str(data.focusSpots{2}*1000),'  Plane : ' data.outputdims{1}])
    ch = colorbar();
    axis image;
    makeFigureBig(h);
    
    subplot(rows, cols, 7)
        tx = data.txfield{2,2};
    totaltx = max(tx,[],'all')*1e9;
    txdb = 20*log10(tx/max(tx,[],'all'));
    imagesc(xyx, xyy, txdb); hold on; contour(xyx, xyy,txdb,[-6,-6],'k--'); hold on;
    xlabel('X (mm)');
    ylabel('Y (mm)');
    title(['Focus : ' num2str(data.focusSpots{2}*1000),'  Plane : ' data.outputdims{2},' Max : ',num2str(totaltx), ' (a.u.)'])
    ch = colorbar();
    axis image;
    makeFigureBig(h);
    
    subplot(rows, cols, 8)
        tx = data.txfield{3,1};
    totaltx = max(tx,[],'all');
    txdb = 20*log10(tx/max(tx,[],'all'));
    imagesc(xzz, xzx, txdb); hold on; contour(xzz, xzx,txdb,[-6,-6],'k--'); hold on; 
    xlabel('Z (mm)');
    ylabel('X (mm)');
    title(['Focus : ' num2str(data.focusSpots{3}*1000),'  Plane : ' data.outputdims{1}])
    ch = colorbar();
    axis image;
    makeFigureBig(h);
    
    subplot(rows, cols, 9)
        tx = data.txfield{3,2}*1e9;
    totaltx = max(tx,[],'all');
    txdb = 20*log10(tx/max(tx,[],'all'));
    
    imagesc(xyx, xyy, txdb); hold on; contour(xyx, xyy,txdb,[-6,-6],'k--'); hold on; 
    
    xlabel('X (mm)');
    ylabel('Y (mm)');
    title(['Focus : ' num2str(data.focusSpots{3}*1000),'  Plane : ' data.outputdims{2}, ' Max : ',num2str(totaltx), ' (a.u.)'])
    ch = colorbar(); 
    axis image;
    makeFigureBig(h);
end

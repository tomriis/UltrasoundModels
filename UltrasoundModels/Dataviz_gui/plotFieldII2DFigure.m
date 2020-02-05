function plotFieldII2DFigure(data, focus, x, y)
    h= figure;
%     workspace;  % Make sure the workspace panel is showing.
%     fontSize = 10;
%     format compact;
%     mask = and(x<0.065,x>-0.065);
%     y = y(mask);
%     x= x(mask);
%     data = data(mask,mask);
    format compact;
    fontSize = 14;
    h1 = subplot(2,1,1);
    imagesc(x*1e3, x*1e3, data); colorbar;
    xlabel('X (mm)');
    ylabel('Y (mm)');
    title('Pressure Field');
    axis square
    set(gca,'fontSize',fontSize)
    set(gca,'xtick',[-50,0,50],'ytick',[-50,0,50])
    %set(ch, 'color', 'none', 'box', 'off', 'fontsize', 20);
    
    originalSize1 = get(gca, 'Position');
    cb=colorbar;
    ylabel(cb, 'dB'); 
    set(gca,'fontSize',fontSize)
    
    h2 = subplot(2,1,2);
    ZL1 = min(y)*1000; ZL2 = max(y)*1000;
    plot(y*1e3, data(round(length(x)/2), :)); 
    xlim([ZL1 ZL2]); hold on;
    plot([ZL1 ZL2], [-6 -6], 'k--', 'linewidth', 2);        
    xlabel('X (mm)');

    ylabel('Pressure (dB)');
    axis square
    set(gca,'fontSize',fontSize)
    originalSize2 = get(gca, 'Position');
    originalSize2
    originalSize1(2)=0.52;
    %set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % Maximize figure.
    set(h1, 'Position', originalSize1);
    newSize2 =originalSize2;
    newSize2(3)=originalSize1(3);
    %newSize(2)= 0.3;
    set(h2, 'Position', newSize2); % Can also use gca instead of h1 if h1 is still active.
    
    set(gcf,'color','w')
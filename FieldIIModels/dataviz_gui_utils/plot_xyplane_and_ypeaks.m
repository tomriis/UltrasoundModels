function [] = plot_xyplane_and_ypeaks(axes1,axes2,txfielddb)
        x = (-60 : 0.5 : 60);
        y = x;
        axes(axes1);
        h=imagesc(x, y, txfielddb);
        hold on;
        idx1 = find_6dB(txfielddb,-4.31,0);
        D = get(h,'CData'); %image data
        
        [~,idx] = histc(D,linspace(min(min(D)),max(max(D)),10)); %bin it
        contour(x,y,txfielddb,[-6,-6],'LineColor','k','LineWidth',0.5)
       
        xlabel(axes1,'x (mm)');
        ylabel(axes1,'y (mm)');
        
        originalSize1 = get(axes1, 'Position');
        ch = colorbar(axes1);
        ylabel(ch,'dB');
        set(axes1,'Position',originalSize1);
        hold off;

        axes(axes2);
        XL = 60;
        YLimLower = -45;
        YLimUpper = 0.5;
        plot(axes2, x, txfielddb(round(length(txfielddb) / 2), :)); 
        xlim(axes2,[-XL XL]); hold on; 
        ylim(axes2,[YLimLower,YLimUpper]); hold on;
        plot(axes2, [-XL, XL], [-6 -6], 'k--', 'linewidth', 2);
        xlabel(axes2,'x (mm)');
        ylabel(axes2,'Intensity (dB)');
        field_space_ticks = round(linspace(-XL,XL, 2*XL/10+1));
        xticks(axes2,field_space_ticks);
        xticks(axes1,field_space_ticks);
        yticks(axes1,field_space_ticks);
        yticks(axes2,round(linspace(YLimLower, YLimUpper, (YLimUpper-YLimLower)/6+1)));
        hold off;
end
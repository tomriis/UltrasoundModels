function [] = plot_xyplane_and_ypeaks(axes1,axes2,txfielddb)
        %axes1 = axes('Position',[0.40 0.57 0.45 0.42]);
        
        x = (-60 : 0.5 : 60);
        y = x;
        im=imagesc(axes1, x, y, txfielddb); 
        cRange = caxis(axes1); hold on; 
        %contour(axes1,x,y,find_6dB(txfielddb,-16.1,-5.8),'LineColor','bl'); 
        caxis(axes1,cRange);
        axis equal tight;
        xlabel(axes1,'x (mm)');
        ylabel(axes1,'y (mm)');
        originalSize1 = get(axes1, 'Position');
        ch = colorbar(axes1);
        ylabel(ch,'dB');
        set(axes1,'Position',originalSize1);
        hold off;
        %set(gca, 'color', 'none', 'box', 'off', 'fontsize', 20);
        %, 'r', 'Linewidth', 3); hold off;
        %axes2 = axes('Position',[0.40 0.05 0.45 0.42]);
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
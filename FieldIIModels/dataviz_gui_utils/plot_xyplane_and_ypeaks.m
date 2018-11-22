function [] = plot_xyplane_and_ypeaks(handles)
        axes1=handles.axes1;axes2=handles.axes2;txfielddb = handles.txfielddb;
        z = (-handles.current_params.ROC+(-60 : 0.5 : 60))*1e-3;
        x = (-60 : 0.5 : 60);
        y = x;
        XL = 60;
        YLimLower = -45;
        YLimUpper = 0.5;
        field_space_ticks = round(linspace(-XL,XL, 2*XL/10+1));
        
        
        switch handles.current_params.Slice
            case 'xz'
                ax1xlabel = 'x (mm)';
                ax1ylabel = 'z (mm)';
                ax2xlabel = 'z (mm)';
                y=z;
            case 'yz'
                ax1xlabel = 'x (mm)';
                ax1ylabel = 'z (mm)';
                ax2xlabel = 'z (mm)';
                y=z;
            case 'xy'
                ax1xlabel = 'x (mm)';
                ax1ylabel = 'y (mm)';
                ax2xlabel = 'x (mm)';
        end
        xlabel(axes1,ax1xlabel);
        ylabel(axes1,ax1ylabel);
        xlabel(axes2,ax2xlabel);      
        axes(axes1);
        
        h=imagesc(x, y, txfielddb);
        hold on;
        
        if handles.radiobutton1.Value
            contour(x,y,txfielddb,[-6,-6],'LineColor','k','LineWidth',0.5)
        end
        if handles.radiobutton2.Value
            contour(x,y,txfielddb,linspace(min(min(txfielddb)),max(max(txfielddb)),10),...
                'LineColor', [0.9 0.9 0.9],'LineWidth',0.5)
        end
        xticks(axes1,field_space_ticks);
        yticks(axes1,field_space_ticks);
        if handles.radiobutton3.Value
            axes1.XGrid = 'on';
            axes1.YGrid = 'on';
            axes1.GridColor = [0 .5 .5];
            axes1.GridLineStyle = '--';
            axes1.GridAlpha = 0.5;
            axes1.Layer = 'top';
        else
            axes1.XGrid = 'off';
            axes1.YGrid = 'off';
        end       
       
        
        
        originalSize1 = get(axes1, 'Position');
        ch = colorbar(axes1);
        ylabel(ch,'dB');
        set(axes1,'Position',originalSize1);
        hold off;

        axes(axes2);
       
        plot(axes2, x, txfielddb(round(length(txfielddb) / 2), :)); 
        xlim(axes2,[-XL XL]); hold on; 
        ylim(axes2,[YLimLower,YLimUpper]); hold on;
        plot(axes2, [-XL, XL], [-6 -6], 'k--', 'linewidth', 2);
        ylabel(axes2,'Pressure (dB)');        
        xticks(axes2,field_space_ticks);
        yticks(axes2,round(linspace(YLimLower, YLimUpper, (YLimUpper-YLimLower)/6+1)));
        hold off;
end
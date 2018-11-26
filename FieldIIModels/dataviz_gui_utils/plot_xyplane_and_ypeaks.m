function [] = plot_xyplane_and_ypeaks(handles)
        axes1=handles.axes1;axes2=handles.axes2;txfielddb = handles.txfielddb;
        
        focus = [handles.current_params.F,0,-handles.current_params.ROC]*1e-3;
        [x,y,z] = get_slice_xyz(handles.current_params.Slice, focus);
        x= x*1000; y=y*1000; z=z*1000;
        if strcmp(handles.txfield_norm,'dB')
            YLimLower = -45;
            YLimUpper = 0.5;
        else
            YLimLower = min(min(txfielddb));
            YLimUpper = max(max(txfielddb));
        end
        
        switch handles.current_params.Slice
            case 'xz'
                ax1xlabel = 'x (mm)';
                ax1ylabel = 'z (mm)';
                ax2xlabel = 'z (mm)';
                y=z;
            case 'yz'
                ax1xlabel = 'y (mm)';
                ax1ylabel = 'z (mm)';
                ax2xlabel = 'z (mm)';
                x=y;
                y=z;
            case 'xy'
                ax1xlabel = 'x (mm)';
                ax1ylabel = 'y (mm)';
                ax2xlabel = 'x (mm)';
                
        end
        XL = min(x); XH = max(x); 
        YL = min(y); YH = max(y);
        
        field_space_ticksx = round(linspace(XL,XH, (XH-XL)/10+1));
        field_space_ticksy = round(linspace(YL,YH, (YH-YL)/10+1));
        
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
        
        xticks(axes1,field_space_ticksx);
        yticks(axes1,field_space_ticksy);
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
        xlabel(axes1,ax1xlabel);
        ylabel(axes1,ax1ylabel);
        originalSize1 = get(axes1, 'Position');
        ch = colorbar(axes1);
        ylabel(ch,'dB');
        set(axes1,'Position',originalSize1);
        hold off;
        
        axes(axes2);
        switch handles.current_params.Slice
            case 'xz'
                ind = x==handles.current_params.F;
                plot(axes2, z, txfielddb(:, ind));
                x=z;
            case 'yz'
                plot(axes2, z, txfielddb(:, round(length(txfielddb) / 2)));
                x=z;
            case 'xy'
                plot(axes2, x, txfielddb(round(length(txfielddb) / 2), :));
        end
        XL = min(x); XH = max(x); 
        xlim(axes2,[XL XH]); hold on; 
        ylim(axes2,[YLimLower,YLimUpper]); hold on;
        plot(axes2, [XL, XH], [-6 -6], 'k--', 'linewidth', 2);
        xlabel(axes2,ax2xlabel); 
        ylabel(axes2,'Pressure (dB)'); 
        field_space_ticksx = round(linspace(XL,XH, (XH-XL)/10+1));
        xticks(axes2,field_space_ticksx);
        yticks(axes2,round(linspace(YLimLower, YLimUpper, (YLimUpper-YLimLower)/6+1)));
        hold off;
end
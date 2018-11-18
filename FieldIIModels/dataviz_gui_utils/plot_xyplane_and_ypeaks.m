function [] = plot_xyplane_and_ypeaks(handles)
        axes1=handles.axes1;axes2=handles.axes2;txfielddb = handles.txfielddb;
        
        x = (-60 : 0.5 : 60);
        y = x;
        XL = 60;
        YLimLower = -45;
        YLimUpper = 0.5;
        field_space_ticks = round(linspace(-XL,XL, 2*XL/10+1));

        
        axes(axes1);
        h=imagesc(x, y, txfielddb);
        hold on;
        idx1 = find_6dB(txfielddb,-4.31,0);
        D = get(h,'CData'); %image data
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
%             hold on;
%             [rows, columns, numberOfColorChannels] = size(axes1);
%             step =
%             for row = 1 :  : rows
%                 line([1, columns], [row, row], 'Color', 'r');
%             end
%             for col = 1 : 50 : columns
%                 line([col, col], [1, rows], 'Color', 'r');
%             end
        else
            axes1.XGrid = 'off';
            axes1.YGrid = 'off';
        end
          
        
       
        xlabel(axes1,'x (mm)');
        ylabel(axes1,'y (mm)');
        
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
        xlabel(axes2,'x (mm)');
        ylabel(axes2,'Intensity (dB)');
        
        xticks(axes2,field_space_ticks);
        yticks(axes2,round(linspace(YLimLower, YLimUpper, (YLimUpper-YLimLower)/6+1)));
        hold off;
end
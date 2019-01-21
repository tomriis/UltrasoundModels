function [] = plot_xyplane_and_ypeaks(handles)
        axes1=handles.axes1;axes2=handles.axes2;txfielddb = handles.txfielddb;
        focus_z = -handles.current_params.ROC+handles.current_params.Z;
        focus = [handles.current_params.F,0,focus_z]*1e-3;
        [x,y,z] = get_slice_xyz(handles.current_params.Slice, focus,size(txfielddb,1));
        x= x*1000; y=y*1000; z=z*1000;
        if strcmp(handles.txfield_norm,'dB')
            YLimLower = -45;
            YLimUpper = 0.5;
            units = 'dB';
        elseif strcmp(handles.txfield_norm,'Normalize')
            YLimLower = min(min(txfielddb));
            YLimUpper = max(max(txfielddb));
            units = 'Normalized';
        elseif strcmp(handles.txfield_norm,'Raw')
            units = '';
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
        txfielddb = txfielddb(1:length(x),1:length(y));
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
        if handles.radiobutton4.Value
            if ~handles.radiobutton12.Value
                switch handles.current_params.Slice
                    case 'xy'
                        plot(axes1, [XL, XH], [-focus(2) focus(2)], 'w--', 'linewidth', 2);
                    case 'xz'
                        plot(axes1, [focus(1)*1000, focus(1)*1000], [min(z) max(z)],'w--','linewidth',2);
                    case 'yz'
                        plot(axes1, [focus(2)*1000, focus(2)*1000], [min(z) max(z)],'w--','linewidth',2);
                end
            else
                switch handles.current_params.Slice
                    case 'xy'
                        plot(axes1, [focus(1)*1000, focus(1)*1000], [YL YH], 'w--', 'linewidth', 2);
                    case 'xz'
                        plot(axes1, [XL, XH], [focus(3)*1000 focus(3)*1000],'w--','linewidth',2);
                    case 'yz'
                        plot(axes1, [XL, XH], [focus(3)*1000 focus(3)*1000],'w--','linewidth',2);
                end
            end
        end
        xlabel(axes1,ax1xlabel);
        ylabel(axes1,ax1ylabel);
        originalSize1 = get(axes1, 'Position');
        ch = colorbar(axes1);
        ylabel(ch, units);
        set(axes1,'Position',originalSize1);
        axis square tight
        hold off;
% Second Plot        
        axes(axes2);
        
        switch handles.current_params.Slice
            case 'xz'
                [~,ind] = min(abs(x-handles.current_params.F));
                if ~handles.radiobutton12.Value
                    profile = txfielddb(:, ind);
                    plot(axes2, z, profile);
                    x=z;
                else
                    ax2xlabel = 'x (mm)';
                    profile = txfielddb(round(length(txfielddb)/2),:);
                    plot(axes2, x, profile);
                end
            case 'yz'
                if ~handles.radiobutton12.Value
                    profile = txfielddb(1:length(z), round(length(txfielddb) / 2));
                    plot(axes2, z, profile);
                    x=z;
                else
                    ax2xlabel = 'y (mm)';
                    profile = txfielddb(round(length(txfielddb)/2),1:length(x));
                    plot(axes2, x, profile);
                end   
            case 'xy'
                if ~handles.radiobutton12.Value
                    profile = txfielddb(round(length(txfielddb) / 2), 1:length(x));
                    plot(axes2, x, profile);
                else
                    ax2xlabel = 'y (mm)';
                    profile = txfielddb(1:length(y),round(length(txfielddb)/2));
                    plot(axes2, x, profile);
                    x=y;
                end
        end
  
        ind = find(profile>-6);
        if length(ind>1)
            hwhm = x(ind(end))-x(ind(1));
            caption = sprintf('Half Width: %.3f (mm)',hwhm);
            set(handles.text14,'String',caption);
        end
        XL = min(x); XH = max(x); 
        xlim(axes2,[XL XH]); hold on; 
        ylim(axes2,[YLimLower,YLimUpper]); hold on;
        if strcmp(handles.txfield_norm,'dB')
            plot(axes2, [XL, XH], [-6 -6], 'k--', 'linewidth', 2);
        end
        xlabel(axes2,ax2xlabel); 
        ylabel(axes2,sprintf('Pressure (%s)',units)); 
        field_space_ticksx = round(linspace(XL,XH, (XH-XL)/10+1));
        xticks(axes2,field_space_ticksx);
        yticks(axes2,round(linspace(YLimLower, YLimUpper, (YLimUpper-YLimLower)/6+1)));
        axis square tight
        hold off;
end
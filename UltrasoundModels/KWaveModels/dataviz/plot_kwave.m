function plot_kwave(app,varargin)
    
    find_data(app);
    
    if strcmp(app.UnitsDropDown.Value, 'dB')
        disp('check');
        txfield = db(app.data/app.max_p)';
    elseif strcmp(app.Units.DropDown.Value,'Pressure')
        disp('pressure');
        txfield = app.data;
    end
    
    
    
    [~,ind_x] = min(abs(app.XSlider.Value-app.x));
    [~,ind_y] = min(abs(app.YSlider.Value-app.y));
    if app.FlipIntensityProfileSwitch.Value
        profile = txfield(:,ind_x);
        line= [app.x(ind_x) app.x(ind_x); min(app.y) max(app.y)];
        x_axis = app.y;
        x_axis_label = 'Y (mm)';
    else
        profile = txfield(ind_y,:);
        line= [min(app.x), max(app.x); app.y(ind_y) app.y(ind_y)];
        x_axis = app.x;
        x_axis_label = 'X (mm)';
    end
    
    
    
    plot(app.UIAxes_2,x_axis, profile);
    ylim(app.UIAxes_2,[app.min_p, app.max_p]);
    ylabel(app.UIAxes_2, 'Pressure (Pa)')
            
    imagesc(app.UIAxes, app.x,app.y,txfield);
    hold(app.UIAxes,'on');
    
    if app.DisplayIntensityProfileCheckBox.Value
        plot(app.UIAxes, line(1,:), line(2,:),'w-', 'linewidth', 2);
    end
    xlabel(app.UIAxes, 'X (mm)');
    ylabel(app.UIAxes, 'Y (mm)');
    xlabel(app.UIAxes_2, x_axis_label);
    hold(app.UIAxes,'off');

end
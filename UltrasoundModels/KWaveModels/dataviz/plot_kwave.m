function plot_kwave(app,varargin)
    find_data(app);
    resetplotview(app.UIAxes,'InitializeCurrentView');
    resetplotview(app.UIAxes_2,'InitializeCurrentView');
    
    if strcmp(app.UnitsDropDown.Value, 'dB')
        txfield = db(app.data./app.max_p);
        y_axis_label = 'Intensity (dB)';
    elseif strcmp(app.UnitsDropDown.Value,'Pressure')
        txfield = app.data;
        y_limit = [app.min_p, app.max_p];
        y_axis_label = 'Pressure (Pa)';
    end
    
    txfield = txfield';
    
    [~,ind_x] = min(abs(app.XSlider.Value-app.x));
    [~,ind_y] = min(abs(app.YSlider.Value-app.y));
    
    if app.FlipIntensityProfileSwitch.Value
        profile = txfield(:,ind_x);
        line= [app.x(ind_x) app.x(ind_x); min(app.y) max(app.y)];
        x_axis = app.y;
        if strcmp(app.current_params.Slice,'xz') || strcmp(app.current_params.Slice,'yz')
            x_axis_label = 'Z (mm)';
        else
            x_axis_label = 'Y (mm)';
        end
    else
        profile = txfield(ind_y,:);
        line= [min(app.x), max(app.x); app.y(ind_y) app.y(ind_y)];
        x_axis = app.x;
        if strcmp(app.current_params.Slice,'xz') || strcmp(app.current_params.Slice,'xy')
            x_axis_label = 'X (mm)';
        else
            x_axis_label = 'Y (mm)';
        end
    end
    
    if strcmp(app.UnitsDropDown.Value, 'dB')
        y_limit = [min(profile),0.2];
    end
    
    plot(app.UIAxes_2, x_axis, profile); hold(app.UIAxes_2, 'on');
    ylim(app.UIAxes_2, y_limit);
    yticks(app.UIAxes_2, round(linspace(y_limit(1), y_limit(2), (y_limit(2)-y_limit(1))/6+1)));
    xticks(app.UIAxes_2, round(linspace(min(x_axis), max(x_axis), (max(x_axis)-min(x_axis))/6+1)));
    ylabel(app.UIAxes_2, y_axis_label)
    xlabel(app.UIAxes_2, x_axis_label);
    if strcmp(app.UnitsDropDown.Value, 'dB')
        y_limit = [min(profile), 1];
        plot(app.UIAxes_2, [x_axis(1), x_axis(end)], [-6 -6], 'k--', 'linewidth', 2);
        ind = find(profile>-6);
        if length(ind>=2)
            hwhm = x_axis(ind(end))-x_axis(ind(1));
            caption = sprintf('Half Width: %.3f (mm)',hwhm);
            app.FWHMLabel.Text=caption;
            app.FWHMLabel.Visible = 'on';
        else
            app.FWHMLabel.Visible = 'off';
        end
    end
    hold(app.UIAxes_2,'off');
    
    imagesc(app.UIAxes, app.x, app.y, txfield);
    hold(app.UIAxes, 'on');
    if app.DisplayIntensityProfileCheckBox.Value
        plot(app.UIAxes, line(1,:), line(2,:), 'w--', 'linewidth', 2);
    end
    
    if strcmp(app.current_params.Slice,'xz')
        axes_1_y_label = 'Z (mm)';
        axes_1_x_label = 'X (mm)';
    elseif strcmp(app.current_params.Slice,'yz')
        axes_1_y_label = 'Z (mm)';
        axes_1_x_label = 'Y (mm)';
    else
        axes_1_y_label = 'Y (mm)';
        axes_1_x_label = 'X (mm)';
    end
    xlabel(app.UIAxes, axes_1_x_label);
    ylabel(app.UIAxes, axes_1_y_label);
    hold(app.UIAxes,'off');
end

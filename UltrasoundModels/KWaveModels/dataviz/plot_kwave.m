function plot_kwave(app)
    t_index = app.TimeSlider.Value;
    txfield = app.data(:,:,t_index);
    axes(app.UIAxes);
    imagesc(app.x,app.y,txfield);
    
    axes(app.UIAxes_2);
    if app.FlipIntensityProfileButton.Value
        profile = txfield(ind,:);
    else
        profile = txfield(:,ind);
    end
    
    plot(profile); hold on;
    if app.DisplayIntensityProfileCheckBox.Value
        disp('here')
    end
    hold off;
end
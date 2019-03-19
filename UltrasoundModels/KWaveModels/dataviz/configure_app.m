function app = configure_app(app)
    time = app.kgrid.t_array;
    data_size = size(app.data);
    app.TimeSlider.Limits= [time(1),time(end)]*1000;
    
    app.x = ((1:data_size(1))-data_size(1)/2)*app.kgrid.dx*1000;
    app.y = ((1:data_size(2))-data_size(2)/2)*app.kgrid.dy*1000;
    
    app.XSlider.Limits = [app.x(1), app.x(end)]; 
    app.YSlider.Limits = [app.y(1), app.y(end)];
    app.TimeSliderLabel.Text = 'Time (ms)';
    
end
function app = find_data(app)
    fname = fieldname_from_params(app.current_params);
    try 
        app.data = app.kwave_struct.(fname);
        app.WarningLabel.Visible='off';
        configure_app(app);
    catch e
        % Check if angle of extent is too large, if so dont plot
        str = sprintf('Current parameters not found in struture \n \n');
        app.WarningLabel.Text=str;
        app.WarningLabel.Visible = 'on';
    end
end
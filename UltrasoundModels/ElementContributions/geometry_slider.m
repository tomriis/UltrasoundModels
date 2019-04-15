function [app] = geometry_slider(app, slider_name,parameter, allowed_values)
    value = app.(slider_name).Value;
    [~,i]=min(abs(allowed_values-value));
    app.(slider_name).Value = allowed_values(i);
    if strcmp(parameter,'D')
        app.(parameter)(1) = allowed_values(i)/1000;
    elseif strcmp(parameter,'a') || strcmp(parameter,'b')
        app.(parameter) = allowed_values(i)/1000;
    else
        app.(parameter) = allowed_values(i);
    end
    app.rect = kwave_focused_array(app.n_elements_r,app.n_elements_y,...,
    app.kerf, app.D, app.R_focus, app.a, app.b, app.type);
end
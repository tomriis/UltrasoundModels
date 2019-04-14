function [focus_point] = plot_transducers_field(app)
    
    [rect]= kwave_focused_array(app.n_elements_r,app.n_elements_y, app.kerf,...,
        app.D, app.R_focus, app.a, app.b,app.type);
    

    plot(app.UIAxes, app.FocusXSlider.Value,...,
    app.FocusZSlider.Value, '+','LineWidth',3); hold(app.UIAxes,'on')
    for i = 1:size(rect,2)
        x1 = rect(2:4,i);
        x2 = rect(5:7,i);
        plot(app.UIAxes, [x1(1),x2(1)],[x1(3),x2(3)]); hold(app.UIAxes,'on');
    end 
    hold(app.UIAxes,'off')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SECOND AXIS 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(app.UIAxes_2, app.FocusXSlider.Value,...,
    app.FocusZSlider.Value, '+','LineWidth',3); hold(app.UIAxes_2,'on')
    
    contributions = calculate_contributions(rect,app.focus, 1540/app.fo);
    for i = 1:size(rect,2)
        x1 = rect(2:4,i);
        x2 = rect(5:7,i);
        plot(app.UIAxes_2, [x1(1),x2(1)],[x1(3),x2(3)]); hold(app.UIAxes_2,'on');
        center = rect(17:end,i);
        vect = center + contributions(1,i)*center;
        plot(app.UIAxes_2, [center(1),vect(1)],[center(3),vect(3)],'black-');
    end 
    hold(app.UIAxes_2,'off');
    
end
function [] = plot_transducers_field(app)
    rect = app.rect;
    lambda = 1540/app.fo;
    plot(app.UIAxes, app.focus(1), app.focus(3), '+','LineWidth',3);
    hold(app.UIAxes,'on')
    for i = 1:size(rect,2)
        x1 = rect(2:4,i);
        x2 = rect(5:7,i);
        plot(app.UIAxes, [x1(1),x2(1)],[x1(3),x2(3)]); hold(app.UIAxes,'on');
    end 
    
    element_i = str2num(app.ElementNumberDropDown.Value);
    profile = calculate_profile(rect, element_i, app.focus,lambda);
    
        plot(app.UIAxes, profile(:,1),profile(:,2),'blue-');
        plot(app.UIAxes, profile(:,3),profile(:,4),'blue-');
    
    
    hold(app.UIAxes,'off')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % SECOND AXIS 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    plot(app.UIAxes_2, app.focus(1), app.focus(3), '+','LineWidth',3); 
    hold(app.UIAxes_2,'on')

    contributions = calculate_contributions(rect,app.focus, lambda);
    contributions = contributions/max(contributions(1,:));
    for i = 1:size(rect,2)
        x1 = rect(2:4,i);
        x2 = rect(5:7,i);
        plot(app.UIAxes_2, [x1(1),x2(1)],[x1(3),x2(3)]); hold(app.UIAxes_2,'on');
        center = rect(17:end,i);
        vect = center + contributions(1,i)*center;
        if i == element_i
            plot(app.UIAxes_2, [center(1),vect(1)],[center(3),vect(3)],'blue-');
        else
            plot(app.UIAxes_2, [center(1),vect(1)],[center(3),vect(3)],'black-');
        end
    end 
    hold(app.UIAxes_2,'off');
    
end
function [contributions] = calculate_contributions(rect, focus)
    % calculates the power from each transducer
    % that arrives at the focus point
    for i = 1:size(rect,2)
        center=rect(17:end, i);
        w = project_u_on_v(focus,center);
        z = norm(center - w);
        x = focus - w;
        figure; quiver3(0,0,0,center(1),center(2),center(3)); 
        hold on; quiver3(0,0,0,w(1),w(2),w(3)); hold on;
        quiver3(w(1),w(2),w(3),x(1),x(2),x(3));
    end
end
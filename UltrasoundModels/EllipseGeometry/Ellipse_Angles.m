function [focus_point]=Ellipse_Angles(handles)
    try 
        pos = handles.focus.Position;
    catch
        pos = [0,0];
    end
    % Number of equally spaced arrays
    N_Elem = 50;
    % Skull and Horizontal geometry ellipse parameters respectively
    a =135/2; b = 170/2;
    a_out = 120; b_out = 120;
    % Degree at which US is reflected and we color ray red
    reflection_threshold = 20; % Degrees
    % Plot geometries
    t=linspace(0,2*pi,1000);
    ellipse=[a*cos(t); b*sin(t)];
    outer_ellipse = [a_out*cos(t); b_out*sin(t)];
    perp_line_length = 100;
    
    plot(outer_ellipse(1,:), outer_ellipse(2,:),'r'); hold on;
    plot(ellipse(1,:),ellipse(2,:),'b'); hold on;
    focus=drawpoint(gca,'Position',pos);
    
    focus.Label = num2str(pos);
    % This loop calculates where a US ray aimed at our focus contacts
    % the skull and calculates the angle with the surface normal vector
    for elem = 1:N_Elem
        phi = elem/N_Elem*2*pi;
        ray = [pos(1) a_out*cos(phi); pos(2) b_out*sin(phi)];
        m = (ray(2,2)-ray(2,1))/(ray(1,2)-ray(1,1));
        c = (ray(2,2)-m*ray(1,2));
        point_slope_ray = [m c];

        e = find_intersection_on_ellipse(ray, a, b);
        plot(e(1),e(2),'black+')
        [tangent]=get_tangent_at_point(e, a, b);
        perp = get_perpendicular_line(e, tangent);
        if handles.show_perp_line
            if e(1)<0
                SIGN = -1;
            else
                SIGN = 1;
            end
            normed_dist = sqrt(perp_line_length/(perp(1)^2+1));
            x = [e(1),e(1)+SIGN*normed_dist];
            plot(x,perp(1)*x+perp(2),'black-');
        end
        angle_rad = find_angle_between_lines(perp,[point_slope_ray(1) 1]);
        % Simple binary threshold  
        % Could change the ray's alpha according to angle
        if abs(angle_rad*180/pi) > reflection_threshold
            c = 'r-';
        else
            c = 'g-';
        end
        plot(ray(1,:),ray(2,:),c); 
    end
    hold off;
    axis square

end

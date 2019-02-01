function angle_rad = find_angle_at_point(angle, point, a, b)
    % Find angle between point on ellipse and the horizontal 
    tangent_line = get_tangent_at_point(point, a, b);
%          ray = [0 point(1); 0 point(2)];
%         m = (ray(2,2)-ray(2,1))/(ray(1,2)-ray(1,1));
%         c = (ray(2,2)-m*ray(1,2));
%         point_slope_ray = [m c];
    if angle >= -pi && angle < -pi/2
        SIGN = -1;
        SHIFT = pi/2;
    elseif angle >= -pi/2 && angle < 0
        SIGN = 1;
        SHIFT = -pi/2;
    elseif angle >= 0 && angle < pi/2
        SIGN = -1;
        SHIFT = -pi/2;
    else
        SIGN = 1;
        SHIFT = pi/2;
    end
    angle_rad = SIGN*(find_angle_between_lines(tangent_line, [0,1])+SHIFT);
end
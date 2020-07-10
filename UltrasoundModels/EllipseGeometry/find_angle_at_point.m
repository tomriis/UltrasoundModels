function angle_rad = find_angle_at_point(angle, point, a, b)
    % Find angle between point on ellipse and the horizontal
    
    r = sqrt(point(1)^2+point(2)^2);
    tangent_line = get_tangent_at_point(point, a, b);
    angle = mod(angle, 2*pi);
    if angle >= 0 && angle < pi/2
        SIGN = -1;
        SHIFT = -pi/2;
    elseif angle >= pi/2 && angle < pi
        SIGN = -1;
        SHIFT = -pi/2;
    elseif angle >= pi && angle < 3*pi/2 %top left
        SIGN = -1;
        SHIFT = pi/2;
    else
        SIGN = -1;
        SHIFT = pi/2;
    end
  
    angle_rad = SIGN*(find_angle_between_lines(tangent_line, [0,1])+SHIFT);
end
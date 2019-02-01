function angle_rad = find_angle_at_point(point, a, b)
    tangent_line = get_tangent_at_point(point, a, b);
%          ray = [0 point(1); 0 point(2)];
%         m = (ray(2,2)-ray(2,1))/(ray(1,2)-ray(1,1));
%         c = (ray(2,2)-m*ray(1,2));
%         point_slope_ray = [m c];
    angle_rad = (pi/2-find_angle_between_lines(tangent_line, [0,0]));
end
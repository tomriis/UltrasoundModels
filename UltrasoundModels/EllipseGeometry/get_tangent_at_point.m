function [tangent] = get_tangent_at_point(point, a, b)
    
    y1 = -b^2/a^2*(point(1)/point(2))*point(1) + b^2/point(2);
    y2 = -b^2/a^2*(point(1)/point(2))*(point(1)+1) + b^2/point(2);
    tangent = [y2-y1, 1];
end
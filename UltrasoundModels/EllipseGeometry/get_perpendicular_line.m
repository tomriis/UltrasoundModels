function [perpendicular] = get_perpendicular_line(point,tangent)
    perpendicular(1) = -1*(1/tangent(1));
    perpendicular(2) = point(2)+(1/tangent(1))*point(1);
end
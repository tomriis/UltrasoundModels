function [intersect_point] = find_intersection_on_ellipse(endpoints, a, b)
    % endpoints = [x1 x2; y1 y2];
    m = (endpoints(2,2)-endpoints(2,1))/(endpoints(1,2)-endpoints(1,1));
    c = (endpoints(2,2)-m*endpoints(1,2));    
    A = b^2+a^2*m^2;
    B = 2*a^2*m*c;
    C = a^2*(c^2-b^2);
    if endpoints(1,2) <0 && endpoints(1,2)<endpoints(1,1)
        SIGN = -1;
    elseif endpoints(1,2) > 0 && endpoints(1,2)<endpoints(1,1)
        SIGN = -1;
    else
        SIGN = 1;
    end
    x_i = (-B+SIGN*sqrt(B^2-4*A*C))/(2*A);
    y_i = m*x_i+c;
    intersect_point=[x_i, y_i];
end
function [tangent] = get_tangent_at_point(point, E_a, E_b)
    
    phi = asin(point(2)/E_b);
   
    m= -E_b/E_a*cot(phi);
    if point(1)<0 % To give correct sign to arcsin
        m = -1*m;
    end
    y0 = point(2);
    x0 = point(1);
    y1 = -1*m*x0+y0; %y1 = sqrt(E_b^2+E_a^2*m^2);
    tangent = [m,y1];
end
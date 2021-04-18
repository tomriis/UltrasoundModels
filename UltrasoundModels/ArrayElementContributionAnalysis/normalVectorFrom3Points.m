function n = normalVectorFrom3Points(p1,p2,p3)
    %normalVectorFrom3Points.m calculates normal vector to plane defined by
    %3 points.
    % Inputs:
    %   pi : points positions
    % Outputs:
    %   n : normal vector to plane
    a = p2 - p1;
    b = p3 - p1;
    
    n = cross(b,a);
end
    
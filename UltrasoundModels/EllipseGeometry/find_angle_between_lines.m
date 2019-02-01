function [angle_rad] = find_angle_between_lines(line1,line2)    
    v = [line1(1) 1]; u = [line2(1) 1];
    angle_rad = acos(dot(v,u)/(norm(v)*norm(u)));
end
function [angle_rad] = find_angle_between_lines(line1,line2)    
    v = [line1(1) line1(2)]; u = [line2(1) line2(2)];
    
    dt = dot(v,u);
    dett = v(2)*u(1)-v(1)*u(2);
    angle_rad = atan2(dett,dt);
%     angle_rad = acos(dot(v,u)/(norm(v)*norm(u)));
end
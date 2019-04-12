function [w] = project_u_on_v(u,v)
    w = (dot(u,v)/dot(v,v))*v;
end


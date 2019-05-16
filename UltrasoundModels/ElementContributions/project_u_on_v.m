function [w] = project_u_on_v(u,v)
%     size(u)
%     size(v)
    w = (dot(u,v,2)./dot(v,v,2)).*v;
end


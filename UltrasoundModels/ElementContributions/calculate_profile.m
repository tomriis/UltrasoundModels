function [profile] = calculate_profile(rect, element_i, focus,lambda)
    center = rect(17:end,element_i)';
    D = rect(15,element_i);
    N_samples = 20;
    w = project_u_on_v(focus,center);
    z = center - w;
    z_scale = linspace(0,1.2,N_samples);
    profile=zeros([N_samples,6]);
    for i = 1:N_samples
        p = center - z_scale(i)*z;
        p = [p(1), p(3)]; % Reduce to 2D
        z_norm = norm(z_scale(i)*z);
        x_norm = lambda*z_norm/D;
        perp = [center(3), -1*center(1)];
        u_perp = perp/norm(perp);
        profile(i,1:2) = p-x_norm*u_perp;
        profile(i,3:4) = p+x_norm*u_perp;
        profile(i,5:6) = p;
    end
end
function hp=calculate_field_timeseries(c_mat,z_mat, delays, c, fo, show_elem)
    t_mat = z_mat/c;
    
    if show_elem
        mask = zeros([size(c_mat,1),1]);
        mask(show_elem) = 1;
        c_mat = c_mat.*mask;
        
        t_mat = t_mat.*mask;
    end
    
    mat = c_mat;
    phi = 2*pi*fo*delays;
    x_dim = size(c_mat,2); y_dim = size(c_mat, 3);
    time = 0:1/(20*fo):3/fo;
    hp = zeros([length(time), x_dim, y_dim]);
    for i = 1:length(time)
        mat_sum = mat.*sin(2*pi*fo*(t_mat+time(i))+phi);
        f = reshape(sum(mat_sum,1),[x_dim y_dim]);
        hp(i,:,:) = f;
    end    
end
function f=plot_e(c_mat,t_mat, app)
    rect = app.rect3D;
    focus = app.focus;
    plane = app.plane;
    c = app.c;
    delays = compute_delays(rect, focus, c);
    [x,y,z] = get_slice_xyz(plane, focus);
    
    mat = c_mat.*1./(t_mat.^(1/2));
    
    phi = 2*pi*app.fo*delays;
    for i = 1:length(x)
        for j = 1:length(y)
            mat(:,i,j) = mat(:,i,j).*sin(2*pi*app.fo*t_mat(:,i,j)+phi);
        end
    end
    f = reshape(sum(mat,1),[226 226]);
    f = f'/max(max(f))
    %figure; imagesc(x,y,db(f'./max(max(f))));
    figure; imagesc(x,y,f);
end
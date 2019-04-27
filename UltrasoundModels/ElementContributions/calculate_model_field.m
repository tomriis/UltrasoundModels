function [field, c_mat, t_mat] = calculate_model_field(app)
    rect = app.rect3D;
    focus = app.focus;
    plane = app.plane;
    c = app.c;
    delays = compute_delays(rect, focus, c);
    [x,y,z] = get_slice_xyz(plane, focus);
    field = zeros([length(x),length(y)]);
    count = 1;
    phi = 2*pi*app.fo*delays;
    total = length(x)*length(y);
    t_mat = zeros([252,length(x),length(y)]);
    c_mat = zeros([252,length(x),length(y)]);
    for i = 1:length(x)
        for j = 1:length(y)
            if mod(count, 1000)== 0
                disp(['On ', num2str(count), ' of ',num2str(total)]);
            end
            count = count +1;
            if strcmp(app.plane,'xy')
                
                [contributions] = calculate_contributions(rect, [x(i),y(j),z(1)], app.lambda);
                t=contributions(3,:)/app.c;
                power = contributions(1,:).*contributions(2,:);
                field(i,j) = sum(power.*sin(2*pi*app.fo*t+phi'));
                t_mat(:,i,j) = t;
                c_mat(:,i,j) = power;
            end
        end
    end
end
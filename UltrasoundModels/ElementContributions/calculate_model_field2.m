function [c_mat, t_mat] = calculate_model_field2(app)
    rect = app.rect3D;
    focus = app.focus;
    plane = app.plane;
    c = app.c;
    n_elements = size(rect,2);
    delays = compute_delays(rect, focus, c);
    [x,y,z] = get_slice_xyz(plane, focus);
  
    count = 1;
    
    total = length(x)*length(y);
    t_mat = zeros([n_elements,length(x),length(y)]);
    c_mat = zeros([n_elements,length(x),length(y)]);
    field = zeros([length(x)*length(y),3]);
    for i = 1:length(x)
        for j = 1:length(y)
            field(count,:) = [x(i),y(j),z(1)];
            if mod(count, 1000)== 0
                disp(['On ', num2str(count), ' of ',num2str(total)]);
            end
            count = count +1;
        end
    end
            
            if strcmp(app.plane,'xy')
                
                [contributions] = calculate_contributions_field(rect, field, app.lambda);
               
                t_mat = contributions(3,:,:)/app.c;
                power = contributions(1,:,:).*contributions(2,:,:);
                
                t_mat = reshape(t_mat,[n_elements,length(x),length(y)]);
                c_mat = reshape(power,[n_elements, length(x), length(y)]);
            end
end
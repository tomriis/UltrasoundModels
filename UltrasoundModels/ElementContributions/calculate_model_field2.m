function [c_mat, z_mat] = calculate_model_field2(app)
    rect = app.rect3D;
    focus = app.focus;
    plane = app.plane;

    n_elements = size(rect,2);
    
    [x,y,z] = get_slice_xyz(plane, focus);
  
    count = 1;
    
    total = length(x)*length(y);
    z_mat = zeros([n_elements,length(x),length(y)]);
    c_mat = zeros([n_elements,length(x),length(y)]);
    field = zeros([length(x)*length(y),3]);
    for i = 1:length(x)
        for j = 1:length(y)
            field(count,:) = [x(i),y(j),z(1)];
            count = count +1;
        end
    end
            
    if strcmp(app.plane,'xy')

        [contributions] = calculate_contributions_field(rect, field, app.lambda);

        z_mat = contributions(3,:,:);
        power = contributions(1,:,:).*contributions(2,:,:);

        z_mat = reshape(z_mat,[n_elements,length(x),length(y)]);
        c_mat = reshape(power,[n_elements, length(x), length(y)]);
    end
end
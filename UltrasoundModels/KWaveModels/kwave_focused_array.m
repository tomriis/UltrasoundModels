function [mask,points,ijk] = kwave_focused_array(kgrid, n_r, n_y,kerf, D, R_focus,a,b,type)%n_elements_x, n_elements_y, ROC_x,ROC_y, D, kerf)
    % define a square source element
    
    field_init(-1)
    if strcmp(type,'horizontal')
        disp('ran her');
        [Th] = horizontal_array(n_r, n_y, kerf, D, R_focus,a,b);
    else
        [Th] = concave_focused_array(n_r, n_y, a, kerf, D, R_focus);
    end
    rect = xdc_pointer_to_rect(Th);
    show_transducer('Th',Th);
    field_end();
    
    mask=zeros(kgrid.Nx,kgrid.Ny,kgrid.Nz);
    
    for k = 1:size(rect,2)
        corners = get_corners_from_rect(rect(:,k));
        points = get_points_on_rect(corners,kgrid);
        ijk = zeros(3,size(points,2));
        for j = 1:length(points)
            ijk(:,j) = coordinates_to_index(kgrid, points(:,j));
        end
        ijk = unique(ijk','rows')';
        mask(ijk(1,:),ijk(2,:),ijk(3,:)) = 1;
    end
end
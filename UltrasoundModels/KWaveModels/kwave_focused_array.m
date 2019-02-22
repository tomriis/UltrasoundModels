function [mask] = kwave_focused_array(kgrid, n_r, n_y,kerf, D, R_focus,a,b,Ang_Extent)%n_elements_x, n_elements_y, ROC_x,ROC_y, D, kerf)
    % define a square source element
    field_init(-1)
    [Th] = horizontal_array(n_r, n_y, kerf, D, R_focus,a,b);
    rect = xdc_pointer_to_rect(Th);
    field_end();
    
    for k = 1:size(rect,2)
        corners = get_corners_from_rect(rect(:,k));
        points = get_points_on_rect(corners,kgrid);
        ijk = zeros(3,size(points,2));
        for j = 1:length(points)
            ijk(:,j) = coordinates_to_index(kgrid, points(:,j));
        end
        ijk = unique(ijk','rows')';
    end
        
end
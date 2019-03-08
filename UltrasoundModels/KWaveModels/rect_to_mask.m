function [mask,ijk] = rect_to_mask(kgrid, rect)
    mask=zeros(kgrid.Nx,kgrid.Ny,kgrid.Nz);
    ijk = struct();
    for k = 1:size(rect,2)
        corners = get_corners_from_rect(rect(:,k));
        points = get_points_on_rect(corners,kgrid);
        t_ijk = zeros(3,size(points,2));
        for j = 1:length(points)
            t_ijk(:,j) = coordinates_to_index(kgrid, points(:,j));
        end
        t_ijk = unique(t_ijk','rows')';
        for l = 1:size(t_ijk,2)
            mask(t_ijk(1,l),t_ijk(2,l),t_ijk(3,l)) = 1;
        end
        ijk.(strcat('t',num2str(k))) = t_ijk;
    end
    
    if Dimensions == 2
        mask = reshape(any(mask,2),[kgrid.Nx,kgrid.Nz]);
    end  
end
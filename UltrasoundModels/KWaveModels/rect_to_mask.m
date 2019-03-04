function [mask,ijk] = rect_to_mask(kgrid, rect)
    mask=zeros(kgrid.Nx,kgrid.Ny,kgrid.Nz);
    
    for k = 1:size(rect,2)
        corners = get_corners_from_rect(rect(:,k));
        points = get_points_on_rect(corners,kgrid);
        ijk = zeros(3,size(points,2));
        for j = 1:length(points)
            ijk(:,j) = coordinates_to_index(kgrid, points(:,j));
        end
        ijk = unique(ijk','rows')';
        for l = 1:size(ijk,2)
            mask(ijk(1,l),ijk(2,l),ijk(3,l)) = 1;
        end
    end
end
function [mask,ijk, focus] = rect_to_mask(kgrid, rect,Dimensions, type, focus,equalize)
    if Dimensions == 2
        mask = zeros(kgrid.Nx, kgrid.Nz);
    else
        mask=zeros(kgrid.Nx,kgrid.Ny,kgrid.Nz);
    end
    
%     if ~strcmp(type,'horizontal')
%         %    Adjust rect to grid
%         mv = max(rect(end,:));
%         shift_z = -(mv-kgrid.z_vec(end-30));
%         rect = translate_rect([0,0,shift_z]', rect);
%         focus(3) = focus(3)+shift_z;
%     end
    
    ijk = struct();
    min_length = inf;
    for k = 1:size(rect,2)
        corners = get_corners_from_rect(rect(:,k));
        points = get_points_on_rect(corners,kgrid);
        
        t_ijk = zeros(3,size(points,2));
        d = zeros(1,length(points));
        for j = 1:length(points)
            [t_ijk(:,j), d(j)] = coordinates_to_index_kgrid(kgrid, points(:,j));
        end
        if Dimensions == 2
            t_ijk(2,:) = [];
        end
        [t_ijk,ia] = unique(t_ijk','rows');
        d = d(ia);
        if length(t_ijk) < min_length
            min_length = length(t_ijk);
        end
        ijk.(strcat('t',num2str(k))) = t_ijk';
        ijk.(strcat('d',num2str(k))) = d;
    end
    for k = 1:size(rect,2)
        t_field = strcat('t',num2str(k));
        d_field = strcat('d',num2str(k));
        t_ijk = ijk.(t_field);
        if equalize
            [~,si]=sort(ijk.(d_field));
            ijk.(t_field) = t_ijk(:,si(1:min_length));
        end
        t_ijk = ijk.(t_field);
        for kk = 1:length(t_ijk)
            if Dimensions == 2
                mask(t_ijk(1,kk),t_ijk(2,kk))=1;
            else
                mask(t_ijk(1,kk),t_ijk(2,kk),t_ijk(3,kk))=1;
            end
        end
        ijk = rmfield(ijk,d_field);
    end  
end

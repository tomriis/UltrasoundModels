function [mask, sensor_size] = define_sensor_mask(kgrid, focus, plane, Dimension)
    limit = 55; %[mm]
    if Dimension == 2
        mask=zeros(kgrid.Nx,kgrid.Nz);
        [~, y1] = min(abs(kgrid.y_vec-0));
        [~, y2] = min(abs(kgrid.y_vec-0.080));
        mask(round(size(mask,1)/2),:) = 1;
    else 
        mask = ones(kgrid.Nx, kgrid.Ny, kgrid.Nz);
%         x_mask = and(kgrid.x_vec<0.05,kgrid.x_vec>-0.05);
% %         y_mask = and(kgrid.y_vec<0.001,kgrid.y_vec>-0.001);
%         [~,y_point] = min(abs(kgrid.y_vec - 0));
%         z_mask = and(kgrid.z_vec<0.05,kgrid.z_vec>-0.05);
%         mask(x_mask, y_point, z_mask) = 1;
    end
sensor_size = size(mask);
%     switch plane
%         case 'xy'
%             x = (-limit : limit)*1e-3;
%             y = (-limit :limit)*1e-3;
%             z = focus(3);
%         case 'xz'
%             x = (-limit : limit)*1e-3;
%             y = focus(2);
%             z =(-limit : limit)*1e-3;
%         case 'yz'
%             x = focus(1);
%             y = (-limit : limit)*1e-3;
%             z = (-limit : limit)*1e-3;
%     end
%     
%     [ijk] = coordinates_to_index_kgrid(kgrid, [x(1),y(1),z(1)]);
%     [ijkend] = coordinates_to_index_kgrid(kgrid, [x(end),y(end),z(end)]);
%     x=ijk(1):ijkend(1); y = ijk(2):ijkend(2); z = ijk(3):ijkend(3);
%     for i = x
%         for j = y
%             for k = z
%                if Dimension == 2
%                    mask(i,k) = 1;
%                else
%                    mask(i,j,k) = 1;
%                end
%             end
%         end
%     end
%     switch plane
%         case 'xy'
%             sensor_size = [length(x),length(y)];
%         case 'xz'
%             sensor_size = [length(x), length(z)];
%         case 'yz'
%             sensor_size = [length(y), length(z)];
%     end
            
end
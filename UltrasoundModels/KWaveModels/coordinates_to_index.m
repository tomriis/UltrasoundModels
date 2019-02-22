function [ijk] = coordinates_to_index(kgrid, v)
    [~,i]=min(abs(kgrid.x_vec-v(1)));
    [~,j]=min(abs(kgrid.y_vec-v(2)));
    [~,k]=min(abs(kgrid.z_vec-v(2)));
    
    ijk=[i,j,k];
end
function [ijk, d] = coordinates_to_index_kgrid(kgrid, v)
    [x,i]=min(abs(kgrid.x_vec-v(1)));
    [y,j]=min(abs(kgrid.y_vec-v(2)));
    [z,k]=min(abs(kgrid.z_vec-v(3)));
    
    d = norm([x,y,z]);
    ijk=[i,j,k];
end
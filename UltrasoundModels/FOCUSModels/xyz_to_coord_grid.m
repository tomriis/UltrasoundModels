function [coord_grid] = xyz_to_coord_grid(x,y,z)
    xmin = min(x);
    xmax = max(x);
    ymin = min(y);
    ymax = max(y);
    zmin = min(z); 
    zmax = max(z);
    xpoints = length(x);
    ypoints = length(y);
    zpoints = length(z);
    dx = (xmax-xmin)/xpoints;
    dy = (ymax-ymin)/ypoints;
    dz = (zmax-zmin)/zpoints;
    delta = [dx dy dz];
    coord_grid = set_coordinate_grid(delta, xmin, xmax, ymin, ymax, zmin, zmax);
end
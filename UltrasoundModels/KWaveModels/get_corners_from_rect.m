function [corners] = get_corners_from_rect(rect)
    corners = zeros(3,4);
    for i = 1:4
        xyz_i = [3*i-1, 3*i, 3*i+1];
        corners(:,i) = rect(xyz_i);
    end
end
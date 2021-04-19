function [rect] = apply_affine_to_rect(affine_matrix, rect)
    N = size(rect, 2);
    for k = 1:N
        % Apply to xyz vector of corners
        for i = 1:4
            xyz_i = [3*i-1, 3*i, 3*i+1];
            invec = [rect(xyz_i,k);0];
            outvec = affine_matrix * invec;
            rect(xyz_i,k) = outvec(1:3);
        end
        % Apply to xyz vector of centers
        outvec = affine_matrix * [rect(17:19,k);0];
        rect(17:19,k) = outvec(1:3);
    end
end
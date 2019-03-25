function [rect] = translate_rect(xyz_shift, rect)
    N = size(rect, 2);
    for k = 1:N
        % Apply to xyz vector of corners
        for i = 1:4
            xyz_i = [3*i-1, 3*i, 3*i+1];
            rect(xyz_i,k) = rect(xyz_i,k) + xyz_shift;
        end
        % Apply to xyz vector of centers
        rect(17:19,k) = rect(17:19,k) + xyz_shift;
    end
end
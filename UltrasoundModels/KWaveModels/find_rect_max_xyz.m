function max_xyz = find_rect_max_xyz(rect)
    max_xyz = [0, 0,0];
    N = size(rect, 2);
    for k = 1:N
        % Apply to xyz vector of corners
        for i = 1:4
            xyz_i = [3*i-1, 3*i, 3*i+1];
            
            max_xyz = replace_with_larger(max_xyz, rect(xyz_i,k));
        end
        % Apply to xyz vector of centers
        max_xyz = replace_with_larger(max_xyz, rect(17:19,k));
    end
end

function xyz = replace_with_larger(xyz, vec)
    for i = 1:3
        if xyz(i) < abs(vec(i))
            xyz(i) = abs(vec(i));
        end
    end
end
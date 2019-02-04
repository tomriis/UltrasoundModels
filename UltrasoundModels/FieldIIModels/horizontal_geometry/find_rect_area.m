function [area] = find_rect_area(rect)
        v_xyz = zeros(4,3);
        for i = 1:4
            v_xyz(i,:) = rect([3*i-1, 3*i, 3*i+1]);
        end
        v12 = v_xyz(2,:)-v_xyz(1,:);
        v14 = v_xyz(4,:)-v_xyz(1,:);
        area = norm(cross(v12,v14));
end
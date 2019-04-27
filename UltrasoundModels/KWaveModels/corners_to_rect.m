function [rect] = corners_to_rect(corners)
    rect = zeros(19,length(corners));
    for j = 1:length(corners)
        rect(1,j) = j;
        corner = corners{j};
        for i = 1:4
            xyz_i = [3*i-1, 3*i, 3*i+1];
            rect(xyz_i,j) = corner(:,i);
        end
        
        rect(17:19,j) = mean(corner,2);
    end
    

end
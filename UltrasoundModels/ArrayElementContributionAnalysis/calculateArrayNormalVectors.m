function array = calculateArrayNormalVectors(array)
    for i = 1:size(array.rect,2)
        n = calculateRectNormalVector(array.rect, i);
        array.element(i).normalVector = n;
        array.element(i).center = array.rect(17:19,i);
        c1 = array.rect(2:4, i);
        c2 = array.rect(5:7, i);
        c3 = array.rect(8:10, i);
        array.element(i).xNorm = (c2- c3)/norm(c2-c3);
        array.element(i).yNorm = (c1-c2)/norm(c1-c2);
    end
end
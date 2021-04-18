function array = calculateArrayNormalVectors(array)
    for i = 1:size(array.rect,2)
        n = calculateRectNormalVector(array.rect, i);
        array.element(i).normalVector = n;
        array.element(i).center = array.rect(17:19,i);
    end
end
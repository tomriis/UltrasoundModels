function n = calculateRectNormalVector(rect, i)
    c1 = rect(2:4, i);
    c2 = rect(5:7, i);
    c3 = rect(8:10, i);
    n = normalVectorFrom3Points(c1,c2,c3);
    n = n/norm(n);
end
function [NR] = find_NR_from_geo(NTotal, NZ,A,B, X)
        kerf = 0.4;
        NR = 43;%floor(NTotal/NZ);
        p = ellipse_perimeter(A,B);
        if NR*(X+kerf) > p
            NR = floor(p/(X+kerf));
        end
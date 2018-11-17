function [mask] = find_6dB(txfielddb,lLim, uLim)
    u = txfielddb < uLim;
    l = txfielddb > lLim;
    mask = u & l;
end
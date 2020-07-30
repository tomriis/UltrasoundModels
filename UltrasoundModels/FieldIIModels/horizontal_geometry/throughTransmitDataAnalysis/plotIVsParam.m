function plotIVsParam(I,xOrdinate, xOrdinateLabel)
    I = I/max(I);
    h=figure; plot(xOrdinate,I,'b^-','lineWidth',1.5);
    ylabel('Normalized Pressure');
    xlabel(xOrdinateLabel);
    makeFigureBig(h);
end
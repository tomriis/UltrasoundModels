function modularGeometryOptimization(costFunction,filename)
    %modularGeometryOptimization sets up parameter bounds and runs
    %fminsearchbnd governed by cost functions
    % Example:
    % X = modularGeometryOptimization(@costFunctionIntensityIntegral)
    %Geometry parameters [A, B, kerf, R_focus_ratio] 
    LB = [0.110, 0.90, 0.004, 0];
    UB = [0.130, 0.120, 0.008, 2];
    x0 = (UB+LB)/2;
    options = optimset('MaxIter', 50,'Display','iter','PlotFcns',@optimplotfval);
    
    [x, fval,exitflag,output] = fminsearchbnd(costFunction, x0, LB, UB, options);
    save(filename,'x','fval','output');
    figure; plot(fval);   
    
    
end
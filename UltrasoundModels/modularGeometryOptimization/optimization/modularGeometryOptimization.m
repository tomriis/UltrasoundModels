function modularGeometryOptimization(costFunction,filename)
    %modularGeometryOptimization sets up parameter bounds and runs
    %fminsearchbnd governed by cost functions
    % Example:
    % X = modularGeometryOptimization(@costFunctionIntensityIntegral)
    %Geometry parameters [A, B, kerf, R_focus_ratio] 
    LB = [0.004, 0];
    UB = [0.008, 2];
    x0 = LB;
    options = optimset('MaxIter', 50,'Display','iter','PlotFcns',@optimplotfval);
    
    [x, fval,exitflag,output] = fminsearchbnd(costFunction, x0, LB, UB, options);
    save(filename,'x','fval','output');
    figure; plot(fval);   
    
    
end
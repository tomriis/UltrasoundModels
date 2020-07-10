function J = costFunctionIntensityIntegral(params)
    data = horizontalGeometryScan3D(params);
    
    cost = zeros([1,length(data)]);
    for i = 1:length(cost)
        field = data(i).max_hp;
        dS = abs(data(i).x(1)-data(i).x(2))*abs(data(i).y(1)-data(i).y(2));
        cost(i) = -1*fieldIntensityIntegral(field*1e3,dS);
    end
    J = max(cost(i));
    
end
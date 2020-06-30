function total = ellipse_perimeter(a,b,thetaRange)
    p = pi*(3*(a+b)-sqrt((3*a+b)*(a+3*b))); %approximation to total perimeter
    res = 30000;

    theta = linspace(thetaRange(1),thetaRange(2),res);
    total = 0;
    dt = abs(theta(1)-theta(2));
    for i = 1:length(theta)
        total = total + sqrt(a^2*sin(theta(i))^2+b^2*cos(theta(i))^2)*dt;
    end
end
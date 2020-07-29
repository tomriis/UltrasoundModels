function angles = getSymmetricAngleSpacing(a,b,thetaRanges, N)
%getEllpiseSymmetricSpacing Defines angles such that each column of
%elements has a directly opposing element. 
%
% 
%     p = ellipse_perimeter(a,b);
%     
%     X(
    angles = [];
    
    
    for i = 1:size(thetaRanges,1)
        theta = linspace(thetaRanges(i,1),thetaRanges(i,2),N(i));
        theta = get_ellipse_angle_spacing(a,b, N(i),thetaRanges(i,:));
        angles = vertcat(angles,theta, theta+pi);
    end
end
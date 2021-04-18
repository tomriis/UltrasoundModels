function d = distancePointToLine(lineV,lineQ,P)
%distancePointToLine.m calculates the distance from point P to line defined
%by vector and intersection point
% Inputs:
%   lineV : vector of line
%   lineQ : point on line
%   P : point in space
% Output:
%   d = distance between P and the line

d = norm(cross((lineQ-P), lineV))/norm(lineV);
end
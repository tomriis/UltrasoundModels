function [tx1, rect, cent, focus] = xdc_concaveArray2(nelements_x, nelements_y, ROC_x, ROC_y, W, P)
%
% Function returns a handle to a Field-II array object
% A concave array with the following properties
% where:
%	nelements_x - Number fo elements
%	ROC = radius of curvature (mm)
%	AngExtent_x = angular extent of the array (radians)
%	ElH = elevation height (mm)
%	ElF = elevation focus (mm)
%	W = width of the array elements (mm)
%	P = pitch of the array elements (mm)
%	Nx = number of mathematical subelements in x
%	Ny = number of mathematical subelements in y
%
% written by:
%	Jan Kubanek, jan.kubanek@utah.edu

len_x = P * nelements_x; %arc length
AngExtent_x = len_x / ROC_x;
angle_inc_x = (AngExtent_x)/nelements_x; 					
index_x = -nelements_x/2 + 0.5 : nelements_x/2 - 0.5;
angle_x = index_x*angle_inc_x;
numArray_x = length(angle_x);

len_y = W * nelements_y; %arc length
AngExtent_y = len_y / ROC_y;
angle_inc_y = (AngExtent_y)/nelements_y; 					
index_y = -nelements_y/2 + 0.5 : nelements_y/2 - 0.5;
angle_y = index_y*angle_inc_y;
numArray_y = length(angle_y);

count = 1;
rect = [];
for i = 1 : numArray_x
    for j = 1 : numArray_y
        rect_add = element2(count, angle_x(i), angle_y(j), ROC_x, ROC_y, W);
        rect = [rect; rect_add];
        count = count + 1;
    end
end

%subtract maximal z from all so that the top-most element's center is
%positioned at z = 0:
mv = max(rect(:,end));
rect(:,end) = rect(:,end) - mv;
rect(:,4) = rect(:,4) - mv;
rect(:,7) = rect(:,7) - mv;
rect(:,10) = rect(:,10) - mv;
rect(:,13) = rect(:,13) - mv;

%get centers
cent = rect(:, end-2:end);

%Place the static focus at the center of rotation
focus = [0, 0, -min([ROC_x, ROC_y])/1000];

%create array
tx1 = xdc_rectangles( rect, cent, focus);
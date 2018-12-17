function tx1 = xdc_concaveArray( nelements, ROC, AngExtent, ElH, ElF,W, P, Nx,Ny)
%
% Function returns a handle to a Field-II array object
% A concave array with the following properties
% where:
%	nelements - Number fo elements
%	ROC = radius of curvature (mm)
%	AngExtent = angular extent of the array (radians)
%	ElH = elevation height (mm)
%	ElF = elevation focus (mm)
%	W = width of the array elements (mm)
%	P = pitch of the array elements (mm)
%	Nx = number of mathematical subelements in x
%	Ny = number of mathematical subelements in y
%
% written by:
%	L J Busse, http://www.ljbdev.com

angle_inc = (AngExtent)/nelements; 					
index = [-fix(nelements/2):fix(nelements/2)];
angle = index*angle_inc;
numArray= length(angle);

for i=1:numArray
    [rect,cent] = elementx(i,angle(i),ROC, ElH, ElF,W,P,Nx,Ny);
    if ( i == 1) 
        rect1=rect;
        cent1=cent;
    else
        rect1 = [rect1;rect];
        cent1 = [cent1;cent];
    end
    
end

%Place the static focus at the center of rotation
focus = [0 0 0]/1000;

tx1 = xdc_rectangles( rect1, cent1, focus);

function [rect,center] = elementx(index, angle, ROC, ElH, ElF, W, P, Nx, Ny);
%
% Function will calculate the rectangles associated with one physical element of a concave linear array
% author: 
% 	L J Busse, LJB Development, Inc. ljb@ljbdev.com
%
%  

%default values
if nargin < 9; Ny = 10;end		%Math elements in Y
if nargin < 8; Nx = 2;end		%Math elements in X
if nargin < 7; P = 0.3; end		%pitch
if nargin < 6; W=0.28;end		%width
if nargin < 5; ElF = 0;end		%elevation focus
if nargin < 4; ElH = 5.; end	%elevation height
if nargin < 3; ROC = 100; end	
if nargin <	2; angle =0.;end
if nargin < 1; index = 1; end

num_elem = Nx*Ny;
x1=zeros(1,num_elem);
x2=zeros(1,num_elem);
x3=zeros(1,num_elem);
x4=zeros(1,num_elem);
y1=zeros(1,num_elem);
y2=zeros(1,num_elem);
y3=zeros(1,num_elem);
y4=zeros(1,num_elem);
z1=zeros(1,num_elem);
z2=zeros(1,num_elem);
z3=zeros(1,num_elem);
z4=zeros(1,num_elem);
c1=zeros(1,num_elem);
c2=zeros(1,num_elem);
c3=zeros(1,num_elem);
c4=zeros(1,num_elem);
ind=ones(1,num_elem);
apo=ones(1,num_elem);

Y = ElH;
yinc = Y / Ny;
xinc = W / Nx;
x=[-W/2:xinc:W/2];
y=[Y/2:-yinc:-Y/2];

if ElF == 0,
	z = ROC*ones(size(y)); %Just flat 
else 
	t = asin( y/ElF);
	z = ROC - ElF* (1- cos(t));
end
	
center = [0 0 ROC];

i = 1;
for ix = 1:Nx
	for iy = 1:Ny
		x1(i) = x(ix);
		x2(i) = x(ix+1);
		x3(i) = x(ix+1);
		x4(i) = x(ix);
		y1(i) = y(iy+1);
		y2(i) = y(iy+1);
		y3(i) = y(iy);
		y4(i) = y(iy);
		z1(i) = z(iy+1);
		z2(i) = z(iy+1);
		z3(i) = z(iy);
		z4(i) = z(iy);
		c1(i) = (x1(i) + x2(i))/2;
		c2(i) = (y1(i) + y3(i))/2;
		c3(i) = (z1(i) + z3(i))/2;
		i = i+1;
	end
end
		
% Rotation goes here
% do the rotation about the yaxis
%rot = makeyrotform(angle);
rot =1;
% apply the rotation
for i=1:num_elem
    invec = [x1(i), y1(i), z1(i), 0]';
    outvec = rot * invec;
    x1(i) = outvec(1); y1(i) = outvec(2); z1(i) = outvec(3);
    
    invec = [x2(i), y2(i), z2(i), 0]';
    outvec = rot * invec;
    x2(i) = outvec(1); y2(i) = outvec(2); z2(i) = outvec(3);
    
    invec = [x3(i), y3(i), z3(i), 0]';
    outvec = rot * invec;
    x3(i) = outvec(1); y3(i) = outvec(2); z3(i) = outvec(3);
    
    invec = [x4(i), y4(i), z4(i), 0]';
    outvec = rot * invec;
    x4(i) = outvec(1); y4(i) = outvec(2); z4(i) = outvec(3);
    
    invec = [c1(i), c2(i), c3(i), 0]';
    outvec = rot * invec;
    c1(i) = outvec(1); c2(i) = outvec(2); c3(i) = outvec(3);

end
invec = [center(1), center(2), center(3), 0]';
outvec = rot * invec;
center(1)= outvec(1); center(2) = outvec(2); center(3) = outvec(3);

%convert everything to meters
x1 = x1/1000;
x2 = x2/1000;
x3 = x3/1000;
x4 = x4/1000;

y1 = y1/1000;
y2 = y2/1000;
y3 = y3/1000;
y4 = y4/1000;

z1 = (z1)/1000;
z2 = (z2)/1000;
z3 = (z3)/1000;
z4 = (z4)/1000;

c1 = c1/1000;
c2 = c2/1000;
c3 = c3/1000;

center = center/1000;

ind = index;
rect = [ind x1(1)  y1(1)  z1(1)  x2(1)  y2(1)  z2(1)  x3(1)  y3(1)  z3(1)  x4(1)  y4(1)  z4(1)  apo(1)  xinc/1000  yinc/1000  c1(1)  c2(1)  c3(1) ];
for i = 2:num_elem
	rect = [rect
            [ind x1(i)  y1(i)  z1(i)  x2(i)  y2(i)  z2(i)  x3(i)  y3(i)  z3(i)  x4(i)  y4(i)  z4(i)  apo(i)  xinc/1000  yinc/1000  c1(i)  c2(i)  c3(i) ] ];
end
	

function rect = element2(index, angle_x, angle_y, ROC_x, ROC_y, W)
%
% Function will calculate the rectangles associated with one physical element of a concave linear array
% author: 
% 	L J Busse, LJB Development, Inc. ljb@ljbdev.com
%
%  

num_elem = 1;
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

x = [-W/2, W/2];
y = [-W/2, W/2];

alphax = asin(x / ROC_x);
alphay = asin(y / ROC_y);
% z = ROC_x * cos(alphax) - ROC_y * sin(alphay);

z = ROC_x * ones(size(x)); %default, ROC_x == ROC_y
if ROC_x == 0 || ROC_x >= 1e5,
    z = ROC_y ./ cos(alphay);
end
if ROC_y == 0 || ROC_y >= 1e5,
    z = ROC_x ./ cos(alphax);
end

i = 1;
ix = 1;
iy = 1;
iz = 1;
x1(i) = x(ix);
x2(i) = x(ix+1);
x3(i) = x(ix+1);
x4(i) = x(ix);
y1(i) = y(iy);
y2(i) = y(iy);
y3(i) = y(iy+1);
y4(i) = y(iy+1);
z1(i) = z(iz);
z2(i) = z(iz);
z3(i) = z(iz+1);
z4(i) = z(iz+1);
c1(i) = (x1(i) + x2(i))/2;
c2(i) = (y1(i) + y3(i))/2;
c3(i) = (z1(i) + z3(i))/2;
		
% Rotation goes here
% do the rotation about the yaxis
rot = makexyrotform(angle_x, angle_y);

% apply the rotation
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

ind = index;

rect = [ind x1(i)  y1(i)  z1(i)  x2(i)  y2(i)  z2(i)  x3(i)  y3(i)  z3(i)  x4(i)  y4(i)  z4(i)  apo(i)  W/1000  W/1000  c1(i)  c2(i)  c3(i) ];
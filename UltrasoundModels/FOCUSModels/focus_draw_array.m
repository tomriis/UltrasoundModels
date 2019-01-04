function focus_draw_array(xdcr_array, input_color, new_figure, coordinate_grid)
% Description
%   This function creates a 3D representation of an arbitrary array of FOCUS transducers.
% Usage
%   draw_array(transducer_array);
%   draw_array(transducer_array, input_color);
%   draw_array(transducer_array, input_color, new_figure);
%   draw_array(transducer_array, input_color, new_figure, coordinate_grid);  
% Arguments
%   transducer_array: A FOCUS transducer array.
%   input_color: A color matrix (of the form [R G B], where R, G, and B are between 0 and 1) or color string (e.g. 'blue') to use for the array elements. This argument can also be an array of the same size as the transducer array. In this case, one color is defined for each element.}
%   new_figure: Create a new MATLAB figure to draw the array in rather than drawing over the old one.
%   coordinate_grid: A FOCUS coordinate grid. If this argument is present, the coordinate grid will be represented by a cube on the output plot.}
% Notes
%   This function returns nothing; it plots the given transducer array in a new MATLAB figure.
if nargin()==0
	disp('The proper usage of this function is:')
	disp('draw_array(xdcr_array,color)')
	error('color is the standard matlab color notation ')
end
if nargin() <= 3
    coordinate_grid=[];
end
if nargin() <= 2
    new_figure = 0;
end
if nargin() <= 1
	input_color=[0 1 0];
end

element_count = size(xdcr_array,1)*size(xdcr_array,2);

% If the color array isn't the same length as the transducer array, assign
% all transducers the first color in the color array
color = zeros(length(xdcr_array), 3);
if element_count ~= size(input_color,1)
    for i=1:element_count
        color(i,:) = input_color(1,:);
    end
% If they are the same length, assign all colors
else
    for i=1:element_count
        color(i,:) = input_color(i,:);
    end
end
color_index = 1;

% Spawn a new figure for this array if requested
if new_figure
    figure();
end

% Draw the elements
V=[-1 1 -1 1 -1 1];
axis(V);
hold on
for i=size(xdcr_array,1):-1:1
    for j=size(xdcr_array,2):-1:1
        if strcmp('circ', xdcr_array(i,j).shape)
            draw_circ(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('ring', xdcr_array(i,j).shape)
            draw_ring(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('sph ring', xdcr_array(i,j).shape)
            draw_spherically_focused_ring(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('shel', xdcr_array(i,j).shape)
            draw_sphericalshell(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('shell_with_hole', xdcr_array(i,j).shape)
            draw_sphericalshell_with_hole(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('circ_with_hole', xdcr_array(i,j).shape)
            draw_circ_with_hole(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('rect', xdcr_array(i,j).shape)
            focus_draw_rect(xdcr_array(i,j),color(color_index,:));
        elseif strcmp('none', xdcr_array(i,j).shape)
            %do nothing...
        else
            warning('Invalid/Unimplemented shape XDC detected')
        end
        color_index = color_index + 1;
    end
end
if (isstruct(coordinate_grid))
    x=coordinate_grid.xmax;
    y=coordinate_grid.ymax;
    mx=coordinate_grid.xmin;
    my=coordinate_grid.ymin;
    z=coordinate_grid.zmin;
    maxz=coordinate_grid.zmax;
    line([mx x],[y y],[z z]);
    line([mx mx],[y my],[z z]);
    line([mx x],[my my],[z z]);
    line([x x],[y my],[z z]);
    line([mx x],[y my],[z z]);
    line([mx x],[my y],[z z]);
    line([mx x],[y y],[maxz maxz]);
    line([mx mx],[y my],[maxz maxz]);
    line([mx x],[my my],[maxz maxz]);
    line([x x],[y my],[maxz maxz]);
    line([mx x],[y my],[maxz maxz]);
    line([mx x],[my y],[maxz maxz]);
    line([mx mx],[my my],[z maxz]);
    line([mx mx],[y y],[z maxz]);
    line([x x],[my my],[z maxz]);
    line([x x],[y y],[z maxz]);

end

hold off
axis tight;
V=axis;

V(1)=min([V(1) V(3)]);
V(2)=max([V(2) V(4)]);
V(3)=V(1);
V(4)=V(2);
if strcmp('shel', xdcr_array(i).shape)
    V(6)=max([-V(5) V(6)]);
    V(6)=V(6)+xdcr_array(i).radius;
    V(5)=-V(6);
% elseif strcmp('shell_with_hole', xdcr_array(i).shape)
%     V(5)=-max([V(1)/2 -V(5)]);
%     V(6)=max([V(6) -V(5)]);
%     V(5)=-2*V(6);
else
    V(5)=V(1)/2;
%     if length(V)==6
%         V(6)=max([V(2) V(6)]);
%     else
        V(6)=V(2);
%     end
end
axis(V);
grid on;
%axis equal

function [Th] = concave_focused_array(n_elements_x, ROC_x, P, element_W, Rfocus, Nx, Ny, type)
    % All dimensions in meters
    len_x = P * n_elements_x; %arc length
    AngExtent_x = len_x / ROC_x;
    angle_inc_x = (AngExtent_x)/n_elements_x; 					
    index_x = -n_elements_x/2 + 0.5 : n_elements_x/2 - 0.5;
    angle_x = index_x*angle_inc_x;
    % Generate array 
    rectangles=[];
    for i = 1:length(index_x)
    % Create transducer
        if strcmp(type,"focused")
            % Focused
            Th = xdc_focused_array(1, element_W, element_W, 0, Rfocus, Nx, Ny, [0,0,0]);
        elseif strcmp(type,"spherical")
            % Spherical
            Th = xdc_concave(element_W, Rfocus, element_W/Nx);
        else
            % Flat
            x = [-element_W/2 element_W/2]; y = [-element_W/2 element_W/2]; z = [0,0];
            rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  element_W  element_W  0  0  0];
            cent = rect(:, end-2:end);
            Th = xdc_rectangles( rect, cent, [0,0,0]);
        end
        rect = xdc_pointer_to_rect(Th);
        rect(1,:) = i;
    % Flip tranducer 
        rot = makeyrotform(pi);
        rect = apply_affine_to_rect(rot,rect);
    % Position transducer
        rot = makeyrotform(angle_x(i));
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+ROC_x;
        positioned_rect = apply_affine_to_rect(rot, rect);
    % Append to transducer geometry
        rectangles = horzcat(rectangles, positioned_rect);
    end
    
    % Subtract maximal z from all so that the top-most element's center is
    % positioned at z = 0:
    mv = max(rectangles(end,:));
    disp(num2str(mv))
    rectangles([4,7,10,13,19],:) = rectangles([4,7,10,13,19],:) - mv;
    % Place the static focus at the center of rotation
    focus = [0, 0, -ROC_x];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    Th = xdc_rectangles(rectangles', cent', focus);
end
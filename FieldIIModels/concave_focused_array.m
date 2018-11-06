function [Th] = concave_focused_array(n_elements_x, ROC_x, AngExtent, P, element_W, Rfocus, focus, Nx, Ny)
    
    len_x = P * n_elements_x; %arc length
    AngExtent_x = len_x / ROC_x;
    angle_inc_x = (AngExtent_x)/n_elements_x; 					
    index_x = -n_elements_x/2 + 0.5 : n_elements_x/2 - 0.5;
    angle_x = index_x*angle_inc_x;
    numArray_x = length(angle_x);
    % Generate array 
    rectangles=[];
    for i = 1:numArray_x
    % Create focused transducer
        Th = xdc_focused_array(1, element_W/1000, element_W/1000, 0, Rfocus/1000, Nx, Ny, focus/1000);
        rect = xdc_pointer_to_rect(Th);
        rect(1,:) = i;
    % Flip tranducer 
        rot = makeyrotform(pi);
        rect = apply_affine_to_rect(rot,rect);
    % Position transducer
        rot = makeyrotform(angle_x(i));
        rect([4,7,10,13],:)=rect([4,7,10,13],:)+ROC_x/1000;
        positioned_rect = apply_affine_to_rect(rot, rect);
    % Append to transducer geometry
        rectangles = horzcat(rectangles, positioned_rect);
    end
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    Th = xdc_rectangles(rectangles', cent', focus/1000);
end
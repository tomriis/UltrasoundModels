function [rectangles] = concave_focused_array(no_elements_x, ROC_x, AngExtent, P, element_W, Rfocus, focus, Nx, Ny)
    
    len_x = P * nelements_x; %arc length
    AngExtent_x = len_x / ROC_x;
    angle_inc_x = (AngExtent_x)/nelements_x; 					
    index_x = -nelements_x/2 + 0.5 : nelements_x/2 - 0.5;
    angle_x = index_x*angle_inc_x;
    numArray_x = length(angle_x);
    % Generate array 
    rectangles=[];
    for i = 1:numArray_x
    % Create focused transducer
        Th = xdc_focused_array (1, element_W, element_W, 0, Rfocus, Nx, Ny, focus);
        rect = xdc_pointer_to_rect(Th);
        rect(1,:) = index;
    % Position transducer
        rot = makeyrotform(angle_x(i));
        rect([3,6,9,12],:)=rect([3,6,9,12])+ROC_x;
        rectangles(end) = apply_affine_to_rect(rot, rect);
    end
end
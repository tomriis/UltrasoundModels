function [rect] = xdc_pointer_to_rect(Th)
    % Converts the xdc info to a form for xdc_rectangles
    data = xdc_get(Th,'rect');
    N_elements = size(data,2);
    rect = zeros(19, N_elements);
    for k = 1:N_elements
        % Number of the physical element 
        rect(1, k) = data(1, k);
        % Corners of the mathematical elements;
        rect(2:13, k) = data(11:22, k);
        % Apodization of mathmatical element
        rect(14, k) = data(5, k);
        % Width and height
        rect(15, k) = data(3, k);
        rect(16, k) = data(4, k);
        % Center point of rectangle
        rect(17:19, k) = data(8:10, k);
    end
end
function [Th] = concave_focused_array(n_elements_x, ROC_x, P, D, R_focus, Nx, Ny, type)
    % All dimensions in meters
    len_x = P * n_elements_x; %arc length
    AngExtent_x = len_x / ROC_x;
    angle_inc_x = (AngExtent_x)/n_elements_x; 					
    index_x = -n_elements_x/2 + 0.5 : n_elements_x/2 - 0.5;
    angle_x = index_x*angle_inc_x;
    
    % Same 
    len_y = D(2);
    AngExtent_y = len_y/ R_focus;
    angle_inc_y = AngExtent_y/Ny;
    index_y = -Ny/2+0.5: Ny/2-0.5;
    angle_y = index_y * angle_inc_y;
    % Generate array 
%     if strcmp(type,'focused2')
%         Ny = round(D(2)/D(1));
%         [Th, rect, cent, focus] = xdc_concaveArray2(n_elements_x, Ny, ROC_x*1000, R_focus*1000, D(1)*1000, P*1000);
%         return
%     end
    rectangles=[];
    for i = 1:length(index_x)
    % Create transducer
        if strcmp(type,'focused')
            % Focused
            Th = xdc_focused_array(1, D(1), D(2), 0, R_focus, Nx, Ny, [0,0,0]);
        elseif strcmp(type,'spherical')
            % Spherical
            Th = xdc_concave(D(1), R_focus, D(1)/Nx);
        elseif strcmp(type,'focused2')
            focused_rectangles = [];
            for k=1:length(angle_y)
                x = [-D(1)/2 D(1)/2]; y = [-(D(2)/Ny)/2 (D(2)/Ny)/2]; z = [0,0];
                rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
                rect = rect';
                rot = makexrotform(angle_y(k));
                rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+ROC_x;
                positioned_rect = apply_affine_to_rect(rot, rect);
    %           Append to transducer geometry
                focused_rectangles = horzcat(focused_rectangles, positioned_rect);
            end
            mv = max(focused_rectangles(end,:));
            focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
            % Place the static focus at the center of rotation
            focus = [0, 0, -ROC_x];
            % Convert to transducer pointer
            cent = focused_rectangles(end-2:end,:);
            Th = xdc_rectangles(focused_rectangles', cent', focus);
        else
            % Flat
            x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
            rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
            cent = rect(:, end-2:end);
            Th = xdc_rectangles( rect, cent, [0,0,0]);
        end
        rect = xdc_pointer_to_rect(Th);
        rect(1,:) = i;
    % Flip tranducer 
    if ~strcmp(type, 'focused2')
        rot = makeyrotform(pi);
        rect = apply_affine_to_rect(rot,rect);
    end
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
    rectangles([4,7,10,13,19],:) = rectangles([4,7,10,13,19],:) - mv;
    % Place the static focus at the center of rotation
    focus = [0, 0, -ROC_x];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    Th = xdc_rectangles(rectangles', cent', focus);
end
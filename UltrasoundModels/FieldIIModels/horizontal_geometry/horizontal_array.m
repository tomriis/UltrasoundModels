function [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D_rz, R_focus,a,b)
% a=240/1000; b=240/1000; n_elements_r = 64; n_elements_z=4; kerf=0.4/1000; D_rz=[11.1,8]/1000; R_focus=1e15;    
     angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);
%     len_z = (D_rz(2)+kerf)*n_elements_z;
%     AngExtent_z = len_z/ R_focus;
%     angle_inc_z = AngExtent_z/n_elements_z;
%     index_z = -n_elements_z/2+0.5: n_elements_z/2-0.5;
%     angle_z = index_z* angle_inc_z;
    n_elements_x=n_elements_r;
    n_elements_y=n_elements_z;

    D = D_rz;
    % All dimensions in meters
    
    AngExtent_x = 2*pi; %len_x / ROC_x;
    angle_inc_x = (AngExtent_x)/n_elements_x; 					
    index_x = -n_elements_x/2 + 0.5 : n_elements_x/2 - 0.5;
    angle_r = index_x*angle_inc_x;
    
    len_y = (D(2)+kerf)*n_elements_y;
    AngExtent_y = len_y/ R_focus;
    angle_inc_y = AngExtent_y/n_elements_y;
    index_y = -n_elements_y/2+0.5: n_elements_y/2-0.5;
    angle_y = index_y* angle_inc_y;
    
    rectangles=[];
    for i = 1:length(angle_r)
            focused_rectangles = [];
            for k=1:length(angle_y)
                x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
                rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
                rect = rect';
                rot = makexrotform(angle_y(k));
                rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+R_focus;
                positioned_rect = apply_affine_to_rect(rot, rect);
    %           Append to transducer geometry
                focused_rectangles = horzcat(focused_rectangles, positioned_rect);
            end
            mv = min(focused_rectangles(end,:));
            focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
            % Place the static focus at the center of rotation
            focus = [0, 0, -a/2];
            % Convert to transducer pointer
            cent = focused_rectangles(end-2:end,:);
            Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
            rect = xdc_pointer_to_rect(Th);
    
    % Position transducer
        rot = make_ellipse_y_rot_mat(angle_r(i),a, b);
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+a/2;
        positioned_rect = apply_affine_to_rect(rot, rect);
    % Append to transducer geometry
        rectangles = horzcat(rectangles, positioned_rect);
    end
    
    % Subtract maximal z from all so that the top-most element's center is
    % positioned at z = 0:
    mv = max(rectangles(end,:));
    rectangles([4,7,10,13,19],:) = rectangles([4,7,10,13,19],:) - mv;
    % Place the static focus at the center of rotation
    focus = [0, 0, -a/2];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    rectangles(1,:) = 1:(n_elements_x*n_elements_y);
    %center_elements = get_center_elements(rectangles);
    %cent = center_elements(end-2:end,:);
    areas = zeros(size(rectangles,2),1);
    for i = 1:length(areas)
        areas(i) = find_rect_area(rectangles(:,i));
    end
    figure; hist(areas);
    
    Th = xdc_rectangles(rectangles', cent', focus);
end
function [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D_rz, R_focus,a,b)
    
    angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);
    len_z = (D_rz(2)+kerf)*n_elements_z;
    AngExtent_z = len_z/ R_focus;
    angle_inc_z = AngExtent_z/n_elements_z;
    index_z = -n_elements_z/2+0.5: n_elements_z/2-0.5;
    angle_z = index_z* angle_inc_z;
    
    rectangles=[];
    for i = 1:length(angle_r)
        % Create transducer
        focused_rectangles = [];
        for k=1:length(angle_z)
            x = [-D_rz(1)/2 D_rz(1)/2]; z = [0, 0];  y = [-D_rz(2)/2 D_rz(2)/2];
            rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D_rz(1)  D_rz(2)  0  0  0];
            rect = rect';
            rot = makexrotform(angle_z(k));
            rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+R_focus;
            positioned_rect = apply_affine_to_rect(rot, rect);
            %  Append to transducer geometry
            focused_rectangles = horzcat(focused_rectangles, positioned_rect);
        end
        focused_rectangles([4,7,10,13,19],:)=focused_rectangles([4,7,10,13,19],:) - R_focus;
        % Place the static focus at the center of rotation
        focus = [0, 0, 0];
        % Convert to transducer pointer
        cent = focused_rectangles(end-2:end,:);
        Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
    % Position transducer
        rect = xdc_pointer_to_rect(Th);
        rot = make_ellipse_y_rot_mat(angle_r(i),a,b);
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+b/2;
        positioned_rect = apply_affine_to_rect(rot, rect);
    % Append to transducer geometry
        rectangles = horzcat(rectangles, positioned_rect);
    end
    
    % Place the static focus at the center of rotation
    focus = [0, 0, 0];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    rectangles(1,:) = 1:(n_elements_r*n_elements_z);
    %center_elements = get_center_elements(rectangles);
    %cent = center_elements(end-2:end,:);
    Th = xdc_rectangles(rectangles', cent', focus);
end
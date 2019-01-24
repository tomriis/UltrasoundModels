function [Th] = horizontal_array(n_elements_r, n_elements_z, ROC_r, kerf, D_rz, R_focus)
    len_z = (D(2)+kerf)*n_elements_z;
    AngExtent_z = len_z/ R_focus;
    angle_inc_z = AngExtent_z/n_elements_z;
    index_z = -n_elements_z/2+0.5: n_elements_y/2-0.5;
    angle_z = index_z* angle_inc_z;
    
    rectangles=[];
    for i = 1:length(index_r)
        % Create transducer
        focused_rectangles = [];
        for k=1:length(angle_y)
            x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
            rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
            rect = rect';
            rot = makexrotform(angle_y(k));
            rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+R_focus;
            positioned_rect = apply_affine_to_rect(rot, rect);
            %  Append to transducer geometry
            focused_rectangles = horzcat(focused_rectangles, positioned_rect);
        end
        mv = min(focused_rectangles(end,:));
        focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
        % Place the static focus at the center of rotation
        focus = [0, 0, -ROC_x];
        % Convert to transducer pointer
        cent = focused_rectangles(end-2:end,:);
        Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
    
end
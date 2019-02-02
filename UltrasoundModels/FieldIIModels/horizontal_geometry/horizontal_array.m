function [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b)
    angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);
    
    len_z = (D(2)+kerf)*n_elements_z;
    AngExtent_z = len_z/ R_focus;
    angle_inc_z = AngExtent_z/n_elements_z;
    index_z = -n_elements_z/2+0.5: n_elements_z/2-0.5;
    angle_z = index_z* angle_inc_z;
       
    %AngExtent_x = 2*pi; %len_x / ROC_x;
    %angle_inc_x = (AngExtent_x)/n_elements_x; 					
    %index_x = -n_elements_x/2 + 0.5 : n_elements_x/2 - 0.5;
    %angle_r = index_x*angle_inc_x;
    
    angle_hor = zeros(1,length(angle_r));
   
    rectangles=[];
    for i = 1:length(angle_r)
            focused_rectangles = [];
            for k=1:length(angle_z)
                x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
                rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
                rect = rect';
                rot = makexrotform(angle_z(k));
                rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+R_focus;
                positioned_rect = apply_affine_to_rect(rot, rect);
    %           Append to transducer geometry
                focused_rectangles = horzcat(focused_rectangles, positioned_rect);
            end
            mv = min(focused_rectangles(end,:));
            focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
            cent = focused_rectangles(end-2:end,:);
            Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
            rect = xdc_pointer_to_rect(Th);
    
    % Position transducer
        angle_hor(i) = find_angle_at_point(angle_r(i),[a*cos(angle_r(i)),b*sin(angle_r(i))],a,b);
        roty = makeyrotform(angle_hor(i));
        center = [b*sin(angle_r(i)); 0; a*cos(angle_r(i))];%center_rect([17,18,19],1);
        for j = 1:size(rect,2)
            for ii = 1:4
                xyz_i = [3*ii-1, 3*ii, 3*ii+1];
                invec = [rect(xyz_i,j);0];
                outvec = roty * invec;
                rect(xyz_i,j) = center+outvec(1:3);
                rect([17,18,19],j) = center;
            end
        end
    % Append to transducer geometry
        rectangles = horzcat(rectangles, rect);
    end
    
    % Subtract maximal z from all so that the top-most element's center is
    % positioned at z = 0:
%     mv = max(rectangles(end,:));
%     rectangles([4,7,10,13,19],:) = rectangles([4,7,10,13,19],:)-mv;
    % Place the static focus at the center of rotation
    focus = [0,0,0];%[0, 0, -a/2];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    rectangles(1,:) = 1:(n_elements_r*n_elements_z);
    Th = xdc_rectangles(rectangles', cent', focus);
end
function [rectangles, cent] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,varargin)
    
    angle_z = arrayColumnAngleZ(R_focus, kerf,D,n_elements_z,0);
    
%     angle_r = get_ellipse_angle_spacing(a,b,n_elements_r);
    
%     angle_r = getSymmetricAngleSpacing(a,b,N,kerf(2),D(2),start);
    angle_r = getSymmetricAngleSpacing(a,b,varargin{1}, n_elements_r/2);

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
            focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - R_focus;
            cent = focused_rectangles(end-2:end,:);
            Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);
            rect = xdc_pointer_to_rect(Th);
    
    % Position transducer
        angle_hor(i) = find_angle_at_point(angle_r(i),[a*cos(angle_r(i)),b*sin(angle_r(i))],a,b,varargin{2});
%  angle_hor = angle_r;
        roty = makeyrotform(angle_hor(i));
        
        rot = make_ellipse_y_rot_mat(angle_r(i),a,b);
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+a;
        positioned_rect = apply_affine_to_rect(rot, rect);
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)-a;
        centers = positioned_rect([17, 18, 19],:);
        
        %center = [b*sin(angle_r(i)); 0; a*cos(angle_r(i))];%center_rect([17,18,19],1);
        for j = 1:size(rect,2)
            center = mean(centers,2);
            points = zeros(3,4);
            xz_center = [center(1); 0; center(3)];
            for ii = 1:4
                xyz_i = [3*ii-1, 3*ii, 3*ii+1];
                invec = [rect(xyz_i,j);0];
                outvec = roty * invec;
                rect(xyz_i,j) = xz_center+outvec(1:3);
                points(:,ii)=rect(xyz_i,j);
            end
            rect([17,18,19],j) = mean(points,2);
        end
    % Append to transducer geometry
        rectangles = horzcat(rectangles, rect);
    end
    
    % Subtract maximal z from all so that the top-most element's center is
    % positioned at z = 0:
%     mv = max(rectangles(end,:));
%     rectangles([4,7,10,13,19],:) = rectangles([4,7,10,13,19],:)-mv;
    % Place the static focus at the center of rotation
    focus = [0,0,0];
    % Convert to transducer pointer
    cent = rectangles(end-2:end,:);
    rectangles(1,:) = 1:size(rectangles,2);
    rectangles = rectangles';
    cent = cent';
%     Th = xdc_rectangles(rectangles, cent, focus);
end
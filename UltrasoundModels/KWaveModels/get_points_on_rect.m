function points = get_points_on_rect(corners,kgrid)
    max_range = max([range(corners(1,:)),range(corners(2,:)), range(corners(3,:))]);
    n_samples = round(max_range/kgrid.dx)*3;
    
    points = [];
    i=1;
        v1 = corners(i,:);
        v2 = corners(wrapN(i-1,4),:);
        v3 = corners(wrapN(i+1,4),:);
        
        c_p = abs(cross(v3-v1,v2-v1));
        
        x_vec = max_span(v1,v2,v3,1,n_samples);
        y_vec = max_span(v1,v2,v3,2,n_samples);
        
        for j = 1:length(x_vec)
            z_vec = v1(3)-(c_p(1)*(x_vec(j)-v1(1))+c_p(2)*(y_vec-v1(2)))/c_p(3);
            point_set = [repmat(x_vec(j),[n_samples,1]); y_vec'; z_vec']';
            points = horzcat(points,point_set);
        end
        
        points = unique(points','rows')';
end

function span = max_span(v1,v2,v3,dim,n_samples)
    if abs(v1(dim)-v2(dim)) > abs(v1(dim)-v3(dim))
        span = linspace(v1(dim),v2(dim),n_samples);
    else
        span = linspace(v1(dim),v3(dim),n_samples);
    end
end

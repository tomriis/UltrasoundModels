function points = get_points_on_rect(corners,kgrid)
    max_range = max([range(corners(1,:)),range(corners(2,:)), range(corners(3,:))]);
    n_samples = round(max_range/kgrid.dx)*5;
    
    points = zeros(3,n_samples^2);
   
    v1 = corners(:,1);
    v2 = corners(:,2);
    v3 = corners(:,4);
    t = linspace(0,1,n_samples);
    r = linspace(0,1,n_samples);
    
    count = 1;
    for i = 1:length(t)
        for ii = 1:length(r)
            points(:,count) = (v3-v1)*r(ii)+(v2-v1)*t(i)+v1;         
            count = count +1;
        end
    end            
end


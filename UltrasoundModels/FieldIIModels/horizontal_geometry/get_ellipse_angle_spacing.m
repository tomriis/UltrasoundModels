function angles_r = get_ellipse_angle_spacing(a,b, N)
        p = ellipse_perimeter(a,b);
       
        arc_length = p/N;
        X = linspace(0,2*pi,5000);
        Y = sqrt(a^2*sin(X).^2 + b^2*cos(X).^2);
        Y = diff(sqrt(a^2*cos(X).^2+b^2*sin(X).^2));
        
        arc_lengths = zeros(length(X),1);
        for i = 1:length(X)-2
            q = trapz(X(1:i+1), Y(1:i+1));
            arc_lengths(i+1) = q;
        end
        angles_r = zeros(N,1);
        for i = 1:N-1
            len = arc_length*i;
            [~,ind] = min(abs(arc_lengths-len));
            angles_r(i+1) = X(ind);
        end
        
        figure; plot(a*cos(angles_r), b*sin(angles_r),'b+')
        %axis tight square
end
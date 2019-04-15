function [contributions] = calculate_contributions(rect, focus, lambda)
    % calculates the power from each transducer
    % that arrives at the focus point
    contributions = zeros([2, size(rect,2)]);
    for i = 1:size(rect,2)
        H = rect(15,i); W = rect(16,i);
        center=rect(17:end, i)';
        w = project_u_on_v(focus,center);
        z = center - w;
        x = focus - w;
        
        H_vector = rect(2:4,i)- rect(5:7,i);
        W_vector = rect(2:4,i) - rect(11:13,i);
        H_vector = H_vector/norm(H_vector);
        W_vector = W_vector/norm(W_vector);
        power_H = calculate_power(H, lambda, abs(dot(H_vector,x)), norm(z));
        power_W = calculate_power(W, lambda, abs(dot(W_vector,x)), norm(z));
        contributions(1,i) = power_H;
        contributions(2,i) =power_W;
        
        
%         figure; quiver3(0,0,0,center(1),center(2),center(3)); 
%         hold on; quiver3(0,0,0,w(1),w(2),w(3)); hold on;
%         quiver3(w(1),w(2),w(3),x(1),x(2),x(3));
    end
end


function [power] = calculate_power(D, lambda, x_norm, z_norm)
    if x_norm > lambda*z_norm/D
        power = 0;
    else
        power = sinc(D*x_norm/(lambda*z_norm));
    end
end


    

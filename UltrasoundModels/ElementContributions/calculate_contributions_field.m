function [contributions] = calculate_contributions_field(rect, field, lambda)
    % calculates the power from each transducer
    % that arrives at the focus point
    contributions = zeros([3, size(rect,2), size(field,1)]);
    for i = 1:size(rect,2)
        H = rect(15,i); W = rect(16,i);
        center=rect(17:end, i)';
        
        w = project_u_on_v(field,repmat(center,[size(field,1), 1]));
        z = center - w;
        z_norm = vecnorm(z,2,2);
        contributions(3,i,:) = z_norm;
        x = field - w;
        
        H_vector = rect(2:4,i)- rect(5:7,i);
        W_vector = rect(2:4,i) - rect(11:13,i);
        H_vector = H_vector/norm(H_vector);
        W_vector = W_vector/norm(W_vector);
        h = abs(dot(repmat(H_vector',[size(field,1), 1]), x, 2));
        w = abs(dot(repmat(W_vector',[size(field,1), 1]), x, 2));
        power_H = calculate_power(H, lambda, h, z_norm);
        power_W = calculate_power(W, lambda, w, z_norm);
        contributions(1,i,:) = power_H;
        contributions(2,i,:) =power_W;
        %contributions(4,i,:) = ((lambda*z_norm)^2)/(H*W);
        
%         figure; quiver3(0,0,0,center(1),center(2),center(3)); 
%         hold on; quiver3(0,0,0,w(1),w(2),w(3)); hold on;
%         quiver3(w(1),w(2),w(3),x(1),x(2),x(3));
    end
end


function [power] = calculate_power(D, lambda, x_norm, z_norm)
    power = zeros([length(x_norm),1]);
    mask = x_norm < lambda*z_norm/D;
    power(mask) = sinc(D*x_norm(mask)./(lambda*z_norm(mask)));
%     if x_norm > lambda*z_norm/D
%         power = 0;
%     else
%         power = sinc(D*x_norm./(lambda*z_norm));
%     end
end
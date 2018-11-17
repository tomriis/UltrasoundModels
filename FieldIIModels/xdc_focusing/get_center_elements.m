function [center_elements] = get_center_elements(rect)
    elements = unique(rect(1,:));
    center_elements=zeros(19,length(elements));
    for x = 1:length(elements)
        ind = rect(1,:)==elements(x);
        element = rect(:,ind);
        centers = element(end-2:end,:);
        u = mean(centers,2);
        %[~,center_element] = min(sum(abs(centers-u)));
        center_elements(end-2:end,x) = u;%element(:,center_element);
    end 
end
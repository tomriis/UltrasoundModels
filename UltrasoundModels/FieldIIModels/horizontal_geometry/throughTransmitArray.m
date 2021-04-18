function [Th] = throughTransmitArray(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,columnAngle)
%     [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,[0+0.725,pi-0.725],columnAngle);
    [Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b,[0+0.8,pi-0.8],columnAngle);
    data = xdc_pointer_to_rect(Th);
%     [Th] = horizontal_array([12,12], n_elements_z, kerf, D, R_focus,a,b,[0.5,1.12;pi-1.12,pi-0.5],1);
%     data2 = xdc_pointer_to_rect(Th);

%     data = horzcat(data1, data2);
%     data(1,:) = 1:length(data);
end
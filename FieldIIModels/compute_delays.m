function delays = compute_delays(Tx, focus, c, n_elements, Nx,Ny)

%These center coordinates were returned by xdc_show(Tx) as a string; could
%parse that string but simply pasting it here:
 rect = xdc_pointer_to_rect(Tx);
 %center_elements = get_center_elements(rect);
 centers = rect(end-2:end,:)';%center_elements(end-2:end,:)';
 
 
 %compute the distance of each element from the focus, and set transmit delays
 %accordingly based on propagation speed c:
 deltas = centers - ones(length(centers), 1) * focus;
 delays = 1/c * sqrt(sum(deltas .* deltas, 2));
 delays = reshape(delays,n_elements, Nx*Ny);
 
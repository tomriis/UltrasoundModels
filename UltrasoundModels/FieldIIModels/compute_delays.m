function delays = compute_delays(rect, focus, c)
 centers = rect(end-2:end,:)'; %rect(end-2:end,:)';
 %compute the distance of each element from the focus, and set transmit delays
 %accordingly based on propagation speed c:
 deltas = centers - ones(size(centers,1), 1) * focus;
 delays = 1/c * sqrt(sum(deltas .* deltas, 2));
 delays = delays - min(delays);

end
 
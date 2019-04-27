function delays = compute_delays(rect, focus, c,jitter_amplitude)
 centers = rect(end-2:end,:)'; %rect(end-2:end,:)';
 %compute the distance of each element from the focus, and set transmit delays
 %accordingly based on propagation speed c:
 deltas = centers - ones(length(centers), 1) * focus;
 delays = 1/c * sqrt(sum(deltas .* deltas, 2));
 delays = max(delays)-delays;
 
 %row = 1:6:length(delays);
 skull_std = 0.0071/(2500);
 jitter =  jitter_amplitude*skull_std*rand([1,length(delays)])';
 delays = delays + jitter;
%  for i = 0:5
%      delays((row+i)) = delays((row+i))+jitter;
%  end
end
 
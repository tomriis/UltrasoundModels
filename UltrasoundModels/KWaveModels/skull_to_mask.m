function [mask] = skull_to_mask(filename,kgrid)
   info = niftiinfo(filename);
   V = niftiread(filename); 
   threshold = 1434;
   V(1:88,:,:) = 0; % Left limit of skull side
   V(394:end,:,:) = 0; % Right limit of skull side
   V(:,1:64,:) = 0; % % X limit of back of skull
   V(:,479:end,:) = 0; % X limit of front of skull
   V = V > threshold;
   
   
end
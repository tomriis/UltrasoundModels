function [mask,ijk_skull] = skull_to_mask(filename,kgrid)
   ijk_skull = [];
   
   info = niftiinfo(filename);
   V = niftiread(filename);
   scale = zeros([1,3]);
   f = {'x_vec','y_vec','z_vec'};
   %target = 
   for i = 1:3
       %shift = kgrid.(f{i});
       rvec{i} = ((1:size(V,i))-size(V,i)/2)*info.PixelDimensions(i)/1000;
       %rvec{i} = rvec{i} - shift(end-3);
       
       % Assumes voxels are equal dimension for kgrid
       scale(i) = floor((info.PixelDimensions(i)/(1000*kgrid.dx))/2);
   end
   threshold = 1434;
   V(1:88,:,:) = 0; % Left limit of skull side
   V(394:end,:,:) = 0; % Right limit of skull side
   V(:,1:64,:) = 0; % % X limit of back of skull
   V(:,479:end,:) = 0; % X limit of front of skull
   V = V > threshold;
   
   if kgrid.dim == 2
       V2 = reshape(V(:,256,:),[size(V,1),size(V,3)]);
       [row,column] = find(V2 == 1);
       mask = zeros(kgrid.Nx,kgrid.Ny);
       for ii = 1:length(row)
           i = row(ii); j = column(ii);
           [ijk,~]=coordinates_to_index(kgrid, [rvec{1}(i),rvec{3}(j),0]);
           x = (ijk(1)-scale(1)):(ijk(1)+scale(1));
           y = (ijk(3)-scale(3)):(ijk(3)+scale(3));
           [A,B] = meshgrid(x,y);
            c=cat(2,A',B');
            ij = reshape(c,[],2);
            ijk_skull = vertcat(ijk_skull, ij);
       end
       
   end
   ijk_skull=unique(ijk_skull,'rows');
   for i = 1:length(ijk_skull)
       mask(ijk_skull(i,1),ijk_skull(i,2))= 1;
   end

   
end
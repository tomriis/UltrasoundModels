function [mask,ijk_skull] = skull_to_mask(filename,kgrid, type)
   ijk_skull = [];
   
   info = niftiinfo(filename);
   V = niftiread(filename);
   scale = zeros([1,3]);
   f = {'x_vec','y_vec','z_vec'};

   for i = 1:3
       rvec{i} = ((1:size(V,i))-size(V,i)/2)*info.PixelDimensions(i)/1000;
       scale(i) = floor((info.PixelDimensions(i)/(1000*kgrid.dx))/2);
   end
  
   threshold = 1500; %1628
   V(1:88,:,:) = 0; % Left limit of skull side
   V(394:end,:,:) = 0; % Right limit of skull side
   V(:,1:64,:) = 0; % % X limit of back of skull
   V(:,479:end,:) = 0; % X limit of front of skull
   V = V > threshold;
   
   if kgrid.dim == 2
       if strcmp(type, 'coronal')
            V2 = reshape(V(:,256,:),[size(V,2),size(V,3)]);
            scale_x = scale(1);
            scale_y = scale(3);
            y_i = 3;
       else
           V2 = reshape(V(:,:,floor(size(V,3)/2)),[size(V,1),size(V,2)]);
           V2(322:end,1:84) = 0;
           V2(362:end, 1:118) = 0;
           V2(1:168,1:91) = 0;
           V2(1:144,1:116) = 0;
           scale_x = scale(1);
           scale_y = scale(2);
           y_i = 2;
       end
       [row,column] = find(V2 == 1);
       mask = zeros(kgrid.Nx,kgrid.Ny);
       for ii = 1:length(row)
           i = row(ii); j = column(ii);
           [ijk,~]=coordinates_to_index(kgrid, [rvec{1}(i),rvec{y_i}(j),0]);
           x = (ijk(1)-scale_x):(ijk(1)+scale_x);
           y = (ijk(2)-scale_y):(ijk(2)+scale_y+1);
           x= x(and(x>=1, x <= kgrid.Nx));
           y= y(and(y>=1, y <= kgrid.Ny));
           [A,B] = meshgrid(x,y);
            c=cat(2,A',B');
            ij = reshape(c,[],2);
            ijk_skull = vertcat(ijk_skull, ij);
       end
       
   else
       
   end
   ijk_skull=unique(ijk_skull,'rows');
   for i = 1:length(ijk_skull)
       if kgrid.dim == 2
            mask(ijk_skull(i,1),ijk_skull(i,2))= 1;
       else
           mask(ijk_skull(i,1),ijk_skull(i,2),ijk_skull(i,3))=1;
       end
   end

   
end
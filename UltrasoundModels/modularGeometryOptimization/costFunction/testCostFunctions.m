% Test Cost functions



S = load('D:\modularGeometryOptimization\testCostFunctionScan1.mat');

scanNumbers = [55,99,46,28,23,80,81,82,226,235,238,244,198,161,153,145,218,217];
fmax = zeros([1,length(S.data)]);
fwhmmax = fmax;
e = fmax;
ii = fmax;

for i = 2:length(S.data)-80
   fmax(i) = max(S.data(i).max_hp,[],'all');
%      disp(i);
     [x,y,z] = get_plane_xyz(S.data(i).plane, S.data(i).focus);
     fwhmAxis = [1,2];
     if strcmp(S.data(i).plane, 'yz')
         x = y;
         y = z;
         fwhmAxis = [2,3];
     elseif strcmp(S.data(i).plane,'xz')
         y = z;
         fwhmAxis = [1,3];
     end
     field = S.data(i).max_hp';
     focus = S.data(i).focus;
     FWHM = fullWidthHalfMax(field, x,y, focus, [1,2]);
     fwhmmax(i) = max(FWHM);
     e(i) = entropy(field);
     ii(i) = fieldIntensityIntegral(field*1e3, abs(x(1)-x(2))*abs(y(1)-y(2)));
     figure; imagesc(field); title([num2str(e(i)),'  fwhm ',num2str(100*fwhmmax(i)),...
         '   Pmax',num2str(fmax(i)),' InInt ',num2str(ii(i))]);
     
end

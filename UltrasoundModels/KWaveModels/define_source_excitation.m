function [p] = define_source_excitation(ijk, kgrid,delays, fo, Mag, Dimension)
    f = fieldnames(ijk);
    time_index =1:length(kgrid.t_array);
    count = 1;
    ijk_all = [];
    for i = 1:length(f)
        ijk_all = horzcat(ijk_all, ijk.(f{i}));
    end
    ijk_all = ijk_all';
    
    if Dimension == 2
        p=zeros(size(ijk_all,1),length(time_index));
        for k = 1: kgrid.Nz
                row_inds = ijk_all(:,2)== k;
                if any(row_inds==1)
                    coordinates = ijk_all(row_inds,:);
                    [~,ia] = sort(coordinates(:,1));
                    coordinates = coordinates(ia,:);
                    for i= 1:size(coordinates,1)
                        for ii = 1:length(f)
                            rectn2d=ijk.(f{ii})';
                            members = ismember(rectn2d,coordinates(i,:),'rows');
                            if any(members==1)
                                rect_n = ii;                      
                                phi = 2*pi*fo*delays(rect_n);
                                excitation = Mag*sin(2*pi*fo*kgrid.t_array+phi);
                                p(count, time_index) = excitation;
                                count = count + 1;
                                continue;
                            end
                        end
                    end
                end
          
        end
        
    elseif Dimension == 3
        p=zeros(size(ijk_all,1),length(time_index));
        for k = 1:kgrid.Nz
            z_ijk_all = ijk_all(:,3) == k;
           
            for j = 1:kgrid.Ny
                row_inds = ijk_all(:,2)== j;
                
            end
        end
    end
end
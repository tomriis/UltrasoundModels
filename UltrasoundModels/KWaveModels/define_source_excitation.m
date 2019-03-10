function [p] = define_source_excitation(ijk,kgrid,delays, fo, Mag, Dimension)
    f = fieldnames(ijk);
    time_index =1:length(kgrid.t_array);
    count = 1;
    ijk_all = [];
    for i = 1:length(f)
        ijk_all = horzcat(ijk_all, ijk.(f{i}));
    end
    ijk_all = ijk_all';
    
    if Dimension == 2
        ijk_all(:,2) = [];
        ijk_all = unique(ijk_all, 'rows');
        p=zeros(size(ijk_all,1),length(time_index));
        for k = 1: kgrid.Nz
            for i = 1: kgrid.Nx
                members = ismember(ijk_all,[i,k],'rows');
                if any(members==1)
                    for ii = 1:length(f)
                        rectn2d=ijk.(f{ii})';
                        rectn2d(:,2)=[];
                        members = ismember(rectn2d,[i,k],'rows');
                        if any(members==1)
                            rect_n = ii;
                            if rect_n == 25
                                phi = 2*pi*fo*delays(rect_n);
                                excitation = Mag*sin(2*pi*fo*kgrid.t_array+phi);
                            else
                                excitation = 0;
                            end
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
            for j = 1:kgrid.Ny
                for i = 1:kgrid.Nx
                    members = ismember(ijk_all,[i,j,k],'rows');
                    if any(members==1)
                        for ii = 1:length(f)
                            members = ismember(ijk.(f{ii})',[i,k],'rows');
                            if any(members==1)
                                rect_n = ii;
                                continue;
                            end
                        end
                        phi = 2*pi*fo*delays(rect_n);
                        excitation = Mag*sin(2*pi*fo*kgrid.t_array+phi);
                        p(count, time_index) = excitation;
                        count = count + 1;
                    end
                end
            end
        end
    end
end
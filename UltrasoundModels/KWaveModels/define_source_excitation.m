function [p] = define_source_excitation(ijk,kgrid,delays)
    f = fieldnames(ijk);
    count = 1;
    ijk_all = [];
    for i = 1:length(f)
        ijk_all = horzcat(ijk_all, ijk.(f{i}));
    end
    ijk_all = ijk_all';
    for i = 1:kgrid.Nx
        for j = 1:kgrid.Ny
            for k = 1:kgrid.Nz
                members = ismember(ijk_all,[i,j,k],'rows');
                if any(members==1)
                    for ii = 1:length(f)
                        if ismember(ijk.(f{ii}),[i,j,k],'rows')
                            rect_n = ii;
                            continue;
                        end
                    end
                    excitation = delay(rect_n) - sin(kgrid.t_array);
                    p(count, kgrid.t_array) = excitation;
                    count = count + 1;
                end
            end
        end
    end
end
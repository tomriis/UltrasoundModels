function [p] = define_source_excitation(ijk, kgrid,delays, fo, Mag, Dimension)
    f = fieldnames(ijk);
    time_index =1:length(kgrid.t_array);
    ijk_all = [];
    for i = 1:length(f)
        ijk_all = horzcat(ijk_all, ijk.(f{i}));
    end
    ijk_all = ijk_all';
    T_stim =1/fo*100;
    t_i = kgrid.t_array<T_stim;
    time = kgrid.t_array(t_i);
    if Dimension == 2
        p=zeros(size(ijk_all,1),length(time_index));
        for rect_n = 1:length(f)
            t_ijk = ijk.(f{rect_n});
            for i = 1:size(t_ijk,2)
                coordinates = t_ijk(:,i);
                count = 1;
                y_terms = sum(ijk_all(:,2) < coordinates(2));
                ijk_x = ijk_all(coordinates(2) == ijk_all(:,2),1);
                x_terms = sum(ijk_x < coordinates(1));
                count = count+ y_terms+x_terms; 
                phi = 2*pi*fo*delays(rect_n);
                excitation = zeros([1,length(kgrid.t_array)]);
                excitation(t_i) = Mag*sin(2*pi*fo*kgrid.t_array(t_i)+phi);
                p(count, time_index) = excitation;
            end
        end
    elseif Dimension == 3
        p=zeros(size(ijk_all,1),length(time_index));
        for rect_n = 1:length(f)
            disp(strcat("Defining transducer: ", num2str(rect_n)," of ",num2str(length(f))));
            t_ijk = ijk.(f{rect_n});
            for i = 1:size(t_ijk,2)
                coordinates = t_ijk(:,i);
                count = 1;
                z_terms = sum(ijk_all(:,3)<coordinates(3));
                ijk_xy = ijk_all(coordinates(3)==ijk_all(:,3),1:2);
                y_terms = sum(ijk_xy(:,2) < coordinates(2));
                ijk_x = ijk_xy(coordinates(2) == ijk_xy(:,2),1);
                x_terms = sum(ijk_x < coordinates(1));
                count = count + z_terms + y_terms + x_terms; 
                
                phi = 2*pi*fo*delays(rect_n);
                excitation = zeros([1,length(kgrid.t_array)]);
                excitation(t_i) = Mag*sin(2*pi*fo*kgrid.t_array(t_i)+phi);
                
                p(count, time_index) = excitation;
            end
        end
    end
end
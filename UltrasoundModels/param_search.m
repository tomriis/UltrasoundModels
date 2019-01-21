function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = './param_search_256fine0.mat';
n_elements_x = [64];
n_elements_y = [4,5,6];
element_W_x = [4,6,8];
element_W_y = 6;
focus = [0,25,30,35,40];
focus_z = 0;%[40,20,-20,-40];
ROC = [120, 100, 80];
Slice = {'xy','xz','yz'};
total = length(focus_z)*length(n_elements_y)*length(element_W_x)*length(element_W_y)*length(focus)*length(ROC)*length(Slice);
count = 0;
M = 1;
data = struct();
data_error = struct();
% for a = 1:length(n_elements_x)
%     n_elements_x_i = n_elements_x(a);
for b = 1:length(n_elements_y)
    n_elements_y_i = n_elements_y(b);
    n_elements_x_i = floor(256/n_elements_y_i);
for f = 1:length(focus)
    focus_i = focus(f);
for fz =1:length(focus_z)
    focus_z_i = focus_z(fz);
for roc = 1:length(ROC)
    ROC_i = ROC(roc);
    R_focus_i = ROC_i;
for w = 1:length(element_W_x)
    W_i = element_W_x(w);
    P = W_i+0.4;
    
    AngleOfExtent = P*n_elements_x_i/ROC_i;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    H_i = element_W_y(y);
for sl =1:length(Slice)
    slice_i=Slice{sl};

    disp('-----------------------------------------')
     disp('-----------------------------------------')
    disp(strcat('      ',num2str(count),' of ', num2str(total)));
     disp('-----------------------------------------')
      disp('-----------------------------------------')
    count = count + 1;
    
    s = struct();
    s.M = M; s.NX = n_elements_x_i; s.NY =n_elements_y_i; s.ROC = ROC_i; s.W = W_i; s.H = H_i;
    s.F = focus_i; s.Slice = slice_i; s.Ro = R_focus_i; s.ElGeo = 2; s.Z = focus_z_i;

    fname = fieldname_from_params(s);
    try
if M == 1    
    [txfeilddb, xdc_data] = human_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
    [W_i H_i],[focus_i,0,-ROC_i+focus_z_i],'element_geometry','focused2','R_focus',R_focus_i,...,
    'Slice',slice_i, 'visualize_output',false);
else
    R_focus_i = 1e15;
    [txfeilddb, xdc_data] = concave_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
    [W_i H_i],[focus_i,0,ROC_i],'element_geometry','focused2','Slice',slice_i);
end
% Save field
data.(fname) = txfeilddb;
% save the transducer geometry
k = strfind(fname,'Slice_');
fname(k:end)=[];
data.(strcat('G_',fname)) = xdc_data;
    catch e
        disp(strcat('ERROR ON ',fname));
        data_error.(fname)=e.message;
    end
%end
%end
end
end
end
end
end
end
end
save(outfile, '-struct', 'data');
end
function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = './param_search_field.mat';
n_elements_x = [64];
n_elements_y = [12,3,4];
element_W_x = [1.0,2.0];%2.5,3.0,3.5,4];
element_W_y = [10,20];
focus = [0,40];
ROC = [120 160];
Slice = {'xy','xz','yz'};
total = length(element_W_x)*length(element_W_y)*length(focus)*(length(ROC)+1)*length(Slice);
count = 0;

data = struct();
for a = 1:length(n_elements_x)
    n_elements_x_i = n_elements_x(a);
for b = 1:length(n_elements_y)
    n_elements_y_i = n_elements_y(b);
        
for f = 1:length(focus)
    focus_i = focus(f);
for roc = 1:length(ROC)
    ROC_i = ROC(roc);
for w = 1:length(element_W_x)
    W_i = element_W_x(w);
    P = W_i+0.2;
    n_elementsx = floor(ROC_i*3.14/P);
    AngleOfExtent = P*n_elementsx/ROC_i;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    H_i = element_W_y(y);
for sl =1:length(Slice)
    slice_i=Slice{sl};
R_focus = [ROC_i, 1e14];
for kk = 1:2
    R_focus_i =R_focus(kk);

    disp('-----------------------------------------')
    disp(strcat('      ',num2str(count),' of ', num2str(total)));
    count = count +1;
    
[txfeilddb, xdc_data] = human_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
[W_i H_i],[focus_i,0,-ROC_i],'element_geometry','focused2','R_focus',R_focus_i,...,
'Slice',slice_i, 'visualize_output',false);

s = struct();
s.M = 1.0; s.NX = n_elements_x_i; s.NY =n_elements_y_i; s.ROC = ROC_i; s.W = W_i; s.H = H_i;
s.F = focus_i; s.Slice = slice_i; s.Ro = R_focus_i; 

fname = fieldname_from_params(s);
% Save field
data.(fname) = txfeilddb;
% save the transducer geometry
data.(strcat('G_',fname(1:end-8))) = xdc_data;

end
end
end
end
end
end
end
end
save(outfile, '-struct', 'data');
end
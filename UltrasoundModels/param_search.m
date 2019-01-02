function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = './param_search_focus2.mat';
n_elements_x = [64];
n_elements_y = [1,2,3,4];
element_W_x = [1.0,1.5,2.0,2.5,3.0,3.5,4];
element_W_y = [6,10,15,20];
focus = [0,25,30,35,40];
ROC = [120 160];
Slice = {'xy','xz','yz'};
total = length(n_elements_y)*length(element_W_x)*length(element_W_y)*length(focus)*length(ROC)*length(Slice);
count = 0;
M = 2;
data = struct();
for a = 1:length(n_elements_x)
    n_elements_x_i = n_elements_x(a);
for b = 1:length(n_elements_y)
    n_elements_y_i = n_elements_y(b);
for f = 1:length(focus)
    focus_i = focus(f);
for roc = 1:length(ROC)
    ROC_i = ROC(roc);
    R_focus_i = 1e15;
for w = 1:length(element_W_x)
    W_i = element_W_x(w);
    P = W_i+0.4;
    n_elementsx = floor(ROC_i*3.14/P);
    AngleOfExtent = P*n_elementsx/ROC_i;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    H_i = element_W_y(y);
for sl =1:length(Slice)
    slice_i=Slice{sl};

    disp('-----------------------------------------')
    disp(strcat('      ',num2str(count),' of ', num2str(total)));
    count = count +1;
if M == 1    
    [txfeilddb, xdc_data] = human_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
    [W_i H_i],[focus_i,0,-ROC_i],'element_geometry','focused2','R_focus',R_focus_i,...,
    'Slice',slice_i, 'visualize_output',false);
else
    R_focus_i = 1e15;
    [txfeilddb, xdc_data] = concave_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
    [W_i H_i],[focus_i,0,ROC_i],'element_geometry','focused2','Slice',slice_i);
end
s = struct();
s.M = 1.0; s.NX = n_elements_x_i; s.NY =n_elements_y_i; s.ROC = ROC_i; s.W = W_i; s.H = H_i;
s.F = focus_i; s.Slice = slice_i; s.Ro = R_focus_i; 

fname = fieldname_from_params(s);
% Save field
data.(fname) = txfeilddb;
% save the transducer geometry
data.(strcat('G_',fname(1:end-8))) = xdc_data;

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
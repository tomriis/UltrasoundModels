function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = './param_search_fine.mat';
n_elements_x = [64];
n_elements_y = [1,2,3,4];
%n_elements_x, n_elements_y, ROC_x, kerf, D, R_focus, type

element_W_x = [1.0,1.5,2.0,2.5,3.0,3.5,4];
element_W_y = [10,20];
focus = [0,30,35,40,45];
ROC = [120, 160];
elGeo = {'focused2'};
Slice = {'xy','xz','yz'};
total = length(element_W_x)*length(element_W_y)*length(focus)*length(ROC)*length(elGeo)*length(Slice);
count = 0;
Ny = 8;
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
    P = W_i+kerf;
    n_elementsx = floor(ROCx*3.14/P);
    AngleOfExtent = P*n_elementsx/ROCx;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    Y_i = element_W_y(y);
for e = 1:length(elGeo)
    elGeo_i = elGeo{e};
for s =1:length(Slice)
    slice_i=Slice{s};
    R_focus_i = ROC_i;

[txfeilddb, xdc_data] = human_array_simulation(n_elements_x_i, n_elements_y_i,ROC_i,...,
[W_i Y_i],[focus_i,0,-ROC_i],'element_geometry','focused2','R_focus',R_focus_i,...,
'Slice',slice_i, 'visualize_output',false);

fname = fieldname_from_params(n_elements_x_i,n_elements_y_i, ROC_i, W_i, Y_i, focusx,P,R_focusx,e,slicex);
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
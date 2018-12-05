function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = './param_search_fine.mat';
%n_elements = [64,96,128,192]; 
element_W_x = [1.0,1.5,2.0,2.5,3.0,3.5,4];
element_W_y = [60,80,100];
focus = [0,30,35,40,45];
ROC = [120, 160];
elGeo = {'flat','focused'};
Slice = {'xy','xz','yz'};

data = struct();
for f = 1:length(focus)
    focusx = focus(f);
for roc = 1:length(ROC)
    ROCx = ROC(roc);
for w = 1:length(element_W_x)
    element_Wx = element_W_x(w);
    P = element_Wx+0.15;
    n_elementsx = floor(ROCx*3.14/P);
    AngleOfExtent = P*n_elementsx/ROCx;
    if AngleOfExtent > pi
        continue;
    end
    
for y = 1:length(element_W_y)
    element_Wy = element_W_y(y);
for e = 1:length(elGeo)
    elGeox = elGeo{e};
    if strcmp(elGeox, 'focused')
        Nx = 1;
    else
        Nx = 6;
    end
for s =1:length(Slice)
    slicex=Slice{s};
    R_focusx = ROCx;
 
[txfeilddb, xdc_data] = human_array_simulation(n_elementsx,ROCx,[element_Wx,element_Wy],[focusx,0,-ROCx],...,
    'P', P,'Nx',Nx,'Ny',8, 'R_focus',R_focusx,'element_geometry',elGeox,'Slice',slicex,...,
    'visualize_transducer',false,'visualize_output',false);

fname = fieldname_from_params(n_elementsx,ROCx, element_Wx, element_Wy, focusx,P,R_focusx,e,slicex);
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
save(outfile, '-struct', 'data');
end
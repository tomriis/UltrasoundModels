function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = "./param_search_spherical.mat";
n_elements = [64,96,128,192,256]; 
element_W_x = [1.0,2.0,3.0,4.0,5.0];
element_W_y = [20,40,60,80];
focus = [25,35,45];
ROC = [80,120,160];

data = struct();
for f = 1:length(focus)
    focusx = focus(f);
for roc = 1:length(ROC)
    ROCx = ROC(roc);
for n = 1:length(n_elements)
    n_elementsx = n_elements(n);
for w = 1:length(element_W_x)
    element_Wx = element_W_x(w);
    P = element_Wx+0.15;
    AngleOfExtent = P*n_elementsx/ROCx;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    element_Wy = element_W_y(y);

    R_focusx = ROCx;

    
 
txfeilddb = human_array_simulation(n_elementsx,ROCx,[element_Wx,element_Wy],[focusx,0,-ROCx],'P', P,...
   'Nx',6,'Ny',8, 'R_focus',R_focusx,'element_geometry','spherical','visualize_transducer',false,'visualize_output',false);

fname = fieldname_from_params(n_elementsx,ROCx, element_Wx, element_Wy, focusx,P,R_focusx,3);

data.(fname) = txfeilddb;

end
end
end
end
end
save(outfile, '-struct', 'data');
end
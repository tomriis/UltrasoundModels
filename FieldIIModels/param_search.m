function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = "./param_search_focused.mat";
n_elements = [32,48,64]; 
element_W_x = [2.0,2.3,3.0,3.9,5.0];
element_W_y = [4,6,8];
focus = [25,35,45];
ROC = [80,90,100];
R_focus = [80,90,100];
data = struct();
for f = 1:length(focus)
    focusx = focus(f);
for roc = 1:length(ROC)
    ROCx = ROC(roc);
for n = 1:length(n_elements)
    n_elementsx = n_elements(n);
for w = 1:length(element_W_x)
    element_Wx = element_W_x(w);
    P = 1.025*element_Wx;
    AngleOfExtent = P*n_elementsx/ROCx;
    if AngleOfExtent > pi
        continue;
    end
for y = 1:length(element_W_y)
    element_Wy = element_W_y(y);
for ro = 1:length(R_focus)
    R_focusx = R_focus(ro);

    
 
txfeilddb = human_array_simulation(n_elementsx,ROCx,[element_Wx,element_Wy],[focusx,0,-ROCx],'P', P,...
   'Nx',2,'Ny',5, 'R_focus',R_focusx,'element_geometry','focused','visualize_transducer',false,'visualize_output',false);

fname = fieldname_from_params(n_elementsx,ROCx, element_Wx, element_Wy, focusx,P);

data.(fname) = txfeilddb;
end
end
end
end
end
end
save(outfile, '-struct', 'data');
end
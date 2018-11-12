function [data] = param_search()
% Define parameters and ranges for simulation to search through
outfile = "./param_search.mat";
n_elements = [32,48,64]; 
element_W_x = [2.0,2.3,3.0,3.9,5.0];
element_W_y = [4,6,8];
focus = [20,30,40];
ROC = [80,90,100];
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
    
 
txfeilddb = human_array_simulation(n_elementsx,ROCx,[element_Wx,element_Wy],[focusx,0,-ROCx],'P', P,'element_geometry','flat','R_focus',1);
runstring = strcat('N',num2str(n_elementsx),'ROC',num2str(ROCx),'X',num2str(element_Wx),...
'Y',num2str(element_Wy),'F',num2str(focusx),'P',num2str(P));
data.(runstring) = txfeilddb;

end
end
end
end
end
save(outfile, '-struct', 'data');
end
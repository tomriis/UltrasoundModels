D = [4 80];
ROC = 160;
focus = [0,0,-ROC];
P = D(1)+0.15;
Ny = 6;
el_geo = {'linear'};
geom = struct();
for i = 1:length(el_geo)
    [txfeilddb, xdc_d] = human_array_simulation(2,ROC,D,focus,...,
    'P', P,'Nx',1,'Ny',3, 'R_focus',ROC*1e13,'element_geometry',el_geo{i},'Slice','xy',...,
    'visualize_transducer',false,'visualize_output',true);
    geom.(el_geo{i}) = xdc_d;
    geom.(strcat(el_geo{i},'_t')) = txfeilddb;
    
    show_transducer('data',xdc_d);
    
end
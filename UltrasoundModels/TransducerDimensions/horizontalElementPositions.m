
a = 115/1000;
b = 95/1000;
D = [6,6]/1000;
kerf= 4.5/1000;
n_elements_r = 43;
n_elements_z = 6;
R_focus = a;

field_init(-1)
[Th] = horizontal_array(n_elements_r, n_elements_z, kerf, D, R_focus,a,b);
rect = xdc_pointer_to_rect(Th);
show_transducer('Th',Th);
set(gca,'fontSize',11)

set(gcf,'color','w')
field_end();
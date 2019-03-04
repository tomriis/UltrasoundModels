function [rect] = kwave_focused_array(n_r, n_y,kerf, D, R_focus,a,b,type)
    field_init(-1)
    if strcmp(type,'horizontal')
        [Th] = horizontal_array(n_r, n_y, kerf, D, R_focus,a,b);
    else
        [Th] = concave_focused_array(n_r, n_y, a, kerf, D, R_focus);
    end
    rect = xdc_pointer_to_rect(Th);
    show_transducer('Th',Th);
    field_end();
 
end
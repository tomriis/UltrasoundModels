function [mask] = kwave_focused_array(kgrid, n_r, n_y,kerf, D, R_focus,a,b,Ang_Extent)%n_elements_x, n_elements_y, ROC_x,ROC_y, D, kerf)
    % define a square source element
    field_init(-1)
    [Th] = horizontal_array(n_r, n_y, kerf, D, R_focus,a,b, Ang_Extent);
    rect = xdc_pointer_to_rect(Th);
    field_end();
    
    mask = rect_to_mask(kgrid, rect);
    
end
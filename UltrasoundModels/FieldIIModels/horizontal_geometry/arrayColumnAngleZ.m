function angle_z = arrayColumnAngleZ(R_focus, kerf,D,n_elements_z,n_elements_above)
    n_elements_below = n_elements_z-n_elements_above;
    len_z = (D(2)+kerf)*n_elements_z;
    AngExtent_z = len_z/ R_focus;
    angle_inc_z = AngExtent_z/n_elements_z;
    index_z = -1*(-(n_elements_below)+0.5:(n_elements_above)-0.5);
    angle_z = index_z* angle_inc_z;
%     angle_z(1:n_elements_below)=0;
end
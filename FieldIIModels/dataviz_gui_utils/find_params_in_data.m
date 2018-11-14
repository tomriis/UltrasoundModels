function [handles] = find_params_in_data(handles)
    fname = fieldname_from_params(handles.current_params);
    try 
        handles.txfielddb = handles.data.(fname);
        handles.plot_flag = true;
    catch
        % Check if angle of extent is too large, if so dont plot
        
        % Check if 
    end
end
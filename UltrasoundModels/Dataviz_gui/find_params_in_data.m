function [handles] = find_params_in_data(handles)
    fname = fieldname_from_params(handles.current_params);
    try 
        handles = txfield_to_db(handles,fname);
        handles.plot_flag = true;
        set(handles.text10, 'String', '');
        k_Ro = strfind(fname, 'Ro');
        k_Slice = strfind(fname,'Slice');
        caption = sprintf('R Focus: %s (mm)', fname(k_Ro+2:k_Slice-1));
        set(handles.text8,'String',caption);
        set(handles.textMaxPressure, 'String',sprintf('Max Pressure: %d',handles.maxtxfield));
    catch e
        % Check if angle of extent is too large, if so dont plot
        disp(e.message);
        str = sprintf('Current parameters not in %s \n \n',handles.filename);
        set(handles.text10,'String',str);
        handles.plot_flag = false;
    end
end
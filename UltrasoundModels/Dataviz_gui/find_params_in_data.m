function [handles] = find_params_in_data(handles)
    fname = fieldname_from_params(handles.current_params);
    %disp(fname)
    try 
        handles = find_params_in_data_helper(fname,handles);
    catch e
        % Check if angle of extent is too large, if so dont plot
        try
            fname = strcat('M1',fname);
            disp(fname);
            handles = find_params_in_data_helper(fname,handles);
        catch
            str = sprintf('Current parameters not in %s \n \n',handles.filename);
            set(handles.text10,'String',str);
            handles.plot_flag = false;
        end

    end
end

function handles=find_params_in_data_helper(fname, handles)
    handles = txfield_to_db(handles,fname);
    handles.plot_flag = true;
    set(handles.text10, 'String', '');
    k_Ro = strfind(fname, 'Ro');
    k_Slice = strfind(fname,'Slice');
    k_K = strfind(fname,'K');
    caption = sprintf('R Focus: %s (mm)', fname(k_Ro+2:k_K-1));
    set(handles.text8,'String',caption);
    set(handles.textMaxPressure, 'String',sprintf('Max Pressure: %d',handles.maxtxfield));
end
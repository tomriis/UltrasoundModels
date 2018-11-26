function [handles] = find_params_in_data(handles)
    fname = fieldname_from_params(handles.current_params);
    try 
        handles.txfielddb = txfield_to_db(handles,fname);
        handles.plot_flag = true;
        set(handles.text10, 'String', "");
    catch
        % Check if angle of extent is too large, if so dont plot
        str = sprintf("Current parameters not in %s \n \n",handles.filename);
        AngleOfExtent = handles.current_params.P * handles.current_params.N/handles.current_params.ROC;
        if AngleOfExtent > pi
            str=strcat(str, " Angle of Extent: ",...
                num2str(AngleOfExtent)," > 3.14 rad");
        end
        set(handles.text10,'String',str);
        handles.plot_flag = false;
        % Check if 
    end
end
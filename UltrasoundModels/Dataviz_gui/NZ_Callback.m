function [handles] = NZ_Callback(handles)
    value = handles.parameters.NZ(int16(get(handles.sliderNZ,'Value')));
    caption = sprintf('NY: %d', value);
    set(handles.text7, 'String', caption);
    handles.current_params.NZ = value;
    if handles.NX_NY_coupled
        handles.current_params.NR = find_NR_from_geo(handles.current_params.T,...,
            handles.current_params.NZ,handles.current_params.A,...,
            handles.current_params.B, handles.current_params.H);
        
        caption = sprintf('NR: %d', handles.current_params.NR);
        set(handles.text2, 'String', caption);
    end
    handles = find_params_in_data(handles);
end
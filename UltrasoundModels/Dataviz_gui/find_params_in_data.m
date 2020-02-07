function [handles] = find_params_in_data(handles)
    index = findMatchedParameters(handles.data, handles.current_params);
    handles = txfield_to_db(handles, index);
    handles.plot_flag = true;
end

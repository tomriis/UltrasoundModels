function handles = extent_equals_pi_callback(handles)
        try
            n_elements = floor(handles.current_params.ROC*3.14/handles.current_params.P);
        catch
            n_elements = handles.current_params.N;
        end
        caption = sprintf('N Elements: %d', n_elements);
        set(handles.text2,'String',caption);
        handles.current_params.N = n_elements;
end
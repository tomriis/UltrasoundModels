function [handles]=width_pitch_callback(hObject,handles)
    index = int16(get(hObject,'Value'));
    valueX = handles.parameters.X(index);
    valueP = handles.parameters.P(index);
    captionX = sprintf('X: %.2f (mm)', valueX);
    captionP = sprintf('P: %.2f (mm)', valueP);
    set(handles.text4, 'String', captionX);
    set(handles.text7, 'String', captionP);
    set(handles.slider3,'Value', index);
    set(handles.slider6,'Value', index);
    handles.current_params.X = valueX;
    handles.current_params.P = valueP;
    if handles.n_equals_pi
        n_elements = floor(handles.current_params.ROC*3.14/handles.current_params.P);
        caption = sprintf('N Elements: %d', n_elements);
        set(handles.text2,'String',caption);
        handles.current_params.N = n_elements;
    end
end
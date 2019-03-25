function [handles] = semiminor_callback(handles)
    Semi_Minor_Axis_Ratio = [135/170 1];
    slider_val = int16(get(handles.sliderB,'Value'));
    value = Semi_Minor_Axis_Ratio(slider_val)*handles.current_params.A;
    caption = sprintf('Minor Axis: %.2f (mm)', value);
    set(handles.textMinorAxis, 'String', caption);
    handles.current_params.B = value;
    handles = NY_Callback(handles);
end
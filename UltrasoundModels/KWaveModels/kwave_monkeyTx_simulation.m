function [sensor_data, source, kgrid] = kwave_monkeyTx_simulation(varargin) 
    p = inputParser;
    addRequired(p,'corners');
    addRequired(p,'focus');
    addOptional(p, 'Dimensions',3);
    addOptional(p,'plane','xy');
    parse(p, varargin{:})
    
    focus = p.Results.focus;
    Dimensions = p.Results.Dimensions;
    plane = p.Results.plane;
    
    M = makexrotform(pi);
    
    rect = corners_to_rect(p.Results.corners);
    
    rect = apply_affine_to_rect(M, rect);
    rect = rect/1000; % Convert from mm to meters
    show_transducer('data',rect);
    
    [sensor_data, source, kgrid] = kwave_simulation(rect, Dimensions, focus, plane);
    
end
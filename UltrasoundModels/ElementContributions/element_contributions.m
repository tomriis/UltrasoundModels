function [contributions, rect] = element_contributions(varargin)
    p = inputParser;
    addRequired(p,'n_elements_r', @(x) isnumeric(x));
    addRequired(p,'n_elements_y', @(x) isnumeric(x));
    addRequired(p,'a', @(x) isnumeric(x));
    addRequired(p,'b', @(x) isnumeric(x));
    addRequired(p,'D');
    addRequired(p, 'focal_point');
    addOptional(p, 'Dim',2);
    addOptional(p,'type','horizontal');
    addOptional(p, 'kerf',0.4);
    addOptional(p, 'R_focus', 1e4, @(x) isnumeric(x));
    addOptional(p,'Slice','xy');
    parse(p, varargin{:})
    
    Dimensions = p.Results.Dim;
    % Define excitation
    magnitude = 0.5; %[Pa]
    fo = 650e3;
    fs=20*fo;
    c = 1540; % Speed of sound in water
    % Define the source
    a = p.Results.a/1000; %m
    b = p.Results.b/1000;
    n_elements_r = p.Results.n_elements_r;  %number of physical elements in X.
    n_elements_y = p.Results.n_elements_y;  %number of physical elements in Y.
    kerf = p.Results.kerf/1000;
    D = p.Results.D/1000; %Diameter, width, and length of element (m)
    R_focus = p.Results.R_focus/1000;
    type = p.Results.type;
    focus = p.Results.focal_point/1000; %(m)
    slice = p.Results.Slice;
    
    [rect]= kwave_focused_array(n_elements_r,n_elements_y, kerf,...,
        D, R_focus, a, b,type);
    
    
    lambda = c/fo;
    contributions = calculate_contributions(rect,focus, lambda);
        
    
    
    
end
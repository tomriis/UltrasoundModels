function [params] = fieldname_to_param(fieldname)
    % Take in fieldname string and return structure of params with
    % numerical values

    params = struct();
    k_ElGeo = strfind(fieldname,'ElGeo');
    k_NR = strfind(fieldname,'NR');
    k_NZ = strfind(fieldname,'NZ');
    k_A = strfind(fieldname,'A');
    k_B = strfind(fieldname,'B');
    k_W = strfind(fieldname,'W');
    k_H = strfind(fieldname,'H');
    k_F = strfind(fieldname,'F');
    k_Ro = strfind(fieldname,'Ro');
    k_Slice = strfind(fieldname,'Slice_');
    
    params.NR = str2double(fieldname(k_NR+2:k_NZ-1));
    params.NZ = str2double(fieldname(k_NZ+2:k_A-1));
    params.A = str2double(fieldname(k_A+1:k_B-1));
    params.B = str2double(fieldname(k_B+1:k_W-1));
    if params.A ~=params.B
        params.B = 135/170*params.B;
        if params.B
    end
    params.W = get_param_decimal(fieldname, k_W+1,k_H-1);
    params.H = str2double(fieldname(k_H+1:k_Ro-1));
    
    params.Ro = str2double(fieldname(k_Ro+2:k_Slice-1));
    params.F = get_focus_from_string(fieldname(k_F+1:end));
    
    if isempty(k_Slice)
        params.Slice = 'xy';
        params.Ro = str2double(fieldname(k_Ro+2:end));
    else
        params.Slice = fieldname(k_Slice+6:k_Slice+7);
    end        
end

function [focus] = get_focus_from_string(fstring);
    inds = strfind(fstring,'_');
    
    focus=[];
    focus(1)=str2double(fstring(1:inds(1)-1));
    focus(2) = str2double(fstring(inds(1)+1:inds(2)-1));
    focus(3) = str2double(fstring(inds(2)+1:end));
end

function [par] = get_param_decimal(fieldname, k_start, endpoint)
    try
        par = str2double(strcat(fieldname(k_start),'.',fieldname(k_start+1:endpoint)));
    catch
        par =str2double(fieldname(k_start));
    end
end
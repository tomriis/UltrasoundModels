function [params] = fieldname_to_param(fieldname)
    % Take in fieldname string and return structure of params with
    % numerical values

    params = struct();
    k_ElGeo = strfind(fieldname,'ElGeo');
    k_NR = strfind(fieldname,'NR');
    k_NZ = strfind(fieldname,'NZ');
    k_NY = strfind(fieldname,'NY');
    k_A = strfind(fieldname,'A');
    k_B = strfind(fieldname,'B');
    k_W = strfind(fieldname,'W');
    k_H = strfind(fieldname,'H');
    k_F = strfind(fieldname,'F');
    k_Ro = strfind(fieldname,'Ro');
    k_Slice = strfind(fieldname,'Slice_');
    k_T = strfind(fieldname,'T');
    if ~isempty(k_NZ) && isempty(k_NY)
        k_NY = k_NZ;
    end
    params.ElGeo = str2double(fieldname(k_ElGeo+5));
    params.NR = str2double(fieldname(k_NR+2:k_NY-1));
    params.NY = str2double(fieldname(k_NY+2:k_A-1));
    params.A = str2double(fieldname(k_A+1:k_B-1));
    params.B = str2double(fieldname(k_B+1:k_W-1));
    if params.A ~=params.B
        params.B = 135/170*params.A;
        strnum=fieldname(k_B+1:k_W-1);
        b_test1 = str2double(strcat(strnum(1:2),'.',strnum(2:end)));
        b_test2 = str2double(strcat(strnum(1:3),'.',strnum(2:end)));
        if params.B - b_test1 > 1 && params.B - b_test2 > 1
            warning('Likely not the correct B value in fieldname_to_param');
        end
    end
    params.W = get_param_decimal(fieldname, k_W+1,k_H-1);
    params.H = str2double(fieldname(k_H+1:k_Ro-1));
    
    params.Ro = str2double(fieldname(k_Ro+2:k_Slice-1));
    focus = get_focus_from_string(fieldname(k_F+1:k_T-1));
    params.FX = focus(1); params.FY = focus(2); params.FZ = focus(3);
    
    if isempty(k_Slice)
        params.Slice = 'xy';
        params.Ro = str2double(fieldname(k_Ro+2:end));
    else
        params.Slice = fieldname(k_Slice+6:k_Slice+7);
    end  
    params.T = str2double(fieldname(k_T+1:end));
end

function [focus] = get_focus_from_string(fstring)
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
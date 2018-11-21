function [params] = fieldname_to_param(fieldname)
    % Take in fieldname string and return structure of params with
    % numerical values
    params = struct();
    k_ElGeo = strfind(fieldname,'ElGeo');
    k_N = strfind(fieldname,'N');
    k_ROC = strfind(fieldname,'ROC');
    k_X = strfind(fieldname,'X');
    k_Y = strfind(fieldname,'Y');
    k_F = strfind(fieldname,'F');
    k_P = strfind(fieldname,'P');
    k_Ro = strfind(fieldname,'Ro');
    k_Slice = strfind(fieldname,'Slice_');
    params.N = str2double(fieldname(k_N+1:k_ROC-1));
    params.ROC = str2double(fieldname(k_ROC+3:k_X-1));
    params.X = get_param_decimal(fieldname, k_X+1,k_Y-1);
    
    params.Y = str2double(fieldname(k_Y+1:k_F-1));
    params.F = str2double(fieldname(k_F+1:k_P-1));
    
    % Handle the optional ElGeo and Ro
    if isempty(k_ElGeo)
        params.ElGeo = 1;
    else
        params.ElGeo = str2double(fieldname(k_ElGeo+5:k_N-1));
    end
    if isempty(k_Ro)
        params.P = get_param_decimal(fieldname, k_P+1,length(fieldname));
        params.Ro = inf;
    else
        params.P = get_param_decimal(fieldname, k_P+1,k_Ro-1);
        params.Ro = str2double(fieldname(k_Ro+2:end));
    end
end


function [par] = get_param_decimal(fieldname, k_start, endpoint)
    try
        par = str2double(strcat(fieldname(k_start),'.',fieldname(k_start+1:endpoint)));
    catch
        par =str2double(fieldname(k_start));
    end
end
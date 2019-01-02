function [params] = fieldname_to_param(fieldname)
    % Take in fieldname string and return structure of params with
    % numerical values

    params = struct();
    k_M = strfind(fieldname,'M');
    k_ElGeo = strfind(fieldname,'ElGeo');
    k_NX = strfind(fieldname,'NX');
    k_NY = strfind(fieldname,'NY');
    k_ROC = strfind(fieldname,'ROC');
    k_W = strfind(fieldname,'W');
    k_H = strfind(fieldname,'H');
    k_F = strfind(fieldname,'F');
    k_Ro = strfind(fieldname,'Ro');
    k_Slice = strfind(fieldname,'Slice_');
    params.M = str2double(fieldname(k_M+1:k_ElGeo-1));
    params.NX = str2double(fieldname(k_NX+2:k_NY-1));
    params.NY = str2double(fieldname(k_NY+2:k_ROC-1));
    params.ROC = str2double(fieldname(k_ROC+3:k_W-1));
    params.W = get_param_decimal(fieldname, k_W+1,k_H-1);
    
    params.H = str2double(fieldname(k_H+1:k_F-1));
    params.F = str2double(fieldname(k_F+1:k_Ro-1));
    params.Ro = str2double(fieldname(k_Ro+2:k_Slice-1));
    
    % Handle the optional ElGeo and Ro and Slice
    if isempty(k_ElGeo)
        params.ElGeo = 1;
    else
        params.ElGeo = str2double(fieldname(k_ElGeo+5:k_NX-1));
    end
    if isempty(k_Slice)
        params.Slice = 'xy';
        params.Ro = str2double(fieldname(k_Ro+2:end));
    else
        params.Slice = fieldname(k_Slice+6:k_Slice+7);
    end
end


function [par] = get_param_decimal(fieldname, k_start, endpoint)
    try
        par = str2double(strcat(fieldname(k_start),'.',fieldname(k_start+1:endpoint)));
    catch
        par =str2double(fieldname(k_start));
    end
end
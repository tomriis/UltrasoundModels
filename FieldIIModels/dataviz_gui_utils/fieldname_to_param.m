function [params] = fieldname_to_param(fieldname)
    % Take in fieldname string and return structure of params with
    % numerical values
    params = struct();
    k_N = strfind(fieldname,'N');
    k_ROC = strfind(fieldname,'ROC');
    k_X = strfind(fieldname,'X');
    k_Y = strfind(fieldname,'Y');
    k_F = strfind(fieldname,'F');
    k_P = strfind(fieldname,'P');
    params.N = str2double(fieldname(k_N+1:k_ROC-1));
    params.ROC = str2double(fieldname(k_ROC+3:k_X-1));
    params.X = str2double(fieldname(k_X+1:k_Y-1));
    params.Y = str2double(fieldname(k_Y+1:k_F-1));
    params.F = str2double(fieldname(k_F+1:k_P-1));
    try
        params.P = str2double(strcat(fieldname(k_P+1),'.',fieldname(k_P+2:end)));
    catch
        params.P=str2double(fieldname(k_P+1));
    end
end


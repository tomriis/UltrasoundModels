function [data] = unique_vals_from_mat(Matfile)
% Returns array of fieldname strings from the loaded matfile
    data = struct('N',[],'ROC',[],'X',[],'Y',[],'F',[],'P',[],'ElGeo',[],'Ro',[]);
    data.Slice={};
    fields_cell = fieldnames(Matfile);
    count = 1;
    for i = 1:length(fields_cell)
        f = fields_cell(i);
        field_string = f{:};
        if ~strcmp(field_string,'Properties')
            params = fieldname_to_param(field_string);
            data.N(count) = params.N;
            data.ROC(count) = params.ROC;
            data.X(count) = params.X;
            data.Y(count) = params.Y;
            data.F(count) = params.F;
            data.P(count) = params.P;
            data.ElGeo(count) = params.ElGeo;
            data.Ro(count) = params.Ro;
            data.Slice(count) = {params.Slice};
            
            count= count +1;
        end
    end
    fields = fieldnames(data);
    for i=1:numel(fields)
        data.(fields{i}) = unique(data.(fields{i}));
    end
    
end


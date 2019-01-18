function [data] = unique_vals_from_mat(Matfile)
% Returns array of fieldname strings from the loaded matfile
    data = struct('M',[],'NX',[],'NY',[],'ROC',[],'W',[],'H',[],'F',[],...,
        'ElGeo',[],'Ro',[],'Q',[],'Z',[]);
    data.Slice={};
    fields_cell = fieldnames(Matfile);
    count = 1;
    for i = 1:length(fields_cell)
        f = fields_cell(i);
        field_string = f{:};
        if ~strcmp(field_string,'Properties')
            params = fieldname_to_param(field_string);
            data.M(count) = params.M;
            data.NX(count) = params.NX;
            data.NY(count) = params.NY;
            data.ROC(count) = params.ROC;
            data.W(count) = params.W;
            data.H(count) = params.H;
            data.F(count) = params.F;
            data.ElGeo(count) = params.ElGeo;
            data.Ro(count) = params.Ro;
            data.Slice(count) = {params.Slice};
            data.Q(count) = params.Q;
            data.Z(count) = params.Z;
            count= count +1;
        end
    end
    fields = fieldnames(data);
    for i=1:numel(fields)
        data.(fields{i}) = unique(data.(fields{i}));
    end
end


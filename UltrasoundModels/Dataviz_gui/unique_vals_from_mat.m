function [data] = unique_vals_from_mat(Matfile)
% Returns array of fieldname strings from the loaded matfile
    data = struct('NR',[],'NY',[],'A',[],'B',[],'W',[],'H',[],...,
        'ElGeo',[],'Ro',[],'FX',[],'FY',[],'FZ',[],'T',[]);
    data.Slice={};
    fields_cell = fieldnames(Matfile);
    count = 1;
    for i = 1:length(fields_cell)
        f = fields_cell(i);
        field_string = f{:};
        if ~strcmp(field_string,'Properties') && strcmp(field_string(1),'E')
            params = fieldname_to_param(field_string);
            data.ElGeo(count) = params.ElGeo;
            data.NR(count) = params.NR;
            data.NY(count) = params.NY;
            data.A(count) = params.A;
            data.B(count) = params.B;
            data.W(count) = params.W;
            data.H(count) = params.H;
            data.FX(count) = params.FX;
            data.FY(count) = params.FY;
            data.FZ(count) = params.FZ;
            data.Ro(count) = params.Ro;
            data.T(count) = params.T;
            data.Slice(count) = {params.Slice};
            count= count +1;
        end
    end
    fields = fieldnames(data);
    for i=1:numel(fields)
        data.(fields{i}) = unique(data.(fields{i}));
    end
end


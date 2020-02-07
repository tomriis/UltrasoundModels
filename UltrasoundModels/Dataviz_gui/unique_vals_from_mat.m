function [param_data] = unique_vals_from_mat(data)
% Returns array of fieldname strings from the loaded matfile
    param_data = struct('NR',[],'NY',[],'A',[],'B',[],'W',[],'H',[],...,
        'Ro',[],'FX',[],'FY',[],'FZ',[],'K',[]);

    count = 1;
    for i = 1:length(data)
        param_data.NR(count) = data(i).NR;
        param_data.NY(count) = data(i).NZ;
        param_data.A(count) = data(i).A;
        param_data.B(count) = data(i).B;
        param_data.W(count) = data(i).D(1);
        param_data.H(count) = data(i).D(2);
        param_data.Ro(count) = data(i).R_focus;
        param_data.K(count) = data(i).kerf;
        param_data.FX(count) = data(i).focus(1);
        param_data.FY(count) = data(i).focus(2);
        param_data.FZ(count) = data(i).focus(3);
        count = count + 1;
    end
    fields = fieldnames(param_data);
    for i=1:numel(fields)
        param_data.(fields{i}) = unique(param_data.(fields{i}));
    end
    param_data.Slice = {'xy','xz','yz'};
end


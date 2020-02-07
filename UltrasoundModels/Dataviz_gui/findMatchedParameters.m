function [max_i] = findMatchedParameters(data, current_params)
    matches = [];
    for i = 1:length(data)
        match = 0;
        if current_params.NR == data(i).NR
            match=match+1;
        end
        if current_params.NY == data(i).NZ
            match=match+1;
        end
        if current_params.A == data(i).A
            match=match+1;
        end
        if current_params.B == data(i).B
            match=match+1;
        end
        if current_params.W == data(i).D(1)
            match=match+1;
        end
        if current_params.H == data(i).D(2)
            match=match+1;
        end
        if current_params.Ro == data(i).R_focus
            match=match+1;
        end
        if current_params.K == data(i).kerf
            match=match+1;
        end
        if current_params.FX == data(i).focus(1)
            match=match+1;
        end
        if current_params.FY == data(i).focus(2)
            match=match+1;
        end
        if current_params.FZ == data(i).focus(3)
            match=match+1;
        end
        if strcmp(current_params.Slice, data(i).slice)
            match = match+1;
        end
        matches(i) = match;
    end
    [~, max_i] = max(matches);
end
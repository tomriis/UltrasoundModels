function [fieldname]=fieldname_from_params(s)

n_r = s.NR; n_z=s.NZ; A = s.A; B = s.B; 
slice = s.Slice; R_focus = s.Ro; ElGeo = s.ElGeo;

try
    focus = s.F;
catch
    if ~isempty(s.FX) && ~isempty(s.FY) && ~isempty(s.FZ)
        focus(1) = s.FX;
        focus(2) = s.FY;
        focus(3) = s.FZ;
    else
        focus = zeros(1,3);
    end
end
try
    D = s.D;
catch
    if ~isempty(s.H) && ~isempty(s.W)
        D(1) = s.H;
        D(2) = s.W;
    else
        D = zeros(1,2);
    end
end

%returns txt field from params
    runstring = strcat('ElGeo',num2str(ElGeo),'NR',num2str(n_r),...,
        'NZ',num2str(n_z),'A',num2str(A),'B',num2str(B),'W',num2str(D(1)),...,
'H',num2str(D(2)),'Ro',num2str(R_focus),'Slice_',slice,'F',...,
strcat(num2str(focus(1)),'_',num2str(focus(2)),'_',num2str(focus(3))));

    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
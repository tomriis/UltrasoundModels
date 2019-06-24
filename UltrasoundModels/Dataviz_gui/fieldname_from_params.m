function [fieldname]=fieldname_from_params(s)

n_r = s.NR; n_z=s.NY; A = s.A; B = s.B; 
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
if focus(2) < 0
    FY = strcat('_',num2str(abs(focus(2))));
else
    FY = num2str(focus(2));
end
if focus(3) < 0
    FZ = strcat('_',num2str(abs(focus(3))));
else
    FZ = num2str(focus(3));
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
try 
    T = s.T;
catch
    T = 256;
end
try 
    EX = s.EX;
catch
    EX = 'g';
end
try 
    SUM = s.SUM;
catch
    SUM = 'ms';
end
try 
    K = s.K;
catch
    K = 0.4;
end
if isempty(B)
    runstring = strcat('ElGeo',num2str(ElGeo),'NR',num2str(n_r),...,
        'NY',num2str(n_z),'A',num2str(A), 'W',num2str(D(2)),...,
'H',num2str(D(1)),'Ro',num2str(R_focus), 'K',num2str(K),'Slice_',slice,'F',...,
strcat(num2str(focus(1)),'_',num2str(focus(2)),'_',num2str(focus(3))),...,
'T',num2str(T));
else
    runstring = strcat('ElGeo',num2str(ElGeo),'NR',num2str(n_r),...,
        'NY',num2str(n_z),'A',num2str(A),'B',num2str(B),'W',num2str(D(2)),...,
'H',num2str(D(1)),'Ro',num2str(R_focus), 'K',num2str(K), 'Slice_',slice,'F',...,
strcat(num2str(focus(1)),'_',FY,'_',FZ),...,
'T',num2str(T),'EX',EX,'SUM',SUM);
end
    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
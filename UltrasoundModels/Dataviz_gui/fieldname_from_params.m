function [fieldname]=fieldname_from_params(s)

n_elements_x = s.NX; n_elements_y=s.NY; ROC = s.ROC; W = s.W; H = s.H;
focus = s.F; slice = s.Slice; R_focus = s.Ro; M = s.M; Z = s.Z;
try
    ElGeo = s.ElGeo;
catch
    ElGeo = 1;
end
try 
    Q = s.Q;
catch
    Q = 650;
end
if isempty(R_focus)
    if ElGeo == 1
        R_focus = inf;
    elseif ElGeo == 2
        R_focus = ROC;
    end
end
if Z < 0
    Z = strcat('_',num2str(abs(Z)));
else
    Z = num2str(Z);
end

%returns txt field from params

    runstring = strcat('M',num2str(M),'ElGeo',num2str(ElGeo),'NX',num2str(n_elements_x),...,
        'NY',num2str(n_elements_y),'ROC',num2str(ROC),'W',num2str(W),...
'H',num2str(H),'F',num2str(focus),'Ro',num2str(R_focus),'Slice_',slice,'Q',num2str(Q),...,
'Z',Z);

    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
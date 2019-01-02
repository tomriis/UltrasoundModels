function [fieldname]=fieldname_from_params(s)

n_elements_x = s.NX; n_elements_y=s.NY; ROC = s.ROC; W = s.W; H = s.H;
focus = s.F; slice = s.Slice; R_focus = s.Ro; M = s.M;
if R_focus > 10000
    R_focus = inf;
    ElGeo = 1;
else
    R_focus = ROC;
    ElGeo = 2;
end
%returns txt field from params

    runstring = strcat('M',num2str(M),'ElGeo',num2str(ElGeo),'NX',num2str(n_elements_x),...,
        'NY',num2str(n_elements_y),'ROC',num2str(ROC),'W',num2str(W),...
'H',num2str(H),'F',num2str(focus),'Ro',num2str(R_focus),'Slice_',slice);

    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
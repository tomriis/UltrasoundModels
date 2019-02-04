function [fieldname]=fieldname_from_params(s)

n_r = s.NR; n_z=s.NZ; A = s.A; B = s.B; D = s.D;
focus = s.F; slice = s.Slice; R_focus = s.Ro; ElGeo = s.ElGeo;

%returns txt field from params
    runstring = strcat('ElGeo',num2str(ElGeo),'NR',num2str(n_r),...,
        'NZ',num2str(n_z),'A',num2str(A),'B',num2str(B),'W',num2str(D(1)),...,
'H',num2str(D(2)),'Ro',num2str(R_focus),'Slice_',slice,'F',...,
strcat(num2str(focus(1)),'_',num2str(focus(2)),'_',num2str(focus(3))));

    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
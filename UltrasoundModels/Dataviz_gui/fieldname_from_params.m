function [fieldname]=fieldname_from_params(s)

n_elements_x=s.Nx; ROC=s.ROC; X=s.X; Y=s.Y; focus=s.F; P=s.P; 
ElGeo = s.ElGeo; R_focus = s.Ro; Slice=s.Slice;

%returns txt field from params

    runstring = strcat('ElGeo',num2str(ElGeo),'N',num2str(n_elements),'ROC',num2str(ROC),'X',num2str(X),...
'Y',num2str(Y),'F',num2str(focus),'P',num2str(P),'Ro',num2str(R_focus),'Slice_',Slice);

    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
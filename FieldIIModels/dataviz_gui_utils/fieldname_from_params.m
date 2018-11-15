function [fieldname]=fieldname_from_params(varargin)
if isstruct(varargin{1})
    s = varargin{1};
    n_elements=s.N; ROC=s.ROC; X=s.X; Y=s.Y; focus=s.F; P=s.P; 
    ElGeo = s.ElGeo; R_focus = s.Ro;
else
    n_elements=varargin{1}; ROC=varargin{2}; X=varargin{3}; Y=varargin{4}; 
    focus=varargin{5}; P=varargin{6};
end
%returns txt field from params
if ElGeo == 1
    runstring = strcat('N',num2str(n_elements),'ROC',num2str(ROC),'X',num2str(X),...
    'Y',num2str(Y),'F',num2str(focus),'P',num2str(P));
else
    runstring = strcat('ElGeo',num2str(ElGeo),'N',num2str(n_elements),'ROC',num2str(ROC),'X',num2str(X),...
'Y',num2str(Y),'F',num2str(focus),'P',num2str(P),'Ro',num2str(R_focus));
end
    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
function [fieldname]=fieldname_from_params(varargin)
if isstruct(varargin{1})
    s = varargin{1};
    n_elements=s.N; ROC=s.ROC; X=s.X; Y=s.Y; focus=s.F; P=s.P;
else
    n_elements=varargin{1}; ROC=varargin{2}; X=varargin{3}; Y=varargin{4}; 
    focus=varargin{5}; P=varargin{6};
end
%returns txt field from params
    runstring = strcat('N',num2str(n_elements),'ROC',num2str(ROC),'X',num2str(X),...
    'Y',num2str(Y),'F',num2str(focus),'P',num2str(P));
    fieldname = split(runstring,'.');
    fieldname = strcat(fieldname{:});
end
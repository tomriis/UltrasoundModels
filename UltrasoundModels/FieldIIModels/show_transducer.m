%  Show the transducer surface in a surface plot
%
%  Calling: show_xdc(Th)
%
%  Argument: Varargin could either be transducer pointer or data directly
%
%  Return:   Plot of the transducer surface on the current figure
%
%  Note this version onlys shows the defined rectangles


function show_transducer(varargin)

%  Do it for the rectangular elements
p = inputParser;
addOptional(p,'Th', -1);
addOptional(p,'data',[]);
addOptional(p,'plotEl',[])
parse(p, varargin{:});

if p.Results.Th > 0
    data = xdc_pointer_to_rect(p.Results.Th);
elseif ~isempty(p.Results.data)
    data = p.Results.data;
else
    return
end
data = data * 1000;
plotEl = p.Results.plotEl;
disp(plotEl)
[~,M]=size(data);

X = [2,5,8,11];
Y = [3,6,9,12];
Z = [4,7,10,13];

ind = [1,4,2,3];
for i=1:M
  x=[data(X(ind(1)),i), data(X(ind(2)),i); data(X(ind(3)),i), data(X(ind(4)),i)];
  y=[data(Y(ind(1)),i), data(Y(ind(2)),i); data(Y(ind(3)),i), data(Y(ind(4)),i)];
  z=[data(Z(ind(1)),i), data(Z(ind(2)),i); data(Z(ind(3)),i), data(Z(ind(4)),i)];
  c=ones(2,2);
  surf(x,z,y,c)
  if ismember(i,plotEl)
      surf(x,y,z,0.2*ones(2,2),'MarkerSize',20); hold on;
      element = data(:,i);
      c1 = element(2:4);
      c2 = element(5:7);
      c3 = element(8:10);
      center = element(17:19);
      n = normalVectorFrom3Points(c1,c2,c3);
      n = n/norm(n)*220;
      quiver3(center(1), center(2), center(3),n(1),n(2),n(3)); hold on;
  end
  hold on
end

% Hc = colorbar;

%view(3)

xlabel('x [mm] (Lateral)')
ylabel('z [mm] (Axial)')
zlabel('y [mm] (Elevation)')
grid
axis('image')

% view([45,45, 45]);  
% view([0,0,90]);
view([0,0,90]);
set(gcf,'color','w')
% set(gca,'visible','off')
theta = linspace(0,2*pi,2000);
a = 90;
b = 70;
y = a*sin(theta);
x = b*cos(theta);
z = zeros(1,length(theta));
% plot3(x,z,y,'k--','LineWidth',2.5)
% plot3(x,y,z,'k--','LineWidth',2.5);

end

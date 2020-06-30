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
addOptional(p, 'fast',false);
addOptional(p, 'show_skull',false);
addOptional(p,'plotEl',[])
parse(p, varargin{:});

if p.Results.Th > 0
    data = xdc_pointer_to_rect(p.Results.Th);
elseif ~isempty(p.Results.data)
    data = p.Results.data;
else
    return
end
plotEl = p.Results.plotEl;
[~,M]=size(data);
% d = p.Results.d;
% max_hp = d.max_hp;
% x = d.x;
% z = d.z;
% txfielddb = db(max_hp./max(max(max_hp)));
% imagesc(x*1e3, z*1e3, txfielddb');hold on;
X = [2,5,8,11];
Y = [3,6,9,12];
Z = [4,7,10,13];
if 0
       x=[data(11,:), data(20,:); data(14,:), data(17,:)]*1000;
       y=[data(12,:), data(21,:); data(15,:), data(18,:)]*1000;
       z=[data(13,:), data(22,:); data(16,:), data(19,:)]*1000;
 surf(x,y,z)
 hold on
else
    ind = [1,4,2,3];
    for i=1:M
      x=[data(X(ind(1)),i), data(X(ind(2)),i); data(X(ind(3)),i), data(X(ind(4)),i)]*1000;
      y=[data(Y(ind(1)),i), data(Y(ind(2)),i); data(Y(ind(3)),i), data(Y(ind(4)),i)]*1000;
      z=[data(Z(ind(1)),i), data(Z(ind(2)),i); data(Z(ind(3)),i), data(Z(ind(4)),i)]*1000;
      c=ones(2,2);
      surf(x,y,z,c)
      if ismember(i,plotEl)
          surf(x,y,z,0.2*ones(2,2));
      end
      hold on
    end
end
if p.Results.show_skull
    show_skull_space(-100);
end
%  Put some axis legends on

% Hc = colorbar;

%view(3)

xlabel('x [mm] (Lateral)')
ylabel('z [mm] (Axial)')
zlabel('y [mm] (Elevation)')
grid
axis('image')

view([45,45, 45]);  
set(gcf,'color','k')
set(gca,'visible','off')
theta = linspace(0,2*pi,2000);
a = 90;
b = 70;
y = a*sin(theta);
x = b*cos(theta);
z = zeros(1,length(theta));
plot3(x,z,y,'w--','LineWidth',2.5)
% plot3(x,y,z,'k--','LineWidth',2.5);

end

function show_skull_space(center_z)
    % Define cube size of human head
    alpha = 0.75;
    color = 'yellow';
    median_head_length = 176;
    median_head_width = 145;
    head_height = 100;
    y = -median_head_length/2 * [1,1;-1,-1];
    x = -median_head_width/2 * [-1,1;-1,1];
    z = head_height/2*[1,1;1,1];
    surf(x,y,z+center_z,'FaceColor',color,'FaceAlpha',alpha);
    hold on;
    surf(x,y,-z+center_z,'FaceColor',color,'FaceAlpha',alpha);
    hold on;
    surf(-median_head_width/2*[1,1;1,1],-median_head_length/2*[-1,1;-1,1],head_height/2*[1,1;-1,-1]+center_z,'FaceColor',color,'FaceAlpha',alpha);
    hold on;
    surf(-median_head_width/2*[-1,-1;-1,-1],-median_head_length/2*[-1,1;-1,1],head_height/2*[1,1;-1,-1]+center_z,'FaceColor',color,'FaceAlpha',alpha);
    hold on;
    surf(-median_head_width/2*[1,1;-1,-1],-median_head_length/2*[1,1;1,1],head_height/2*[-1,1;-1,1]+center_z,'FaceColor',color,'FaceAlpha',alpha);
    hold on;
    surf(-median_head_width/2*[1,1;-1,-1],median_head_length/2*[1,1;1,1],head_height/2*[-1,1;-1,1]+center_z,'FaceColor',color,'FaceAlpha',alpha);
end

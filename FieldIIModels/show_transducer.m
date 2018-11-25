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
parse(p, varargin{:});

if p.Results.Th > 0
    data = xdc_get(Th,'rect');
elseif ~isempty(p.Results.data)
    data = p.Results.data;
else
    return
end

[~,M]=size(data);
figure;
disp('Plotting transducers...')
if p.Results.fast
       x=[data(11,:), data(20,:); data(14,:), data(17,:)]*1000;
       y=[data(12,:), data(21,:); data(15,:), data(18,:)]*1000;
       z=[data(13,:), data(22,:); data(16,:), data(19,:)]*1000;
 surf(x,y,z)
 hold on
else
    for i=1:M
      x=[data(11,i), data(20,i); data(14,i), data(17,i)]*1000;
      y=[data(12,i), data(21,i); data(15,i), data(18,i)]*1000;
      z=[data(13,i), data(22,i); data(16,i), data(19,i)]*1000;
      c=data(5,i)*ones(2,2);
      surf(x,y,z,c)
      hold on
    end
end
if p.Results.show_skull
    show_skull_space(-100);
end
%  Put some axis legends on

% Hc = colorbar;
colormap(cool(128));
%view(3)
xlabel('x [mm] (Lateral)')
ylabel('y [mm] (Elevation)')
zlabel('z [mm] (Axial)')
grid
axis('image')
hold off
view([90, 90, 90]);  
disp('Complete')
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

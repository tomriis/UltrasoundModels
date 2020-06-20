n_elements_x = 26;
n_elements_y = 10;
ROC = 110/1000;
rFocus = 1.2*ROC;
D = [6,6]/1000;
kerf = [0.85+3.7,2.4+6.6]/1000;
simColumn = 1;
simColumnArray = 1;
filebase = 'C:\Users\Tom\Documents\MATLAB\UltrasoundModels\UltrasoundModels\TransducerDimensions\';
field_init(-1)
%% Column coordinates
if simColumn
    len_y = (D(2)+kerf(1))*n_elements_y;
    AngExtent_y = len_y/ rFocus;
    angle_inc_y = AngExtent_y/n_elements_y;
    index_y = -n_elements_y/2+0.5: n_elements_y/2-0.5;
    angle_y = index_y* angle_inc_y;   

    rectangles=[];

    focused_rectangles = [];
    for k=1:length(angle_y)
        x = [-D(1)/2 D(1)/2]; y = [-D(2)/2 D(2)/2]; z = [0,0];
        rect = [i x(1)  y(1)  z(1)  x(2)  y(1)  z(1)  x(2)  y(2)  z(2)  x(1)  y(2)  z(2)  1  D(1)  D(2)  0  0  0];
        rect = rect';
        rot = makexrotform(angle_y(k));
        rect([4,7,10,13,19],:)=rect([4,7,10,13,19],:)+rFocus;
        positioned_rect = apply_affine_to_rect(rot, rect);
    %           Append to transducer geometry
        focused_rectangles = horzcat(focused_rectangles, positioned_rect);
    end
    Z = [4,7,10,13];
    Y = [3,6,9,12];
    X = [2,5,8,11];
    mv = min(focused_rectangles(Z,:),[],'all');
    focused_rectangles([4,7,10,13,19],:) = focused_rectangles([4,7,10,13,19],:) - mv;
    % Place the static focus at the center of rotation
    % Convert to transducer pointer
    offsetY = abs(min(focused_rectangles(Y,:),[],'all'))+0.014;
    focused_rectangles([Y,18],:) = focused_rectangles([Y,18],:)+offsetY;
    fR = focused_rectangles;
    columnCoordinates = 1000*horzcat(fR(Z(1),:)', fR(Y(1),:)',fR(Z(4),:)',fR(Y(4),:)');
    columnCoordinates = horzcat((0:n_elements_y-1)',zeros(n_elements_y,1),columnCoordinates);

    cent = focused_rectangles(end-2:end,:);
    Th = xdc_rectangles(focused_rectangles', cent', [0,0,0]);

    T = table(columnCoordinates);
    writetable(T,[filebase,'verticalColumnCoordinates.xlsm'],'Sheet',1,'Range','A3:F20','WriteVariableNames',0)
    rect = xdc_pointer_to_rect(Th);
    show_xdc(Th)
end


if simColumnArray
%% Determine Column locations
    field_init(-1)
    [Th] = concave_focused_array(n_elements_x, n_elements_y, ROC, kerf, D, rFocus);
    rect = xdc_pointer_to_rect(Th);
    show_transducer('Th',Th);
    field_end();

    columnDepth = 31;
    arrayColumnCoordinates = [];
    for i =1:size(rect,2)
        if mod(i,10) == 0
            rectCoordinates =1000*[rect(X(3), i), rect(Z(3),i),...
                rect(X(4),i), rect(Z(4),i)];
            v3 = rectCoordinates(1:2);
            v3norm = v3/norm(v3);
            vBack = v3 + columnDepth*v3norm;
            %rectCoordinates = [rectCoordinates, vBack(2)];
            arrayColumnCoordinates = vertcat(arrayColumnCoordinates,rectCoordinates);
        end
    end
    % Start at column with all positive coordinates
    posInd = find(sum(arrayColumnCoordinates>0,2)==4);
    posInd = posInd(1);
    arrayColumnCoordinates = circshift(arrayColumnCoordinates,-1*posInd,1);
    arrayColumnCoordinates = [(0:(n_elements_x-1))', zeros(n_elements_x,1),...
        arrayColumnCoordinates];
    T = table(arrayColumnCoordinates);
    writetable(T,[filebase,'verticalArrayColumnCoordinates.xlsm'],...
        'Sheet',1,'Range',['A3:F',num2str(2+n_elements_x)],...
        'WriteVariableNames',0);
end


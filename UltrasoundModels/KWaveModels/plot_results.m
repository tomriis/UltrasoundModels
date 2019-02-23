function plot_results(points,corners)
figure; scatter3(points(1,:),points(2,:),points(3,:),'b*');
hold on; scatter3(corners(1,:),corners(2,:),corners(3,:),'r*')
scatter3(corners(1,1),corners(2,1),corners(3,1),'g*');
scatter3(corners(1,2),corners(2,2),corners(3,2),'y*');
end
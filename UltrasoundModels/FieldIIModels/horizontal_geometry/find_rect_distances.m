function distances = find_rect_distances(rect)
    % Simply calculates distance between elements
    distances = zeros(1, size(rect,2));
    for i = 1:length(distances)
        distances(i) = norm(rect([17,18,19],i)-...
        rect([17,18,19],wrapN(i+1,length(distances))));
    end
    figure; hist(distances);
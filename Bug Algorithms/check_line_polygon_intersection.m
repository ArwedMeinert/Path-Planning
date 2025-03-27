function intersects = check_line_polygon_intersection(currentPoint, futurePoint, polygons)
%checks if the current point and the target point and the edge of the
%polygon intersect
for p = 1:numel(polygons) 
    polygon=polygons{p};
    % extract x and y pos
    polyX = polygon(:, 1);
    polyY = polygon(:, 2);
    %close the polygon
    polyX = [polyX; polyX(1)];
    polyY = [polyY; polyY(1)];

    % extract x and y coordinates of line segment endpoints
    x = [currentPoint(1), futurePoint(1)];
    y = [currentPoint(2), futurePoint(2)];
    
    % check for intersections
    %thsi is where the toolbox is needed, I didnt want to implement this
    %function on my own
    [x_intersect, y_intersect] = polyxpoly(polyX, polyY, x, y);
    % gives back if it is not a valid target point (not reachable)
    intersects = ~isempty(x_intersect) && ~isempty(y_intersect);
    if intersects
        break;
    end
    
end
end
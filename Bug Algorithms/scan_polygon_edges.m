function [non_valid_points, valid_points] = scan_polygon_edges(currentPosition, polygons, scan_radius)
%scans from the current position in a circle with the radius scan_radius
%what points are valid targets and what points are invalid
    valid_points = [];
    non_valid_points=[];
    % generate points to check (num_points can be changed)
    num_points = 100;
    theta = linspace(0, 2 * pi, num_points);
    circle_points = [cos(theta); sin(theta)]' * scan_radius + currentPosition;
    
    % check each point
    for i = 1:num_points
        point = circle_points(i, :);
        % check if each point on the circle is reachable from the current
        % position
        obstructed = false;
            if check_line_polygon_intersection(currentPosition, point, polygons)
                obstructed = true;
                break;
            end
        % add point to valid/non valid list
        if ~obstructed
            valid_points = [valid_points; point];
        else
            non_valid_points=[non_valid_points;point];
        end
    end
end
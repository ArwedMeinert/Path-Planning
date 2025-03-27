function tangent_bug_algorithm(startPoint, targetPoint, polygons, sensor_range,colour)
    % Initialize current position to start point
    currentPosition = startPoint;
    % Calculate the direction of the target for the move-to-target mode
    directiont = (targetPoint - currentPosition) / norm(targetPoint - currentPosition);
    %Direction needed for the line following behaviour 
    direction = directiont;
    % Set the step size
    step_size = 0.1;
    
    % do until target is reached
    while norm(currentPosition - targetPoint) > step_size * 2
        % check for line segment between the robot and the sensor and its
        % direction
        inside_polygon = check_line_polygon_intersection(currentPosition, currentPosition + directiont * sensor_range, polygons);
        % if the way is clear
        if ~inside_polygon
            currentPosition = currentPosition + directiont * step_size;
        else
            % scan for valid points to move to(not inside the polygon, not
            % obstrcted
            scan_radius = sensor_range;
            [non_valid_points, valid_points] = scan_polygon_edges(currentPosition, polygons, scan_radius);
            %scatter(valid_points(:, 1), valid_points(:, 2), 'Marker', 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g');
            % calculate distance between each valid point and target
            min_distance = Inf;
            closest_point = [];
            %check what valid point is closest to the target
            for i = 1:size(valid_points, 1)
                dist = norm(valid_points(i, :) - (currentPosition + directiont));
                if dist < min_distance
                    min_distance = dist;
                    closest_point = valid_points(i, :);
                end
            end
            
            % move one step in the direction of the closest valid point
            % (update the position)
            direction = (closest_point - currentPosition) / norm(closest_point - currentPosition);
            currentPosition = currentPosition + direction * step_size;
        end
        %update the direction torwards the taret and move the robot
        directiont = (targetPoint - currentPosition) / norm(targetPoint - currentPosition);
        plot(currentPosition(1), currentPosition(2), 'Marker', '.', 'MarkerSize', 10, Color=colour);
        pause(0.1); % Pause to visualize the movement
    end
end
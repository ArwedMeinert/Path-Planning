function bug2_algorithm(startPoint, targetPoint, polygons,colour)
    % Initialize current position to start point
    currentPosition = startPoint;
    % Flag to indicate if the robot is following the boundary
    following_boundary = false;
    %Calculate the direction of the target for the move to target mode
    direction=(targetPoint-currentPosition)/norm(targetPoint-currentPosition);
    %Set the step size
    step_size = 0.1;
    %create a matrix of points that have already been encountered
    encountered_points=[];
    % Iterate until the current position reaches the target point
    while norm(currentPosition - targetPoint) > step_size*2
        % Check if the current position is inside any of the obstacles

        
        if following_boundary==false
            %Check if the current position is inside one of the poygons
            [following_boundary, edge_directions, boundary_index,polygon_no] = point_in_polygons(currentPosition, polygons,step_size);
            if following_boundary
                %write the current position as closest position at the
                %object encounter
                initial_encounter=currentPosition;
            end
        end
        
        %move to target
        if  ~following_boundary
            %make small steps torwards the goal
            currentPosition=currentPosition+direction*step_size;
            plot(currentPosition(1), currentPosition(2),'Marker','.' , 'MarkerSize', 10,Color=colour);
            pause(0.1); % Pause to visualize the movement
        end

        %follow boundary
        if following_boundary
            %initial variable state
            %robot movement
            while following_boundary

                % Move in the direction of the current edge
                currentPosition = currentPosition + edge_directions(boundary_index, :) * step_size;
        
                % Check if the current position is close to the next boundary point
                total_points = size(polygons{polygon_no}, 1);
                %safe the next point while taking into account that a
                %polygon is "round" (wrap around)
                next_point = polygons{polygon_no}(mod(boundary_index, total_points) + 1, :);
                if norm(currentPosition - next_point) <= step_size*2
                    boundary_index = boundary_index + 1;
                    %wrap around
                    if boundary_index > size(edge_directions, 1)
                        boundary_index = 1;
                    end
                    %If the robot is close to the edge position, set the
                    %position to the edge position
                    currentPosition = polygons{polygon_no}(boundary_index,:);
                end
        
                % Check if the current position is on the line between the
                % start and the target

                if point_to_line_distance(currentPosition,startPoint,targetPoint)<=step_size && ~check_encountered(currentPosition,encountered_points,step_size)
                    currentPosition = currentPosition + direction * step_size;
                    encountered_points=[encountered_points;currentPosition];
                    following_boundary=false;
                end
                %plot the movement
                plot(currentPosition(1), currentPosition(2),'Marker','.' , 'MarkerSize', 10,Color=colour);
                pause(0.1); % Pause to visualize the movement
             end
        end

        
        % Plot the current position

    end
    
end
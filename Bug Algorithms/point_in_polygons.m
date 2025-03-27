function [inside, edge_directions, current_edge_index,polygon_no] = point_in_polygons(point, polygons,step_size)
%Checks if a point (current position) is inside a cell of polygons with the accuracy of step size. 
%Inside is true when the point is in one of the polygons
%edge_direction gives the directions of the edges of the polygons
%current_edge_index gives the current edge direction closest to the polygon
%line
%polygon_no polygon number the point is inside of

% Initialize variables
    inside = false;
    edge_directions = [];
    polygon_no=0;
    current_edge_index=0;
    min_distance=inf;
    % Iterate over each polygon
    for p = 1:numel(polygons)
        polygon = polygons{p};

        % Check if the point is inside the current polygon
        inside = inpolygon(point(1), point(2), polygon(:, 1), polygon(:, 2));
        % If the point is inside the current polygon, find the nearest edge
        if inside
            polygon_no=p;
            % Iterate over each vertex of the polygon
            for i = 1:size(polygon, 1)
                % Extract coordinates of the current point
                p1 = polygon(i, :);
                % Extract coordinates of the next point
                if i < size(polygon, 1)
                    p2 = polygon(i + 1, :);
                else
                    p2 = polygon(1, :);
                end

                % Calculate the direction vector for the current edge
                direction_vector = (p2 - p1) / norm(p2 - p1);
                %save all the directions of the polygon
                edge_directions = [edge_directions; direction_vector];
                %calculate the distance bwtween the point and the line
                %(p1,p2)
                distance = point_to_line_distance(point, p1, p2);
                
                % Check if the distance is smaller than the minimum distance found so far
                if distance < min_distance
                    min_distance = distance;
                    current_edge_index = i; % Store the index of the closest edge
                end
            end
        %if it is in the polygon, break since the robot can be only in one
        %polygon
        break
        end
    end
end
function is_clear = line_of_sight(map, start_point, end_point, sample_dist)
    % how many points on the line shall be checked 
    num_points = ceil(norm(end_point - start_point) );

    % generate many points on the line between target and start
    points = [linspace(start_point(1), end_point(1), num_points);linspace(start_point(2), end_point(2), num_points)];

    % Iterate over the points and check for obstacles
    for i = 1:num_points
        
        x = round(points(1, i));
        y = round(points(2, i));

        % check if the x and y values are valid (inside the map)
        if x <= 0 || y <= 0 || x > size(map, 1) || y > size(map, 2)
            is_clear = false;
            return;
        end
        %cehck for adjacent pixels as well (teh line might be diagonal)
        for dx=-1:1
            for dy=-1:1
                %dont check for adjacent pixels if the pixel is on the edge
                %of the map
                if x+dx<1 || x+dx>size(map,1) ||y+dy<1 || y+dy>size(map,2)
                    if ~map(x,y)
                        is_clear = false;
                        return;
                    end
                else
                    if ~map(x+dx,y+dy)
                        is_clear = false;
                        return;
                    end
                end
            end
        end
    end
    
    % If no obstacles were encountered along the line, return true
    is_clear = true;
end
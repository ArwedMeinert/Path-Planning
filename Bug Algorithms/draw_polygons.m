function draw_polygons(polygons)
    % Iterate over each polygon
    for p = 1:numel(polygons)
        % Get the vertices of the current polygon
        vertices = polygons{p};
        
        % Iterate over each vertex of the current polygon
        for i = 1:size(vertices, 1)
            % Extract coordinates of the current vertex
            current_vertex = vertices(i, :);
            
            % Extract coordinates of the next vertex (handling wrap-around)
            if i < size(vertices, 1)
                next_vertex = vertices(i + 1, :);
            else
                next_vertex = vertices(1, :);
            end
            
            % Plot the line connecting the current vertex to the next vertex
            plot([current_vertex(1), next_vertex(1)], [current_vertex(2), next_vertex(2)], 'k-', 'LineWidth', 2);
        end
    end
end
function [tree,RRT_path] = build_tree(start_point, target_point, K, sample_dist, map, debug)
   %Build the tree from the starting point and if posible to the target
   %(target is added as the last node). with K nodes and an edge length of
   %sample_dist.Debug shows the map generation

   %Define the tree structure
    tree_struct = struct('location', [], 'edges', [], 'costs', [],'parent',[]);
    
    % Initialize the tree with the start point
    node = tree_struct;
    node.location = start_point;
    tree = node;
    %Draw first node for the debug mode
    if debug
        scatter(node.location(1), node.location(2), 'red', '+');
        hold on;
    end
    
    % Get the size of the map
    [num_rows, num_cols] = size(map);
    
    % Main loop to build the tree
    while length(tree)<K-1
        % Randomly sample a point in the C space
        randx = randi([1,num_rows]);
        randy = randi([1, num_cols]);
        
        % Skip if the point is not valid
        if ~map(randx,randy)
            continue;
        end
        
        % Initialize variables
        distance = inf;
        qnew = [];
        
        % Find the nearest node in the tree to the random point
        for j = 1:length(tree)
            %calculates the possible distance to each node for comparison
            poss_distance = abs(norm([randx, randy]- tree(j).location));
            %generates possible new point (to check if the point is
            %obstrcted)
            poss_qnew = tree(j).location + ([randx, randy] - tree(j).location) /...
                norm([randx, randy] - tree(j).location) * sample_dist;
            %Check if the distance from the current node to the random
            %point is the shortest
            if poss_distance < distance && ...
                    line_of_sight(map, tree(j).location, poss_qnew,sample_dist)
                distance = poss_distance;
                closest_node = j;
                qnew = poss_qnew;
            end
        end
        
        % If a point exists that is possible (no object between the closest
        % node and the new point)
        if ~isempty(qnew)
            %add node to the tree
            node.parent=closest_node;
            node.location = qnew;
            node.costs = abs(norm(qnew-tree(closest_node).location));
            node.edges = closest_node;
            tree = [tree;node]; % Append the new node to the tree
            
            % Update the edges and costs of the nearest node in the tree
            tree(closest_node).edges = [tree(closest_node).edges; length(tree)];
            tree(closest_node).costs = [tree(closest_node).costs; node.costs];
            
            % Debug mode: Plot added points and edges
            if debug
                % Plot added points
                scatter(node.location(1), node.location(2), 'red', '+');
                % Plot added edges
                for j = 1:length(tree(closest_node).edges)
                    connected_node_index = tree(closest_node).edges(j);
                    connected_node_location = tree(connected_node_index).location;
                    plot([node.location(1), connected_node_location(1)], ...
                         [node.location(2), connected_node_location(2)], ...
                         'LineWidth', 0.1, 'Color', 'blue');
                end
                pause(0.001);
            end
        end
    end
    %Adding the target point as the last point to the tree if it is
    %reachable by other nodes
    node.location = target_point;
    node.edges = [];
    node.costs = [];
    closest_node_dist=inf;
    for j = 1:length(tree)
        %update all other nodes the target can connect to
        %Adding edges from the goal to all nodes in the sampling distance
        if abs(norm(target_point- tree(j).location)) <= sample_dist && ...
            line_of_sight(map, target_point, tree(j).location,sample_dist)
            node.edges = [node.edges;j];
            node.costs = [node.costs;abs(norm(target_point- tree(j).location))];
            %CHeck, what node is the closest ot the goal
            if abs(norm(target_point- tree(j).location))<closest_node_dist
                closest_node_dist=abs(norm(target_point- tree(j).location));
                closest_node=j;
            end
        end
    end
    tree(closest_node).edges = [tree(closest_node).edges; length(tree)+1];
    tree(closest_node).costs = [tree(closest_node).costs; abs(norm(target_point- tree(closest_node).location))];
    node.parent=closest_node;
    %add last point to tree
    tree=[tree;node];
    [RRT_path,~]=create_path(tree,1,length(tree));
end
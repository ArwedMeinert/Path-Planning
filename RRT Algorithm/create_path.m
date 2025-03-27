function [shortest_path_indices,path_distance] = create_path(tree, start_node_index, target_node_index)
    %creates the shortest path in the tree with nodes that have a parent
    %from the starting node to the target node
    shortest_path_indices = target_node_index;
    
    %initialize the current node index with the target node index
    current_node_index = target_node_index;
    path_distance=0;
    %loop until reaching the start node
    while current_node_index ~= start_node_index
        %get the parent node index of the current node
        parent_node_index = tree(current_node_index).parent;
        
        %write the parent node index to the shortest path array
        shortest_path_indices = [parent_node_index, shortest_path_indices];
        
        %calculate the distance of teh path as well
        edge_index = find(tree(parent_node_index).edges == current_node_index);
        path_distance = path_distance + tree(parent_node_index).costs(edge_index);

        %update the current node index to the parent node index
        current_node_index = parent_node_index;
    end
end
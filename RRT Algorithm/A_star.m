function [shortest_path,path_distance,direct_distance] = A_star(tree,start_point,target_point)
%Creates the path (index of nodes in the tree in order) from start point to
%finish point
    
    %Create open and close list for the algorithm
    direct_distance=abs(norm(start_point-target_point));
    open_list = [];
    closed_list = [];
    search_tree=tree;
    %Add the fields to the data sructure that are needed
    for i=1:numel(tree)
        search_tree(i).parent=[];
        search_tree(i).f_score=inf;
        search_tree(i).h_score=[];
    end
    % Get start and target node indices
    start_node_index = find_node(tree, start_point);
    target_node_index = find_node(tree, target_point);
    open_list=start_node_index;
    %set the h_score (distance to target) and the f_score
    for i=1:numel(tree)
        %h distance for target node will become 0
        search_tree(i).h_score=abs(norm(search_tree(i).location- search_tree(target_node_index).location));
        search_tree(i).f_score=inf;
    end
    %Initialize start node as the current node
    current_node = start_node_index;
    search_tree(start_node_index).parent=0;
    search_tree(start_node_index).f_score=0;
 
    %Loop until the open list is empty (target is reached)
    while ~isempty(open_list)

        %Find the node in the open list with the lowest f_score
        [~, idx] = min([search_tree(open_list).f_score]);
        current_node = open_list(idx);

        %If the current node is the target node, exit the loop
        if current_node == target_node_index
            break;
        end

        %Move current node from open list to closed list
        open_list(idx) = [];
        closed_list(end+1) = current_node;

        %Loop through the edges of the current node
        for i = 1:numel(search_tree(current_node).edges)
            %check every neighbor of the current node that is not in the
            %closed list
            neighbor_node = search_tree(current_node).edges(i);
            if ~ismember(neighbor_node, closed_list)
                %calculate the possible g score for the node
                poss_g_score = search_tree(current_node).f_score + search_tree(current_node).costs(i);
                if poss_g_score < search_tree(neighbor_node).f_score
                    %update parent and f_score of neighbor node
                    search_tree(neighbor_node).parent = current_node;
                    search_tree(neighbor_node).f_score = poss_g_score;

                    %add neighbor node to open list if not already in it
                    if ~ismember(neighbor_node, open_list)
                        open_list(end+1) = neighbor_node;
                    end
                end
            end
        end
    end


    %create the shortest path
    [shortest_path,path_distance] = create_path(search_tree, start_node_index, target_node_index);
end
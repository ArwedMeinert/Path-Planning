# Path-Planning
Path planning projects implemented in MATLAB for the Dynamics and Motion Planning course at HV.
Two types of algorithms were implemented. In the first step, Bug1, Bug2, and Tangent Bug were implemented along with the environment. The obstacles can be defined as polygons. The start and end positions can also be set. In the second project, RRT was implemented, as well as the A* algorithm, to find the shortest path in a node tree. 
All projects were implemented in MATLAB.

## Bug

### Bug 1
The idea of Bug 1 is to move directly toward the target. Once it encounters an obstacle, it follows its border until it has reached its initial encounter position. While circling around the obstacle, it keeps track of the distance to the goal. The position where the distance is shortest is saved. After reaching the initial encounter position with the obstacle, it moves back to the position where the distance was shortest and continues moving toward the goal.

<img src="https://github.com/user-attachments/assets/8c367920-ae82-4429-ae16-e44bee78f739" width="50%">
<img src="https://github.com/user-attachments/assets/df30157c-99fb-4e5f-87fd-9bacd1e512a7" width="30%">

### Bug 2
In the Bug 2 algorithm, a straight line is drawn from the start position to the goal. The robot moves directly to the goal until an object is encountered. It then chooses a direction to circle the object until the initial line to the target is encountered again on the other side of the object. It then moves back on the line toward the goal.

<img src="https://github.com/user-attachments/assets/6ee8fa28-a639-4690-acf0-2d69068cd29e" width="50%">
<img src="https://github.com/user-attachments/assets/00840026-8571-487e-aad2-b157a6fdeb97" width="30%">

### Tangent Bug
The Tangent Bug algorithm uses a simulated sensor (LiDAR) that measures the distance to objects around the robot. When the sensor does not detect an object in the direction of the goal, the robot moves directly toward it. Once an object is detected by the sensor, the robot turns until the sensor no longer detects an object. This results in a gradual turn of the robot until it moves in the direction of the objects edge. It always tries to move in the direction where the sensor does not detect an object and the distance to the target is minimal. It is important to ensure that the robot does not turn around to achieve a local minimum but never reaches the goal.

<img src="https://github.com/user-attachments/assets/fa896891-a479-4d91-9a8d-a4ab9147d07e" width="50%">
<img src="https://github.com/user-attachments/assets/3a0be246-e51b-430b-88e2-978dcc65c5f2" width="30%">

### Comparison
When using all three algorithms in the same environment, it is clear that the Tangent Bug is the most efficient. All three algorithms sometimes have problems finding a path to the goal when objects are placed in specific ways. Additional metrics would be needed to prevent local optima that prevent the robot from reaching the target.

<img src="https://github.com/user-attachments/assets/d0f1ec29-9d01-4c31-8d6a-2017ec636b62" width="30%">

In the picture above, the paths of all three algorithms can be seen: Bug 1 in red, Bug 2 in green, and Tangent Bug in blue.

## RRT
The goal of the RRT algorithm is first to explore the map. In this step, a node tree is expanded by creating a node in a random position on the map. After that, the closest node is found, and a new node is created toward it at a fixed distance. It is added to the node tree while storing information about the closest distance to the parent of the node.

This expands the node tree until the set number of nodes has been created. They should be spread across the environment with a bias toward the center of the map. All nodes have a connection to the root of the tree, making it easy to travel from any node to the root by following parent nodes.

After the map has been explored, a goal can be added. Now, the goal is added to the node tree by searching for the node closest to the goal. This node becomes the parent of the goal node. The shortest path can now be obtained by backtracking through each parent node.

<img src="https://github.com/user-attachments/assets/77ccd1e5-32cb-4b8c-8d1c-85d66f8c3531" width="35%">
<img src="https://github.com/user-attachments/assets/9ebf0643-9b6f-4873-996a-d4823dc142e9" width="35%">



The resulting node tree does not necessarily provide the absolute shortest path to the goal, but it gives a good starting point. Each node is shown as a red cross, and a path is shown in dark blue. Similar to the algorithms above, the start is the green point on the right, and the goal is the red point in the center. The path from the start to the center is shown in light blue.

The problem with local optima can be seen in some corners. When a new node is created in the center of a corner, it results in a cluster of nodes in dead-end areas. There are methods to improve this, but the goal was to implement the original RRT algorithm.

### A*
Additionally, the A* algorithm was implemented. While the RRT algorithm already provides a path, the A* algorithm can be used to create multiple paths from each node by searching for connectable nodes within a radius. This would create an interconnected tree with multiple paths to each node. Then, the A* algorithm could be used to find even better paths.

This can be seen in the picture above, where the goal node is connected to the closest node but not necessarily the most optimal one. Ideally, it would be connected to all nodes within range, and the A* algorithm would be used to find the shortest path.

```matlab
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
```








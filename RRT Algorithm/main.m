clear all
clc
%Start Location
start1 = [1,250];
%Goal Location
goal = [285,250];
%Map Generation
%hard map
%map = generateMap();
%easy map
map = generateEasyMap();
map(183,500);
fmap = figure;
imshow(map');
hold on
%Plot Start and Goal
scatter(start1(1,1),start1(1,2),"filled",'red');
scatter(goal(1,1),goal(1,2),"filled",'green');
%Create and save the Tree
%starts to take a long while after 3000 Iterations in the tree building
%process
%good values for the easy map are: K=600, sample_dist=30
%with 4000 iterations, the tree does not reach the goal at the hard map

%Builds the tree and gives the path from the start (first node) to the goal
%(last node) with K nodes and a sample lenght of 30 of the map. Debug
%results in the drawing of each node as its created (it makes some errors,
%but when the map is drawn afterwards it works)

[tree,RRT_Path]=build_tree(start1,goal,800,30,map,false);
plot_tree(tree);
%RRT_Path was implemented after the A* algorithm. Both paths are the same,
%since in the RRT algorithm nearby nodes are not connected. Therefore there
%is only one path from the target to the goal. It can be found by saving
%the parent node in the RRT algorithm or by doing the A* algorithm.

%Plots the paht thru a tree in a specified colour
plot_path(tree,RRT_Path,[1 0 0 0.5]);

%Gives back the result (best path thru the tree) and the distance of the
%path as well as the direct (start to point) distance
[path,dist,direct_distance]=A_star(tree,start1,goal);
plot_path(tree,path,[0 1 1 0.5]);

fprintf('The direct distance is %4.1f and the length of the path is %4.1f',direct_distance,dist)
hold off




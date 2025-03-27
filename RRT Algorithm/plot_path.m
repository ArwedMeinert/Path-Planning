function done = plot_path(tree,path,colour)
%plots the path from a target to a tree in the colour

%Set a colour if no colour si specified
if isempty(colour)
    colour=[0 1 0];
end
hold on
%plot the connecting edge from each element of the path
for i=1:length(path)-1
    plot([tree(path(i)).location(1),tree(path(i+1)).location(1)],[tree(path(i)).location(2),tree(path(i+1)).location(2)],'LineWidth',1.5,Color=colour);
end
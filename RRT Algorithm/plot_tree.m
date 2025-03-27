function done = plot_tree(tree)
done=false;
hold on
%plot every tree node location
for i = 1:length(tree)
    scatter(tree(i).location(1), tree(i).location(2),'red', '+');
end
%plot the edges of the tree (connecting nodes)
for i=1:length(tree)
    for j=1:length(tree(i).edges)
        plot([tree(i).location(1),tree(tree(i).edges(j)).location(1)],[tree(i).location(2),tree(tree(i).edges(j)).location(2)],'LineWidth',0.1,'Color',"blue");
    end
end
done=true;
end
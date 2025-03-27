function node_no = find_node(tree,position)
%iterates thru the tree to find the index of the position
for i=1:length(tree)
    if tree(i).location==position
        node_no=i;
        return
    end
end
end
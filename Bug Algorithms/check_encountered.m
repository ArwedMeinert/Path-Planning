function [aready_encountered] = check_encountered(currentPos,previous_points,step_size)
%Checks if the current position has already been encountered before
aready_encountered=false;
if size(previous_points)==0
    return
end
for i=1:size(previous_points(:,1))
    if abs(previous_points(i,1)-currentPos)<=step_size
        aready_encountered=true;
        break
    end
end
end
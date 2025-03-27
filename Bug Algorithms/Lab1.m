clc
clear all
lowerPoint=0;
upperPoint=10;
startPoint=[9.5 9.5];
targetPoint=[0.5 0.5];
%specify polygons with all the point in a cell array
polygons = {
    [2, 6; 2, 4; 8, 5],
    [7, 9; 6, 6; 9.3, 6;9.5,7.3]
};
%alternative polygon
%polygons={
%[3,1;4,2;2.5,3.5;3.5,4.5;5,3;6,4;4,6;1,3]
%}

axis([lowerPoint-1,upperPoint+1,lowerPoint-1,upperPoint+1]);
axis equal
%Draw the enviroment boundaries
rectangle('Position',[lowerPoint lowerPoint upperPoint-lowerPoint upperPoint-lowerPoint])
hold on
%Draw the polygons (Objects)
draw_polygons(polygons);
%Draw start and end Point
plot(startPoint(1), startPoint(2), 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
plot(targetPoint(1), targetPoint(2), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
%Do the Bug1 Algorithm
bug_algorithm(startPoint,targetPoint,polygons,[1 0 0 0.3])
bug2_algorithm(startPoint,targetPoint,polygons,[0 1 0 0.3])

%tangent bugs needs the navigations toolbox for a function to determine if
%two lines defined by four points intersect

tangent_bug_algorithm(startPoint,targetPoint,polygons,1,[0 0 1 0.3]);
hold off
function distance = point_to_line_distance(point, p1, p2)
    % Calculate the distance from a point to a line defined by two points
    % (x2-x1)(y1-y0)-(x1-x0)(y2-y1)/sqrt((x2-x1)^2+(y2-y1)^2)
    numerator = abs((p2(1) - p1(1)) * (p1(2) - point(2)) - (p1(1) - point(1)) * (p2(2) - p1(2)));
    denominator = sqrt((p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
    distance = numerator / denominator;
end
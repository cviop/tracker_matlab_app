
function [arc_len, air_len, heading, base_elev_deg, target_elev_deg] = gpsDistanceHeadingElevation(base, target)



% base = [50.0967311, 14.3592856, 0]; %lat, long, height asl
% target = [50.0968758, 14.3597494, 5];

R = 6371000; %Earth's radius in metres

%% Distance
% Converting from deg to rad
point1_rad = deg2rad(base);
point2_rad = deg2rad(target);

% Computing great angle between the points
great_angle_rad = acos(sin(point1_rad(1)) * sin(point2_rad(1)) + cos(point1_rad(1)) * cos(point2_rad(1)) * cos(abs(point1_rad(2) - point2_rad(2))));

% Adding asl height to earth's radius
total_len_1 = R+point1_rad(3);
total_len_2 = R+point2_rad(3);

% Basic arc length (not useful)
arc_len = R*great_angle_rad;

% Distance between the points if you are an electromagnetic wave
air_len = sqrt(total_len_1^2 + total_len_2^2 - 2*total_len_1*total_len_2*cos(great_angle_rad));



%% Elevation at which you have to look at the other point
beta_rad = asin(total_len_1*sin(great_angle_rad)/air_len);
alpha_rad = pi - (great_angle_rad + beta_rad);

base_elev_deg = 180/pi * (-pi/2 + alpha_rad);
target_elev_deg = 180/pi * (-pi/2 + beta_rad);



%% Heading computing
% dlat = point2_rad(1) - point1_rad(1);
dlon = point2_rad(2) - point1_rad(2);

y = sin(dlon) * cos(point2_rad(1));
x = cos(point1_rad(1)) * sin(point2_rad(1)) - sin(point1_rad(1)) * cos(point2_rad(1)) * cos(dlon);
heading = atan2(y, x);

% Convert heading to degrees
heading = rad2deg(heading);

% Normalize heading to 0-360 degrees
if heading < 0
    heading = heading + 360;
end

end
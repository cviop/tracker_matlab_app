function trackerNorthAlignment(s, npoints)
    calibElevationAngle = 90;
    send_orientation(s, [0 calibElevationAngle 0])

    pause(5)

    delay_between_measurements = 15/npoints;
    average_samples = 10;
    averaging_pause = 0.05;

    mag_data = zeros(3,npoints);
    angle_setpoints = linspace(0,360*(1-1/npoints),npoints);

    disp("Calibration begin...")
    calib_time = npoints*(delay_between_measurements + average_samples*averaging_pause);
    fprintf("Calibration will take %.2d seconds...\n",calib_time )

    flush(s)
    
    pause(2)
    for i = 1:npoints
        fprintf("Moving to angle %.2d\n", angle_setpoints(i))
        send_orientation(s, [angle_setpoints(i), calibElevationAngle,0])
        pause(delay_between_measurements)
        mag_data_temp = zeros(3,average_samples);
        disp("measuring")
        for n = 1:average_samples
            [~,~,mag_data_temp(:,n)] = readTrackerRawData(s);
            pause(averaging_pause)
        end

        mag_data(:,i) = median(mag_data_temp,2);
        fprintf("Run %i / %i, mag: x %.2d, y: %.2d, z: %.2d\n",i,npoints, mag_data(1,i),mag_data(2,i),mag_data(3,i))
    end

    [x_circ, y_circ] = rectifyEllipse(mag_data(1,:), mag_data(3,:));

    figure(1)
    plot(x_circ, y_circ)
    axis equal

    yaw_to_north = rad2deg(atan2( y_circ(1), x_circ(1)))-180;
    if yaw_to_north<0
        yaw_to_north = yaw_to_north+360;
    end
    disp(yaw_to_north)

    pause(1)
    %send_orientation(s, [yaw_to_north, calibElevationAngle,0])


    send_orientation(s, [360, calibElevationAngle,0])

    for angle = linspace(360, yaw_to_north, 5)
        disp(angle)
        send_orientation(s, [angle, calibElevationAngle,0])
        pause(1)
    end

    trackerZeroOutYaw(s)
    

    disp("done")
end


function trackerElevationAlignment(s)
    flush(s)
    send_orientation(s, [-1 0 0]) %% yaw -1 is used to avoid change of the current yaw position 
    
    elevation_actual = 1;
    out = readTrackerInfo(s);

    phi = rad2deg(out.phirad);
    disp(phi);
    
    switchOffsetToZero = 2;

    totalOffsetAngle = switchOffsetToZero-phi;
    
    %% coarse
    
    while true
        [~,ElevLimOn,~] = readSwitches(s);
        if ElevLimOn
            
            trackerZeroOutElevationPolarisation(s);
            pause(0.1)
            send_orientation(s, [-1, totalOffsetAngle, 0])
            pause(0.1)
            trackerZeroOutElevationPolarisation(s);
            disp("Coarse calibration done...")
            break;
        end
        send_orientation(s, [-1, -2, 0])
        pause(0.2)
        trackerZeroOutElevationPolarisation(s);

        pause(.5)

    end
    
end

gpsPort = serialport('COM7', 9600);

%% Register Cleanup Routine
% onCleanup will call cleanupResources when the workspace clears or script exits
cleanupObj = onCleanup(@() cleanupResources(gpsPort));

%% Configure Serial Callback
configureCallback( ...
    gpsPort, ...
    "terminator", ...
    @(src,evt) nmeaCallback(src, evt, s) ...
);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Local callback for parsing GNGLL sentences
function nmeaCallback(src, ~, s)
    line = readline(src);
    if startsWith(line, '$GNGLL')
        fields = split(line, ',');
        ext_lat = dmToDecimal(fields{2}, fields{3});
        ext_lon = dmToDecimal(fields{4}, fields{5});
        %fprintf('Latitude: %.6f, Longitude: %.6f\n', lat, lon);
        [gpsData, ~,~] = TC_read_gps(s, 0);
        [arc_len, air_len, heading, base_elev_deg, target_elev_deg] = gpsDistanceHeadingElevation([gpsData.lat gpsData.lon 0], [ext_lat ext_lon 0]);
        fprintf("Distance: %.2f m, Heading: %.1f m\nTarget lat: %.10f, lon: %.10f\nBase: lat: %.10f lon :%.10f\n", air_len, heading, ext_lat, ext_lon, gpsData.lat, gpsData.lon);
        % moc se mi nelíbí, že se je sync pres gps, kldině by to mohlo byt
        % externim timerem. Taky mit timer na vypreslovani na mapu
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Helper: Convert ddmm.mmmm to decimal degrees
function dec = dmToDecimal(dmStr, dir)
    val = str2double(dmStr);
    deg = floor(val/100);
    min = val - deg*100;
    dec = deg + min/60;
    if any(dir == ['S','W'])
        dec = -dec;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cleanup function: stops timer and closes serial port
function cleanupResources(serialObj)
    
    try
        % Disable callback and clear serial port object
        configureCallback(serialObj, 'off');
        clear serialObj;
    catch
        warning('Failed to clear serial port.');
    end
end

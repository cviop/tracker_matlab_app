function [gpsData, valid, out] = TC_read_gps(s, disp)

    TC_send_message(s, 1)
    out = read(s, 100, "uint8");
    valid = checkUBXChecksum(out);
    if ~valid
        out = zeros(1,100);
    end
    gpsData = decodeUBXNavPvt(out, disp);
    
    
end

function gpsData = decodeUBXNavPvt(data, disp)
    % Validate message structure
    if length(data) < 98
        error("Invalid message length.");
    end
    
    % Extract relevant fields
    gpsData.iTOW = typecast(uint8(data(7:10)), 'uint32');   % GPS Time of Week (ms)
    gpsData.year = typecast(uint8(data(11:12)), 'uint16');  % Year
    gpsData.month = data(13);                               % Month
    gpsData.day = data(14);                                 % Day
    gpsData.hour = data(15);                                % Hour
    gpsData.min = data(16);                                 % Minute
    gpsData.sec = data(17);                                 % Second
    gpsData.fixType = data(27);                             % GNSS Fix Type (0-5)
    gpsData.numSV = data(29);                               % Number of Satellites Used
    gpsData.lon = double(typecast(uint8(data(31:34)), 'int32')) * 1e-7;  % Longitude (deg)
    gpsData.lat = double(typecast(uint8(data(35:38)), 'int32')) * 1e-7;  % Latitude (deg)
    gpsData.height = double(typecast(uint8(data(39:42)), 'int32')) / 1000; % Height (m)
    gpsData.hMSL = double(typecast(uint8(data(43:46)), 'int32')) / 1000;  % Height above Mean Sea Level (m)
    gpsData.hAcc = double(typecast(uint8(data(47:50)), 'uint32')) / 1000; % Horizontal Accuracy (m)
    gpsData.vAcc = double(typecast(uint8(data(51:54)), 'uint32')) / 1000; % Vertical Accuracy (m)
    gpsData.gSpeed = double(typecast(uint8(data(67:70)), 'int32')) / 1000; % Ground Speed (m/s)
    gpsData.headMot = double(typecast(uint8(data(71:74)), 'int32')) * 1e-5; % Heading of Motion (deg)
    if disp
        % Display readable data
        fprintf("Time: %02d:%02d:%02d | Date: %04d-%02d-%02d\n", gpsData.hour, gpsData.min, gpsData.sec, gpsData.year, gpsData.month, gpsData.day);
        fprintf("Fix Type: %d | Satellites Used: %d\n", gpsData.fixType, gpsData.numSV);
        fprintf("Latitude: %.7f | Longitude: %.7f\n", gpsData.lat, gpsData.lon);
        fprintf("Height: %.2f m | HAE: %.2f m\n", gpsData.height, gpsData.hMSL);
        fprintf("Speed: %.2f m/s | Heading: %.2f°\n", gpsData.gSpeed, gpsData.headMot);
    end
end

function [valid, ckA, ckB] = checkUBXChecksum(pkt)
  % pkt must be uint8
  if numel(pkt) == 100
      if(pkt(1) == 181 && pkt(2) == 98)
          payloadLen = double(pkt(5)) + 256*double(pkt(6));
          firstIdx = 3;
          lastIdx  = 6 + payloadLen;
          
          % pull out the bytes we actually want
          data = double(pkt(firstIdx : lastIdx));  
        
          % compute Fletcher
          ckA = uint8(0);
          ckB = uint8(0);
          for b = data(:)'
            ckA = uint8(  bitand( double(ckA) + b, 255 )  );
            ckB = uint8(  bitand( double(ckB) + double(ckA), 255 )  );
          end
        
          % received bytes
          recvA = pkt(lastIdx+1);
          recvB = pkt(lastIdx+2);
        
          if ckA~=recvA || ckB~=recvB
            warning('UBX:Checksum',...
              'Computed [0x%02X 0x%02X], got [0x%02X 0x%02X]', ...
              ckA, ckB, recvA, recvB);
            valid = false;
          else
            valid = true;
          end
      else 
          valid = false;
      end
  else
    valid = false;
  end
end
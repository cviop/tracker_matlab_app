function [acc, gyro, mag] = readTrackerRawData(s)
    

    send_data(s, 3)
    out = read(s, 9, 'single');
    
    acc = out(1:3);
    gyro = out(4:6);
    mag = out(7:9);

end
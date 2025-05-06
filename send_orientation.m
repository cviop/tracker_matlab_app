function send_orientation(s, data)
    if numel(data) == 3
        azimuth = data(1);
        elevation = data(2);
        polarisation = data(3);
        send_data(s,12)
        write(s,[azimuth elevation polarisation], "single")
        disp("")
    else
        fprintf("Wring number of elements in message")
    end
end
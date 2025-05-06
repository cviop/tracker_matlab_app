



angle_increments = 10;
delay_betweens_steps = 2;


for angle = 0:angle_increments:360
    disp("sending")
    disp(angle)
    
    send_orientation(s, [0, 0, angle])
    disp("...")
end


for angle = 360:-angle_increments:0
    disp("sendingmot")
    send_orientation(s, [angle, 0, 0])
    disp("...")
    %%pause(delay_betweens_steps)
end
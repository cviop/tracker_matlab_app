function motors_on(s)

    send_data(s, 14)
    write(s, [1 0 0 0 0 0 0 0 0 0 0 0], 'uint8')
    pause(0.1)
    send_data(s, 14)
    write(s, [0 0 0 0 1 0 0 0 0 0 0 0], 'uint8')
    pause(0.1)
    send_data(s, 14)
    write(s, [0 0 0 0 0 0 0 0 1 0 0 0], 'uint8')
    pause(0.1)

end


function send_data(s, output_msg)
    %fprintf("msg: %s, value: %f\n", dec2bin(output_msg(1)), typecast(uint8(output_msg(2:5)), 'single'))
    write(s, [168 output_msg], "uint8");
end
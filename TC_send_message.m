function TC_send_message(s, output_msg)
    %fprintf("msg: %s, value: %f\n", dec2bin(output_msg(1)), typecast(uint8(output_msg(2:5)), 'single'))
    write(s, [168 output_msg], "uint8");
end
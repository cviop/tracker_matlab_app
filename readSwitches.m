function [sw1_on, sw2_on, sw3_on] = readSwitches(s)

    TC_send_message(s,8)
    out = read(s, 3, "uint8");

    sw1_on = ~out(1);
    sw2_on = ~out(2);
    sw3_on = ~out(3);

end
function motors_off(s)

    send_data(s, 13)
    write(s, [1 0 0 0 0 0 0 0 0 0 0 0], 'uint8')
    pause(0.2)
    send_data(s, 13)
    write(s, [0 0 0 0 1 0 0 0 0 0 0 0], 'uint8')
    pause(0.2)
    send_data(s, 13)
    write(s, [0 0 0 0 0 0 0 0 1 0 0 0], 'uint8')
    pause(0.2)
end



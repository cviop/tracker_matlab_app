function motors_clear_errors(s)
    send_data(s, 15)
    write(s, [1 0 0 0 0 0 0 0 0 0 0 0], 'uint8')
    send_data(s, 15)
    write(s, [0 0 0 0 1 0 0 0 0 0 0 0], 'uint8')
    send_data(s, 15)
    write(s, [0 0 0 0 0 0 0 0 1 0 0 0], 'uint8')
end
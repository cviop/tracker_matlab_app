function turn_on_motor(s, motorID)
    switch motorID
        case 1
        send_data(s, 14)
        write(s, [1 0 0 0 0 0 0 0 0 0 0 0], 'uint8')
        case 2
        send_data(s, 14)
        write(s, [0 0 0 0 1 0 0 0 0 0 0 0], 'uint8')
        case 3
        send_data(s, 14)
        write(s, [0 0 0 0 0 0 0 0 1 0 0 0], 'uint8')
    end
end
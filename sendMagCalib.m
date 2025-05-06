function sendMagCalib(s, A, b)
    send_data(s, 11)
    if(numel(A) == 9 && numel(b) == 3)
        write(s,[A(1:9) b(1:3)], "single");
    else
        fprintf("Wrong input data size\n")
    end
end
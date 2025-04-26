function s = TC_connect(port)
    
    %port = "COM13";  % Change this to match your system
    baudrate = 921600;
    
    s = serialport(port, baudrate);
end
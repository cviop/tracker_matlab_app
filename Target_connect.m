function s = Target_connect(port)
    
    %port = "COM13";  % Change this to match your system
    baudrate = 9600;
    
    s = serialport(port, baudrate);
end
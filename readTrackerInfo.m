function [TrackerInfoMsg, valid] = readTrackerInfo(s)
    
    [TrackerInfoMsg.phirad,TrackerInfoMsg.thetarad, TrackerInfoMsg.psirad, valid] = get_OPU_angles(s);

end


% function get_OPU_raw(s)
%     send_data(s, 3)
% 
%     out = read(s, 9, 'single');
% end

function [phi, theta, psi, valid] =  get_OPU_angles(s)
   
    send_data(s, 2)
    sync_bytes = read(s,2,"uint8");
    lastwarn('', '');
    try
    out = read(s, 3, 'single');
    if sync_bytes(1) == 111 && sync_bytes(2) == 180
        phi = out(1);
        theta = out(2);
        psi = out(3);
        valid = true;
    else
        phi = 0; theta = 0; psi = 0;
        valid = false;
    end
    catch
        send_data(s, 18);
        pause(1)
    end
    [~, warnId] = lastwarn();
    if(isempty(warnId))
    
    else
        send_data(s, 18);
        pause(1)
    end
end


function send_data(s, output_msg)
    %fprintf("msg: %s, value: %f\n", dec2bin(output_msg(1)), typecast(uint8(output_msg(2:5)), 'single'))
    write(s, [168 output_msg], "uint8");
end



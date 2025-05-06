function [b, A] = computeMagCal(s, nrun)

%C:\Users\kubic\Documents\GitHub\tracker_matlab_app

%% Parameters, buffers init
%nrun = 20e3;
run_remain = nrun;

lim3Dplot = 1000;
% clear nuc
% nuc = serialport("COM6", 921600);
 
% 

magX_buffer = NaN(1,nrun);
magY_buffer = NaN(1,nrun);
magZ_buffer = NaN(1,nrun);

magX_buffer_cal = NaN(1,nrun);
magY_buffer_cal = NaN(1,nrun);
magZ_buffer_cal = NaN(1,nrun);

C = NaN(nrun, 3);
magLen_buffer = NaN(1,nrun);

%% Plot 1 - basic rolling graph xyz
figure(1)
tiledlayout(2,1)
nexttile
xplot = plot(1:nrun,magX_buffer(1:nrun));
hold on
yplot = plot(1:nrun,magY_buffer(1:nrun));
zplot = plot(1:nrun,magZ_buffer(1:nrun));
lenplot = plot(1:nrun,magLen_buffer(1:nrun), LineWidth=1);
hold off
legend(["M_x" "M_y" "M_z" "Length"])
xlabel("Samples")
ylabel("B / mG")
title("Uncalibrated magnetic flux density B")
ylim([-500 500])
grid on 
grid minor

nexttile
xplot_cal = plot(1:nrun,magX_buffer(1:nrun));
hold on
yplot_cal = plot(1:nrun,magY_buffer(1:nrun));
zplot_cal = plot(1:nrun,magZ_buffer(1:nrun));
lenplot_cal = plot(1:nrun,magLen_buffer(1:nrun), LineWidth=1);
hold off
legend(["M_x" "M_y" "M_z" "Length"])
xlabel("Samples")
ylabel("B / mG")
title("Calibrated magnetic flux density B")
ylim([-500 500])
grid on 
grid minor


%% Plot 2 - 3D position based on values
figure()
plot3D_data = plot3(magX_buffer, magY_buffer, magZ_buffer, ...
    "LineStyle","none","Marker","X","MarkerSize",4);
xlabel("X / mG");ylabel("Y / mG");zlabel("Z / mG")
hold on
plot3D_data_cal = plot3(magX_buffer_cal, magY_buffer_cal, magZ_buffer_cal, ...
    "LineStyle","none","Marker","X","MarkerSize",8);
grid on

% XZ proj
plotXZ_shadow = plot3(magX_buffer, lim3Dplot*ones(1,numel(magY_buffer)), magZ_buffer);
% XY proj
plotXY_shadow = plot3(magX_buffer, magY_buffer, -lim3Dplot*ones(1,numel(magZ_buffer)));
%ZY
plotZY_shadow = plot3(lim3Dplot*ones(1,numel(magX_buffer)), magY_buffer, magZ_buffer);
axis("equal")
xlim([-lim3Dplot lim3Dplot])
ylim([-lim3Dplot lim3Dplot])
zlim([-lim3Dplot lim3Dplot])
grid on
grid minor
axis("vis3d")
hold off
legend(["Raw data" "Calibrated data"], "Location","best")

%% Get data

drawnow
flush(s)
while(run_remain)
    flush(s)
    data = get_OPU_raw(s);
    pause(10e-3)
    magXact = data(7);
    magYact = data(8);
    magZact = data(9);
    magLenAct = sqrt((double(magXact)^2)+(double(magYact)^2)+(double(magZact)^2));

    %%fprintf("raw: %d %d %d %d %d %d, Mx: %d, My: %d, Mz: %d\n", data, magXact, magYact, magZact)
    if(abs(magXact)<2000 && abs(magYact)<2000 && abs(magZact)<2000)
        magX_buffer = circshift(magX_buffer, 1,2);
        magX_buffer(1) = magXact;
        magY_buffer = circshift(magY_buffer, 1,2);
        magY_buffer(1) = magYact;
        magZ_buffer = circshift(magZ_buffer, 1,2);
        magZ_buffer(1) = magZact;
        magLen_buffer = circshift(magLen_buffer, 1, 2);
        magLen_buffer(1) = magLenAct;
        run_remain = run_remain-1;
        clc
        fprintf("run %d / %d\n", nrun - run_remain, nrun)
    else
        disp("mag field too strong!")
    end

    %% Real time figure update
    
    
    
    plot3D_data.XData = magX_buffer;
    plot3D_data.YData = magY_buffer;
    plot3D_data.ZData = magZ_buffer;
    
    
    
    
end



% Calibration
D = [magX_buffer',magY_buffer',magZ_buffer'];

[A, b, exmfs] = magcal(D, "sym");


C = (D-b)*A;

magX_buffer_cal = real(C(:,1)');
magY_buffer_cal = real(C(:,2)');
magZ_buffer_cal = real(C(:,3)');
magLen_buffer_cal = sqrt((magX_buffer_cal.^2)+(magY_buffer_cal.^2)+(magZ_buffer_cal.^2));


disp("Calibrating");
disp(b)
disp(A)

disp([A(1:end) b(1:end)])

xplot.YData = magX_buffer(1:nrun);
    yplot.YData = magY_buffer(1:nrun);
    zplot.YData = magZ_buffer(1:nrun);
    lenplot.YData = magLen_buffer(1:nrun);
    
plotXZ_shadow.XData = magX_buffer;
    plotXZ_shadow.ZData = magZ_buffer;
    
    plotXY_shadow.XData = magX_buffer;
    plotXY_shadow.YData = magY_buffer;
    
    plotZY_shadow.YData = magY_buffer;
    plotZY_shadow.ZData = magZ_buffer;

 
%% Update 3D plot with callibrated sphere

plot3D_data_cal.XData = magX_buffer_cal;
plot3D_data_cal.YData = magY_buffer_cal;
plot3D_data_cal.ZData = magZ_buffer_cal;



xplot_cal.YData = magX_buffer_cal;
yplot_cal.YData = magY_buffer_cal;
zplot_cal.YData = magZ_buffer_cal;
lenplot_cal.YData = magLen_buffer_cal;

%%fprintf("%f\n", sqrt(double(magXact)^2+double(magZact)^2+double(magZact)^2))
%pause(0.001)


    % plots update
   
 end


function out = get_OPU_raw(s)
    send_data(s, 3)
    out = read(s, 9, 'single');
end

function send_data(s, output_msg)
    %fprintf("msg: %s, value: %f\n", dec2bin(output_msg(1)), typecast(uint8(output_msg(2:5)), 'single'))
    write(s, [168 output_msg], "uint8");
end


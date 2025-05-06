function startCalibrationProcedure(s)

    send_orientation(s, [0, 0, 0])
    pause(5)
    sendMagCalib(s, [1.1233   -0.1195    0.0332   -0.1195    1.1686    0.1348    0.0332    0.1348    0.7877 ],[  21.5510 -160.1079  209.3474])

    trackerElevationAlignment(s)

    trackerNorthAlignment(s,10)

    send_orientation(s, [0,0,0])
    pause(5)

end
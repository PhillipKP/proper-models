


des_pv = 0.0040

TrialNum_Start = 100
TrialNum_Stop = 100

disp(['Simulating Browning Motion on All Actuators for PV (Volts): ', num2str(des_pv), '']);
disp(['Starting Trial Number: ', num2str(TrialNum_Start),'']);
disp(['Stopping Trial Number: ', num2str(TrialNum_Stop),'']);

disp('Paused for 10 Seconds...')
pause(10)



for InputTrialNum = TrialNum_Start:TrialNum_Stop
    
    [~] = phil_drift_sim(3,InputTrialNum,des_pv,10)    
   
end
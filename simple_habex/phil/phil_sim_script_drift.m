
clear all; close all; clc;

des_std = 0.00035

TrialNum_Start = 500
TrialNum_Stop = TrialNum_Start + 99

drift_type = 'std'

switch drift_type
    case 'pv'
        disp(['Simulating Browning Motion on All Actuators for PV (Volts): ', num2str(des_pv), '']);
    case 'std'
        disp(['Simulating Browning Motion on All Actuators for Std (Volts): ', num2str(des_std), '']);
end

disp(['Starting Trial Number: ', num2str(TrialNum_Start),'']);
disp(['Stopping Trial Number: ', num2str(TrialNum_Stop),'']);

disp('Launching...')

for InputTrialNum = TrialNum_Start:TrialNum_Stop
    
    [~] = phil_drift_sim(3, InputTrialNum, 10, 'std', des_std)
   
end

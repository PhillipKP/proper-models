 
%amplitudeVec = 0.0000:0.0001:0.0010

%count1 = 1

amplitude = 0.0008

TrialNum_Start = 1125
TrialNum_Stop = TrialNum_Start+100

disp(['Simulating Periodic Noise on All Actuators for Amplitude (Volts): ', num2str(amplitude), '']);
disp(['Starting Trial Number: ', num2str(TrialNum_Start),'']);
disp(['Stopping Trial Number: ', num2str(TrialNum_Stop),'']);

disp('Paused for 10 Seconds...')
pause(10)

for InputTrialNum = TrialNum_Start:TrialNum_Stop

    %amplitude = amplitudeVec(count1);
    
    
    [run] = phil_periodic_sim_all_act(2, InputTrialNum, amplitude, 'computeDelta',true, 'num_trials', 10);
    
    %count1 = count1 + 1;

end
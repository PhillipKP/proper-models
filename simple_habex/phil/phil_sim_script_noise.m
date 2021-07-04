 
noiseStdVec = 0.0001 : 0.0001 : 0.0015

count1 = 1

for InputTrialNum = 30:44

    noise_std = noiseStdVec(count1);
    
    
    run = phil_noise_sim(2, InputTrialNum, noise_std, 'vtoh', 10e-9, 'num_trials', 100, 'computeDelta', true);
    
    count1 = count1 + 1;

end
 
noiseStdVec = 0.016:0.001:0.025

count1 = 1

for InputTrialNum = 15:24

    noise_std = noiseStdVec(count1);
    
    [run] = phil_noise_sim(2, InputTrialNum, noise_std);
    count1 = count1 + 1;

end
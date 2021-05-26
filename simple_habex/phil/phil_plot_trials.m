Nitr = 5
Ntrials = 100

if isunix && ~ismac
    addpath('/home/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/')
elseif ismac
    addpath('/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/')
end
    
clear ni_temp;
ni_temp = [];
for trial = 1:Ntrials
    
     trial_padded = sprintf( '%04d', trial ) 
     
     filename = ['Series0001_Trial', trial_padded, ...
         '_vortex_simple_2DM64_z0.32_IWA2_OWA26_1lams550nm_BW1_gridsearchEFC_all.mat']
     
     load(filename)
     
     ni_temp = [ni_temp; out.InormHist.'];
     

end

close all
figure;

for trial = 1:Ntrials
    semilogy(1:Nitr, ni_temp(trial,1:Nitr),'-o','linewidth',3)
    hold all
end
hold off
grid on;

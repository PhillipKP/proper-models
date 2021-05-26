% This script loops the falco_main_Habex_VC script

clearvars

% Calls falco_main_Habex_VC
SeriesNum = 001;

num_stuck_in_row = 5
num_isolated_acts = 3
allincol = true



% dm1.pinned = [];
% dm1.Vpinned = [];
%
% dm2.pinned = [];
% dm2.Vpinned = [];


addpath('/home/poon/dst_sim/proper-models/simple_habex/phil')


Nitr = 5

for TrialNum = 1:100
    
    [dm1, dm2] = phil_gen_stuck_acts(num_stuck_in_row, num_isolated_acts, allincol);
    
    
    disp(dm1.pinned)
    disp(dm1.Vpinned)
    disp(dm2.pinned)
    disp(dm2.Vpinned)
    
    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
    close all
    
end


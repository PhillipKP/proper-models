% This script loops the falco_main_Habex_VC script

clearvars

%- The following variables are for monte carlo simulations

% The series number to save the mat files under
SeriesNum = 000;
% Number of random trials to run in this series
num_trials = 1


%- FALCO specific variables

% Number of WFSC loops to run each trial
Nitr = 5


%- The following variables are used in the random stuck actuator generator

% Number of actuators stuck in a column or a row
num_stuck_in_row = 5

% Number of actuators across the DM
Nact = 64

% If you want the stuck acts in a row or column
bool_allincol = false
% If you want see the pinned/stuck/railed actuators we generated
bool_figson = true

% Number of stuck actuators that are by themselves
num_isolated_acts = 3
%


%- Add paths depending on which computer you are on
if ismac
    path_to_phil = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/phil'
elseif (isunix && ~ismac) % for s383 computers
    path_to_phil = '/home/poon/dst_sim/proper-models/simple_habex/phil'
end
addpath(path_to_phil)



for TrialNum = 2
 
    
    [dm1, dm2] = phil_gen_stuck_acts(Nact, num_stuck_in_row, ...
        num_isolated_acts, bool_allincol, bool_figson);
    
%     disp(dm1.pinned)
%     disp(dm1.Vpinned)
%     disp(dm2.pinned)
%     disp(dm2.Vpinned)

    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
    close all
    
end


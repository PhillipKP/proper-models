% This script loops the falco_main_Habex_VC script

clearvars

%- The following variables are for monte carlo simulations
SeriesNum = 0000;


% Number of random trials to run in this series
num_trials = 1

%% Generate the pinned actuators indices dm1.pinned and pinned actuator
% voltages dm1.Vpinned from a saved file instead of randomly generating
% them


% Load pinned actuators from previous file
load_prev = true

% The series number of the mat files
SavedFile_SeriesNum = 0000;

% The trial number of the mat files
SavedFile_TrialNum = 0005;

file_prefix = ['Series', num2str(SavedFile_SeriesNum,'%04.f'),...
    '_Trial',num2str(SavedFile_TrialNum,'%04.f')];

file_postfix = '_vortex_simple_2DM64_z0.32_IWA2_OWA26_1lams550nm_BW1_gridsearchEFC_all.mat';
if (~ismac) && (isunix)
    path_to_ws = '/home/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/';
end

% This is the file that will be loaded
full_file_path = [path_to_ws, file_prefix, file_postfix];


%% FALCO specific variables

% Number of WFSC loops to run each trial
Nitr = 5

%- The following variables are used in the random stuck actuator generator

% Number of actuators stuck in a column or a row
num_stuck_in_row = 0

% Number of actuators across the DM
Nact = 64

% If you want the stuck acts in a row or column
bool_allincol = false
% If you want see the pinned/stuck/railed actuators we generated
bool_figson = true

% Number of stuck actuators that are by themselves
%num_isolated_acts = 3526
%
num_isolated_acts = 500


%- Add paths depending on which computer you are on
if ismac
    path_to_phil = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/phil'
elseif (isunix && ~ismac) % for s383 computers
    path_to_phil = '/home/poon/dst_sim/proper-models/simple_habex/phil'
end
addpath(path_to_phil)


for TrialNum = 11
    
    if load_prev
        
        % Uses the exact same pinned actuators and voltages from a
        % previously saved file

        
        load(full_file_path);
        
        dm1.pinned = mp.dm1.pinned;
        dm1.Vpinned = mp.dm1.Vpinned;
        dm2.pinned = mp.dm2.pinned;
        dm2.Vpinned = mp.dm2.Vpinned;
        
        clearvars -except dm1 dm2 SeriesNum TrialNum Nitr
        
    else
        
        % Randomly generates the pinned actuators
        % This function currently only does it for DM1
        
        [dm1, dm2] = phil_gen_stuck_acts(Nact, num_stuck_in_row, ...
            num_isolated_acts, bool_allincol, bool_figson);
    end
    
    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
end

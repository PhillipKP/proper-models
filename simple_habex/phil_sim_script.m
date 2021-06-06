% This script loops the falco_main_Habex_VC script

clearvars

%- The following variables are for monte carlo simulations
SeriesNum = 0000;


% Number of random trials to run in this series
num_trials = 1

% Number of actuators across the DM
Nact = 64

%% The following variables are used in the random stuck actuator generator

% Number of actuators pinned in a column or a row
dm1_num_pinned_in_row = 0
dm2_num_pinned_in_row = 0

% Number of isolated pinned actuators to randomly generate
dm1_num_isolated_pinned_acts = 100
dm2_num_isolated_pinned_acts = 0


% Number of actuators railed in a column or a row
dm1_num_railed_in_row = 0
dm2_num_railed_in_row = 0

% Number of isolated railed actuators to randomly generate
dm1_num_isolated_railed_acts = 0
dm2_num_isolated_railed_acts = 0

% If you want the stuck acts in a row or column
bool_allincol = false

% If you want see the pinned/stuck/railed actuators we generated
bool_figson = true

%% Generate the pinned actuators indices dm1.pinned and pinned actuator
% voltages dm1.Vpinned from a saved file instead of randomly generating
% them

% Load pinned actuators from previous file
% If false will randomly generate the stuck actuators
load_prev_dm1 = false
load_prev_dm2 = false


% dm1.pinned and dm1.Vpinned and dm2.pinned and dm2.Vpinned can be loaded
% from seperate files

% The series number of the mat files
SavedFile_SeriesNum_dm1 = 0000;
% The trial number of the mat files
SavedFile_TrialNum_dm1 = 0005;


SavedFile_SeriesNum_dm2 = 0000;
% The trial number of the mat files
SavedFile_TrialNum_dm2 = 0005;


file_prefix_dm1 = ['Series', num2str(SavedFile_SeriesNum_dm1,'%04.f'),...
    '_Trial',num2str(SavedFile_TrialNum_dm1,'%04.f')];

file_prefix_dm2 = ['Series', num2str(SavedFile_SeriesNum_dm2,'%04.f'),...
    '_Trial',num2str(SavedFile_TrialNum_dm2,'%04.f')];


file_postfix = ...
    '_vortex_simple_2DM64_z0.32_IWA2_OWA26_1lams550nm_BW1_gridsearchEFC_all.mat';

if (~ismac) && (isunix)
    path_to_ws = ...
        '/home/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/';
elseif ismac
    path_to_ws = ...
        '/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/';
end


% This is the file that will be loaded
full_file_path_dm1 = [path_to_ws, file_prefix_dm1, file_postfix];
full_file_path_dm2 = [path_to_ws, file_prefix_dm2, file_postfix];

%% FALCO specific variables

% Number of WFSC loops to run each trial
Nitr = 5





%- Add paths depending on which computer you are on
if ismac
    path_to_phil = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/phil'
elseif (isunix && ~ismac) % for s383 computers
    path_to_phil = '/home/poon/dst_sim/proper-models/simple_habex/phil'
end
addpath(path_to_phil)


for TrialNum = 16
    
    % Either load an old file for dm1.pinned and dm1.Vpinned or generate 
    % a random list of stuck actuators
    if load_prev_dm1
        % load prev file
        
        load(full_file_path_dm1,'mp')
        
        dm1.pinned = mp.dm1.pinned;
        dm1.Vpinned = mp.dm1.Vpinned;
        
        clear mp
        
    else
        % generate random dm1.pinned
        % generate random dm2.pinned
        dm1 = phil_gen_stuck_acts(Nact, dm1_num_pinned_in_row, ...
            dm1_num_isolated_pinned_acts, bool_allincol, bool_figson, 1);
    end
    
    
    % Either load an old file for dm2.pinned and dm2.Vpinned or generate 
    % a random list of stuck actuators
    if load_prev_dm2
        
        % load prev file
        load(full_file_path_dm2,'mp') %#ok<UNRCH>
        dm2.pinned = mp.dm2.pinned;
        dm2.Vpinned = mp.dm2.Vpinned;
        
        clear mp
        
    else
        
        % generate random dm2.pinned
        dm2 = phil_gen_stuck_acts(Nact, dm2_num_pinned_in_row, ...
            dm2_num_isolated_pinned_acts, bool_allincol, bool_figson, 1);
    end
    
    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
end

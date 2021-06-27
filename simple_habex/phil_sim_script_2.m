%phil_sim_script_2


clearvars

%- The following variables are for monte carlo simulations
SeriesNum = 0001;

Nitr = 30;

sim_type = 'scheduled'

num_isolated_pinned_acts = 1;

save_dir = 'pinned_scheduled'
controller = 'plannedEFC'
%controller = 'gridsearchEFC'

bw = 0.10;
nsbp = 3;
nwpsbp = 3;

% Generate 10 random actuator locations
switch lower(sim_type)
    
    case {'scheduled'}
        
        % A scheduled sim_type means we will always select the same
        % actuator locations in order of their index
        
        dm1.schedule = [3172 3549 685 3574 2512 557 1265 2209 3799 3824]
        dm2.schedule = [812  3877 3804 1994 3113 747 1769 3594 3081 3805]
        
    case {'scheduled_2'}
        
        dm1.schedule = [2069 2749 3483 3810 2212 736 782 1190 3270 1178]
        dm2.schedule = [2592 842 662 2041 3808 1487 2344 1070 2926 1184]
        
        
    case {'no_stuck_acts'}
        
        dm1.pinned = []
        dm2.pinned = []
        
end


count1 = 1


for TrialNum = 22:26
    
    if contains(sim_type,'scheduled')
        dm1.pinned = dm1.schedule(1:count1)
        dm2.pinned = dm2.schedule(1:count1)
    end
    
    if strcmp(sim_type,'random_pinned_iso_acts')
        dm1 = phil_gen_stuck_acts(64, 0, num_isolated_pinned_acts, 0, true, 200, false, 1);
        dm2 = phil_gen_stuck_acts(64, 0, num_isolated_pinned_acts, 0, true, 200, false, 2);
        dm1 = rmfield(dm1,'Vpinned');
        dm2 = rmfield(dm2,'Vpinned');
    end
    
    % Actually runs falco
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, ...
        dm2, controller, save_dir, bw, nsbp, nwpsbp);
    disp(dm1.pinned)
    disp(dm2.pinned)
   
    
    close all;
    
    count1 = count1 + 1;
    
    
end

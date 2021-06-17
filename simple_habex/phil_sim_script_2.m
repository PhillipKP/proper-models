%phil_sim_script_2


clearvars

%- The following variables are for monte carlo simulations
SeriesNum = 0000;

Nitr = 11;

sim_type = 'scheduled'



% Generate 10 random actuator locations
switch lower(sim_type)
    
    case {'scheduled'}
        
        % A scheduled sim_type means we will always select the same
        % actuator locations in order of their index
        
        dm1.schedule = [3172 3549 685 3574 2512 557 1265 2209 3799 3824]
        dm2.schedule = [812  3877 3804 1994 3113 747 1769 3594 3081 3805]
        
    case {'no_stuck_acts'}
        
        dm1.pinned = []
        dm2.pinned = []
        
 
end


count1 = 1


for TrialNum = 120:124
    
    if strcmp( sim_type, 'scheduled')
        dm1.pinned = dm1.schedule(1:count1)
        dm2.pinned = dm2.schedule(1:count1)
    end
    
    % Actually runs falco
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
    close all;
    
    count1 = count1 + 1;
    
    
end

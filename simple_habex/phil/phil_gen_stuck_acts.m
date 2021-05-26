
function [dm1, dm2] = phil_gen_stuck_acts(num_stuck_in_row, num_isolated_acts, allincol)

% Inputs:
% num_stuck_in_row = 5,
% allincol = true, means it will put the stuck actuators in a vertical
% column on the DM
% allincol = false, means it will put the stuck actuators in a horizontal
% row on the DM


Nact = 64;


% Load the actuators in the beam. This data is generated from the
% falco_cull_weak_actuators
% When using s383 computers
if (isunix && ~ismac)
    dm1_act_ele_path = '/home/poon/dst_sim/proper-models/simple_habex/'
    dm2_act_ele_path = '/home/poon/dst_sim/proper-models/simple_habex/'
end

dm1_act_ele_path_full = [dm1_act_ele_path, 'dm1_act_ele.mat']
dm2_act_ele_path_full = [dm2_act_ele_path, 'dm2_act_ele.mat']



dm1_act_ind_in_beam_struct = load(dm1_act_ele_path_full);
dm2_act_ind_in_beam_struct = load(dm2_act_ele_path_full);

% Detact from the struct to make the code easier to read
dm1_act_ind_in_beam = dm1_act_ind_in_beam_struct.dm1_act_ele;
dm2_act_ind_in_beam = dm2_act_ind_in_beam_struct.dm2_act_ele;

dm1_act_mask = zeros(Nact^2,1);
dm2_act_mask = zeros(Nact^2,1);

dm1_act_mask(dm1_act_ind_in_beam) = 1;
dm2_act_mask(dm2_act_ind_in_beam) = 1;


figure;
imagesc(reshape(dm1_act_mask, [Nact Nact]));
title('DM1 Actuators in Beam')

figure;
imagesc(reshape(dm2_act_mask, [Nact Nact]));
title('DM2 Actuators in Beam')

loop_flag = true;

while loop_flag == true
    
    
    dm1.pinned = [];
    dm1.Vpinned = [];
    dm2.pinned = [];
    dm2.Vpinned = [];
    
    if num_stuck_in_row > 0
        [dmm_ind] = phil_gen_stuck_acts_in_rows(Nact, num_stuck_in_row, allincol );
        
        dm1.pinned = dmm_ind;
        dm1.Vpinned = zeros(size(dmm_ind));
    end
    
    if num_isolated_acts > 0
        dm1.pinned  = [ dm1.pinned; randi(64^2,[num_isolated_acts 1] ) ]
        dm1.Vpinned = [ dm1.Vpinned; zeros([[num_isolated_acts 1]])]
    end
    
    % Check if all the pinned actuators are actually inside the beam
    % If they are it will stop looping
    
    if all( ismember(dm1.pinned, dm1_act_ind_in_beam) )
        
        dm1_act_mask(dm1.pinned) = dm1.Vpinned;
        
        figure;
        imagesc(reshape(dm1_act_mask, [Nact Nact]));
        axis equal; axis tight;
        
        title('DM1 Pinned Acts in Beam');
        
        loop_flag = false;
        
    end
    
end

% Transpose to be consistent with FALCO
dm1.pinned = transpose( dm1.pinned );
dm1.Vpinned = transpose( dm1.Vpinned );

dm2.pinned = transpose( dm2.pinned );
dm2.Vpinned = transpose( dm2.Vpinned );


end
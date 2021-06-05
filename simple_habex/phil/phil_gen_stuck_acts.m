
function [dm] = phil_gen_stuck_acts(Nact, num_stuck_in_row, ...
    num_isolated_acts, allincol, bool_figson, dm_num)

% Inputs:
% Nact: Number of actuators in a row and column of the DM.
% num_stuck_in_row = 5,
% allincol = true, means it will put the stuck actuators in a vertical
% column on the DM
% allincol = false, means it will put the stuck actuators in a horizontal
% row on the DM




%- Load the actuators in the beam. This data is generated from the
% falco_cull_weak_actuators


[dm_act_mask,dm_act_ind_in_beam] = phil_gen_actuators_in_beam(Nact, bool_figson, dm_num);

loop_flag = true;


% Starts with a blank array
dm.pinned = [];
dm.Vpinned = [];


if (num_stuck_in_row > 0) || (num_isolated_acts > 0)
    
    while loop_flag == true
        
        if num_stuck_in_row > 0
            
            % Function randomly picks a row and column and generates a list of
            % actuators that are all stuck
            [dmm_ind] = phil_gen_stuck_acts_in_rows(Nact, num_stuck_in_row, ...
                allincol );
            
            % Assign the indices to dm1.pinned
            dm.pinned = dmm_ind;
            dm.Vpinned = zeros(size(dmm_ind));
            
        end
        
        if num_isolated_acts > 0
            
            
            % Check if all the pinned actuators are actually inside the beam
            % If they are it will stop looping
            
            msize = numel(dm_act_ind_in_beam);
            iso_act_ind = dm_act_ind_in_beam(randperm(msize, num_isolated_acts));
            
            if all( ismember(iso_act_ind, dm_act_ind_in_beam) )
                
                dm.pinned  = [ dm.pinned; iso_act_ind ];
                dm.Vpinned = [ dm.Vpinned; zeros([num_isolated_acts 1]) ];
                
                dm_act_mask(dm.pinned) = dm.Vpinned;
                
                if bool_figson
                    figure;
                    imagesc(reshape(dm_act_mask, [Nact Nact]));
                    axis equal; axis tight;
                    
                    
                    title(['DM', num2str(dm_num), ' Pinned Acts in Beam']);
 
                end
                
                loop_flag = false;
                
            end
            
        end
        
    end
    
    
    
end

% Transpose to be consistent with FALCO
dm.pinned = transpose( dm.pinned );
dm.Vpinned = transpose( dm.Vpinned );



end
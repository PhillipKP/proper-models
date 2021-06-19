
function [dm] = phil_gen_stuck_acts(Nact, num_pinned_in_row, ...
     num_isolated_pinned_acts, num_isolated_railed_acts, allincol, ...
    rail_V, bool_figson, dm_num)

% Inputs:
%
% Nact: Number of actuators in a row and column of the DM.
%
% num_pinned_in_row = 5,
%
% allincol = true, means it will put the stuck actuators in a vertical
% column on the DM, false, means it will put the stuck actuators in a horizontal
%
% rail_V = The voltage which railed actuators should be set to.

%- Telling the user how many of each stuck actuator type is being generated
disp(' ')
disp( '-Generating Pinned and Railed Actuator Locations.')
disp(['-For DM ', num2str(dm_num), '. With ', num2str(Nact), 'X', num2str(Nact),' actuators on the DM'])
disp(['-Generating ', num2str(num_isolated_pinned_acts), ' isolated pinned actuators. Pinned at ', num2str(0), ' volts.'])
if allincol
    disp(['-Generating ', num2str(num_pinned_in_row), ' pinned actuators in a column. Pinned at ', num2str(0), ' volts.'])
else
    disp(['-Generating ', num2str(num_pinned_in_row), ' pinned actuators in a row. Pinned at ', num2str(0), ' volts.'])
end
disp(['-Generating ', num2str(num_isolated_railed_acts), ' isolated railed actuators. Railed at ', num2str(rail_V), ' volts.'])


%- Starts with a blank array
dm.pinned = [];
dm.Vpinned = [];



if (num_pinned_in_row + num_isolated_pinned_acts + num_isolated_railed_acts) > 0 
    
    %- Load a *.mat file with the actuators in the beam. This data is generated from the
    % falco_cull_weak_actuators
    % dm_act_mask is a Nact^2, 1 matrix of bools
    % dm_act_ind_in_beam, is a list of actuators indices in the beam
    [dm_act_mask, dm_act_ind_in_beam] = phil_gen_actuators_in_beam(Nact, bool_figson, dm_num);
 
     
     if (num_pinned_in_row) > 0
        
        % Function randomly picks a row and column and generates a list of
        % actuators that are all stuck
        [dmm_ind] = phil_gen_stuck_acts_in_rows(Nact, num_pinned_in_row, ...
            allincol );
        
        % Assign the indices to dm1.pinned
        dm.pinned = [dm.pinned; dmm_ind];
        dm.Vpinned = [dm.Vpinned; zeros(size(dmm_ind))];
        
     end
    
    
    if (num_isolated_pinned_acts + num_isolated_railed_acts) > 0
        
        
        
        if num_isolated_pinned_acts > 0 && num_isolated_railed_acts == 0
            
            list = phil_pick_rand_from_list(dm_act_ind_in_beam, num_isolated_pinned_acts);
            
            dm.pinned = [dm.pinned; list];
            dm.Vpinned = [dm.Vpinned; zeros(size(list))];
            
            dm_act_mask(dm.pinned) = dm.Vpinned;
            
            
        elseif num_isolated_pinned_acts == 0 && num_isolated_railed_acts > 0
            
            list = phil_pick_rand_from_list(dm_act_ind_in_beam, num_isolated_railed_acts);
            
            dm.pinned = [dm.pinned; list];
            dm.Vpinned = [dm.Vpinned; rail_V*ones(size(list))];
            
            dm_act_mask(dm.pinned) = dm.Vpinned;
            
            
        elseif num_isolated_pinned_acts > 0 && num_isolated_railed_acts > 0
            
            
            list = phil_pick_rand_from_list(dm_act_ind_in_beam, ...
                num_isolated_pinned_acts + num_isolated_railed_acts);
            
            dm.pinned = [dm.pinned; list];
            
            dm.Vpinned = [dm.Vpinned; ...
                zeros(num_isolated_pinned_acts,1); ...
                rail_V*ones(num_isolated_railed_acts,1)];
            
            dm_act_mask(dm.pinned) = dm.Vpinned;
            
            
        end
        
        
        
        
        
        if bool_figson
            
            title_str = ['DM', num2str(dm_num), ' Pinned and Railed Acts'];
            phil_plot_pinned_actuators(dm, title_str)
            
            
        end
        
        
        
        
    end
    
    
    
    
    
end

% Transpose to be consistent with FALCO
dm.pinned = transpose( dm.pinned );
dm.Vpinned = transpose( dm.Vpinned );



end
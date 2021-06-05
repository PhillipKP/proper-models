function [dm_act_mask,dm_act_ind_in_beam] = ...
    phil_gen_actuators_in_beam(Nact, bool_figson, dm_num)

if ismac
    % Using work macbook
    dm_act_ele_path = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/'
elseif (isunix && ~ismac)
    % Using s383 computers
    dm_act_ele_path = '/home/poon/dst_sim/proper-models/simple_habex/'
end


% Build path all the way to the file
switch dm_num
    case 1
        dm_filename = 'dm1_act_ele.mat'

    case 2
        dm_filename = 'dm2_act_ele.mat'
end

dm_act_ele_path_full = [dm_act_ele_path, dm_filename]


% Load file
dm_act_ind_in_beam_struct = load(dm_act_ele_path_full);


% Detact from the struct to make the code easier to read
switch dm_num
    case 1
        dm_act_ind_in_beam = dm_act_ind_in_beam_struct.dm1_act_ele;
    case 2
        dm_act_ind_in_beam = dm_act_ind_in_beam_struct.dm2_act_ele;
end

% Initial array of zeros
dm_act_mask = zeros(Nact^2,1);

% Set the values to 1 corresponding to those in the beam
dm_act_mask(dm_act_ind_in_beam) = 1;

if bool_figson
    
    figure;
    imagesc(reshape(dm_act_mask, [Nact Nact]));
    title(['DM', num2str(dm_num) ' Actuators in Beam'])
    
    
end

end % Ends the function block


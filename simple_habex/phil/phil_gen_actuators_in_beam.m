function [dm1_act_mask,dm1_act_ind_in_beam, dm2_act_mask, dm2_act_ind_in_beam] = ...
    phil_gen_actuators_in_beam(Nact, bool_figson)

if ismac
    % Using work macbook
    dm1_act_ele_path = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/'
    dm2_act_ele_path = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/'
elseif (isunix && ~ismac)
    % Using s383 computers
    dm1_act_ele_path = '/home/poon/dst_sim/proper-models/simple_habex/'
    dm2_act_ele_path = '/home/poon/dst_sim/proper-models/simple_habex/'
end

% Build path all the way to the file
dm1_act_ele_path_full = [dm1_act_ele_path, 'dm1_act_ele.mat']
dm2_act_ele_path_full = [dm2_act_ele_path, 'dm2_act_ele.mat']

% Load file
dm1_act_ind_in_beam_struct = load(dm1_act_ele_path_full);
dm2_act_ind_in_beam_struct = load(dm2_act_ele_path_full);

% Detact from the struct to make the code easier to read
dm1_act_ind_in_beam = dm1_act_ind_in_beam_struct.dm1_act_ele;
dm2_act_ind_in_beam = dm2_act_ind_in_beam_struct.dm2_act_ele;

% Initial array of zeros
dm1_act_mask = zeros(Nact^2,1);
dm2_act_mask = zeros(Nact^2,1);

% Set the values to 1 corresponding to those in the beam
dm1_act_mask(dm1_act_ind_in_beam) = 1;
dm2_act_mask(dm2_act_ind_in_beam) = 1;

if bool_figson
    
    figure;
    imagesc(reshape(dm1_act_mask, [Nact Nact]));
    title('DM1 Actuators in Beam')
    
    figure;
    imagesc(reshape(dm2_act_mask, [Nact Nact]));
    title('DM2 Actuators in Beam')
end

end % Ends the function block


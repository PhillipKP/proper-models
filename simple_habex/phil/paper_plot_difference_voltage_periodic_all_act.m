clear all
close all
clc

%% Load the original DM1 and DM2 voltages

Itr = 8;
SeriesNum = 2;
TrialNum = 6;
save_dir = 'noise';

itr_name = ['Series', num2str(SeriesNum,'%04.f'), 'Trial', num2str(TrialNum,'%04.f'), '_Itr_', num2str(Itr)];

if ismac
    path_to_file = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
else
    path_to_file = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
end
itr_file = [path_to_file itr_name '.mat'];

load(itr_file,'mp','out');

origDm1V = mp.dm1.V;
origDm2V = mp.dm2.V;
origDm1FlatMap = mp.full.dm1.flatmap;

%% Use falco_gen_dm_surf to generated DM1 and DM2 surface

mpo.dm1.surfM = falco_gen_dm_surf(mp.dm1, mp.dm1.dx, mp.dm1.NdmPad);
mpo.dm2.surfM = falco_gen_dm_surf(mp.dm2, mp.dm2.dx, mp.dm2.NdmPad);

%%

% Generate the random phase


% FOR LOOP over the samples


% Use a sin function to generate added undesired voltage for this sample

% Add voltage to original DM1 and DM2 voltage 


% Use falco_gen_dm_surf to generate the corrupted DM1 and DM2 surface

% Store DM1 and DM2 surface


% Compute the difference between the corrupted DM1 and DM2 surface and the
% original DM1 and DM2 surface


% Plot the DM1 and DM2 surface difference



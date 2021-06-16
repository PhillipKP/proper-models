function [ffpath] = phil_build_full_path(SeriesNum, TrialNum, lams, bw)

file_prefix = ['Series', num2str(SeriesNum,'%04.f'),...
    '_Trial',num2str(TrialNum,'%04.f')];


if lams == 1 && bw == 1
    file_postfix = '_vortex_simple_2DM64_z0.32_IWA2_OWA26_1lams550nm_BW1_gridsearchEFC_all.mat';
elseif lams == 3 && bw == 10
    file_postfix = '_vortex_simple_2DM64_z0.32_IWA2_OWA26_3lams550nm_BW10_gridsearchEFC_all.mat';
end



if (~ismac) && (isunix)
    path_to_ws = '/home/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/';
elseif (ismac)
    path_to_ws = '/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/';
end
% The full file path
ffpath = [path_to_ws, file_prefix, file_postfix];

end
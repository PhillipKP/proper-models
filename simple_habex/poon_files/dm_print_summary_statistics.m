function [] = dm_print_summary_statistics(dm_surf_height)

    disp(['Std  DM Surface Height ', num2str(std(dm_surf_height(:))),  ''])
    disp(['Max  DM Surface Height ', num2str(max(dm_surf_height(:))),  ''])
    disp(['Min  DM Surface Height ', num2str(min(dm_surf_height(:))),  ''])
    disp(['Mean DM Surface Height ', num2str(mean(dm_surf_height(:))), ''])

end
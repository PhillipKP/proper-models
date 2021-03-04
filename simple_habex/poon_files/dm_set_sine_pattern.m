
% This script is used to produce a sinusoidal 64 x 64 DM1 pattern:

function [dm_array] = dm_set_sine_pattern(dm_scale_factor, dm_x_spat_freq)


    x = 1:64;
    y = 1:64;

    [X,~] = meshgrid(x,y);

    dm_array = dm_scale_factor * sin(2*pi*dm_x_spat_freq*X);
    


end
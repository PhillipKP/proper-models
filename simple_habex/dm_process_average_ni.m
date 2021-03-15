% This function loads the fits files into an array and sums them


clearvars; close all; clc;




dm_num_itr = 10;

dm_noise_std = 1e-11;

dm_datapath = '/Users/poon/Documents/DST/proper-models/simple_habex/data/';

dm_ni_mask_radius = 82;

figures_on = false;

% Average the dm_ni_cube




%Saves the normalized intensity as a fits file
dm_temp = fitsread([dm_datapath 'Inorm_trial_' num2str(1) '_sigma_' num2str(dm_noise_std) '.fits']);

size(dm_temp)




[X,Y] = meshgrid( (-size(dm_temp,1)/2 + 1): 1 : ( size(dm_temp,1)/2 ) );
[~,rho] = cart2pol(X,Y);

ni_mask = rho < dm_ni_mask_radius;

if figures_on
    phil_custom_imagesc(ni_mask,'mask');
end



dm_ni_cube = zeros( [size(dm_temp,1) size(dm_temp,2) dm_num_itr] );

size(dm_ni_cube)

for loop_count = 1:dm_num_itr
    
    
    
    %Saves the normalized intensity as a fits file
    Inorm = fitsread([dm_datapath 'Inorm_trial_' num2str(loop_count) '_sigma_' num2str(dm_noise_std) '.fits']);
    
    %dm_ni_cube(:,:,loop_count) =
    
    if figures_on
        phil_custom_imagesc( log10(Inorm) , ...
            {['Normalized Intensity, Noise Std: ' num2str(dm_noise_std) ' '],['Trial ' num2str(loop_count) '']}, 'colorlim',[-7 0] )
    end
    
    dm_ni_cube(:,:,loop_count) = Inorm;
    
    mean ( Inorm(rho < dm_ni_mask_radius) )
    
end


% Average the dm_ni_cube

dm_avg_ni = mean(dm_ni_cube,3);

[X,Y] = meshgrid(1:size(dm_avg_ni,1));

[~,rho] = cart2pol(X,Y);

dm_avg_ni_scalar = mean( dm_avg_ni (rho < dm_ni_mask_radius)  );

mean_ni_str = sprintf('%.2e', dm_avg_ni_scalar)

phil_custom_imagesc( log10( dm_avg_ni .* ni_mask) , {['Mean NI. Averaged over ' num2str(dm_num_itr) ' Realizations'],['Noise Std Dev ' num2str(dm_noise_std) ', Mean NI ' mean_ni_str '']},'colorlim', [-7 0])



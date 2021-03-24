% Copyright 2020, by the California Institute of Technology. ALL RIGHTS
% RESERVED. United States Government Sponsorship acknowledged. Any
% commercial use must be negotiated with the Office of Technology Transfer
% at the California Institute of Technology.
% -------------------------------------------------------------------------
% Script to test the Habex PROPER prescription in Matlab
%
% Written by A.J. Riggs (JPL, CIT) in February, 2020
%
% Matlab's PATH must know the locations of
% - the Habex prescription 'habex_vortex'
% - the PROPER library
% - the FALCO package


clearvars; close all;
close all;


global use_dm1_count;
use_dm1_count = 0;



prescription = 'habex'; 
%prescription = 'habex_scrap'; 

%-- 

% Set to true if you want to use to DM patterns besides the flat map
dm_use_custom = true; 

% Noise Standard Deviation of the Gaussian Noise
dm_noise_std = 1e-8;
dm_num_itr = 1;
dm_ni_mask_radius = 82;
dm_save_data = true;
dm_datapath = '/Users/poon/Documents/DST/proper-models/simple_habex/data/';


%-- Parameters for Viewing Diagnotics Information
figures_on = false; % Turns on figures when set to true
disp_dm_stats = false; % Turns on printing out dm statistics when set to true



lambda0 = 550e-9;    %--Central wavelength of the whole spectral bandpass [meters]
lambda_um = lambda0 * 1e6;
optval.lambda0_um = 0.550;

%--Focal planes
res = 3;
FOV = 30;
Rout = 26;
optval.nout = ceil_even(1 + res*(2*FOV)); %  dimensions of output in pixels (overrides output_dim0)
optval.final_sampling_lam0 = 1/res;	%   final sampling in lambda0/D
optval.use_field_stop = true;	%-- use field stop (0 = no stop)
optval.field_stop_radius = Rout;   %-- field stop radius in lam0/D

% %--Pupil Plane Resolutions
NbeamFull = 62*7;
optval.pupil_diam_pix = NbeamFull;
gridsize = 2^ceil(log2(NbeamFull));

optval.map_dir = '/Users/poon/Documents/dst/proper-models/simple_habex/maps/';	%-- directory containing optical surface error maps
optval.normLyotDiam = 0.95;
optval.vortexCharge = 6;

optval.xoffset = 0;
optval.yoffset = 0;

optval.use_errors = 1;




%dm_sine_scale_factor = 3e-9; % Scales the height of the command DM1 surface heights.
%dm_sine_x_spat_freq = 0.20; % The spatial frequency in X
%dm_sine_y_spat_freq = 0.20; % The spatial frequency in X


%%

hdr_info = {'STDDEV',dm_noise_std,'Standard Deviation of the Gaussian Noise'};
hdr_info = [hdr_info; {'USER','Phillip K Poon','Name of user'}];


%% Corrected

optval.use_dm1 = true;

% Reads in the DM commanded surface heights designed to correct for
% wavefront error
optval.dm1 = fitsread([optval.map_dir, 'flat_map.fits']);


% Prints out the statistics of dm1
dm_surf_height = optval.dm1;


if disp_dm_stats; disp('Old DM Map'); dm_print_summary_statistics(optval.dm1); end

% Displays the flat map solution
if figures_on; phil_custom_imagesc(optval.dm1,{'Desired DM Flat Map Solution (meters)'},'colorlim',[-3.5e-8 3.5e-8]); end






for loop_count = 1:dm_num_itr
    
    
    disp(['Beginning loop' num2str(loop_count) '']);
    
    
    % INSERT CUSTOM DM1 ARRAY
    if dm_use_custom == true
        
        % Adds Gaussian Noise to the DM Flat Map Solution
        dm_noise = dm_noise_std*randn(size(optval.dm1));
        
        % Displays just the noise added to the DM solution
        if figures_on; phil_custom_imagesc(dm_noise,{'Noise Added to DM Flat Map',[' Std. Dev. ' num2str(dm_noise_std) ' (meters)']}); end
        
        % Histogram of added noise realization for this iteration
        if figures_on; figure; histogram( dm_noise(:)); title('Histogram of Noise Added'); set(gca,'Fontsize',16); end
        
        % Adds the noise for this realization
        optval.dm1 = optval.dm1 + dm_noise;
        
        % Displays the corruped DM Flat Map
        if figures_on; phil_custom_imagesc(optval.dm1,{'Corrupted DM Flat Map.',['Noise Realization ' num2str(loop_count) '']},'colorlim',[-3.5e-8 3.5e-8]); end; 
        
        if disp_dm_stats; disp('New DM Map'); dm_print_summary_statistics(optval.dm1); end
        
    end
    
    %--Phase Retrieval Pupil
    optval.use_pr = true;
    optval.pr_pupil_diam_pix = 248;
    
    optval.use_fpm = 0;		%-- use focal plane mask (0 = no FPM)
    optval.use_lyot_stop = 1;	%-- use Lyot stop (0 = no stop)
    optval.use_field_stop = 0;	%-- use field stop (0 = no stop)
    % [Epup, sampling_m]  = habex_vortex(lambda_um, gridsize, optval);
    
    
    %-- PROP RUN 3 --%
    
    
    
    [Epup, sampling_m, optdm] = prop_run(prescription, lambda_um, gridsize, 'quiet', 'passvalue', optval);
    
    mask = 0*Epup;
    mask(abs(Epup) > 0.1*max(abs(Epup(:)))) = 1;
    
    if figures_on
        figure(11); imagesc(abs(Epup)); axis xy equal tight; colorbar; title('abs(E$_{pupil}$)', 'Interpreter','Latex'); set(gca,'Fontsize',20); drawnow;
        figure(12); imagesc(mask.*angle(Epup),[-1, 1]); axis xy equal tight; colorbar; title('angle(E$_{pupil}$)', 'Interpreter','Latex'); set(gca,'Fontsize',20);drawnow;
    end
    
    
    % PSF for normalization
    optval.use_pr = false;
    optval.use_fpm = 0;		%-- use focal plane mask (0 = no FPM)
    optval.use_lyot_stop = 1;	%-- use Lyot stop (0 = no stop)
    optval.use_field_stop = 0;	%-- use field stop (0 = no stop)
    % [EforNorm, sampling_m]  = habex_vortex(lambda_m, gridsize, optval);
    
    %-- PROP RUN 4 --%
    [EforNorm, sampling_m] = prop_run(prescription, lambda_um, gridsize, 'quiet', 'passvalue', optval);
    
    IforNorm = abs(EforNorm).^2;
    
    I00 = max(IforNorm(:));
    
    
    if figures_on; phil_custom_imagesc(IforNorm, {'PSF For Normalization','Unnormalized, Linear color scale'}); end
    
    
    if figures_on
        figure(13);
        imagesc(log10(IforNorm/I00),[-7 0]);
        title({'PSF for Normalization','Normalized, Log10 Scale'}, 'Interpreter','Latex');
        axis xy equal tight; colorbar; set(gca,'Fontsize',20); drawnow;
    end
    % Coronagraphic PSF
    optval.use_fpm = 1;		%-- use focal plane mask (0 = no FPM)
    optval.use_lyot_stop = 1;	%-- use Lyot stop (0 = no stop)
    optval.use_field_stop = 1;	%-- use field stop (0 = no stop)
    % [Ecoro, sampling_m]  = habex_vortex(lambda_m, gridsize, optval);
    
    %-- PROP RUN 5 --%
    [Ecoro, sampling_m] = prop_run(prescription, lambda_um, gridsize, 'quiet', 'passvalue', optval);
    
    
   
    
    
    % Normalized intensity is defined as the 2D intensity of the PSF with the
    % FPM, LS, and FS in divided by the max of the PSF without the FPM, and FS
    % in which is the variable I00
    
    Inorm = abs(Ecoro).^2 / I00; % This is the normalized intensity.
    
    
    
    
    % Plots the Normalized Intensity for this iteration
    phil_custom_imagesc(log10(Inorm),'Normalized Intensity (log 10 color scale)','cl',[-7 0])
    
    
   
    
    ni_mask = phil_make_circular_mask( size(Inorm,1), dm_ni_mask_radius);
    
   
    %
    % figure(14);
    % imagesc(log10(Inorm), [-7 0]);
    % title('Normalized Intensity', 'Interpreter','Latex');
    % axis xy equal tight; colorbar; set(gca,'Fontsize',20); drawnow;
    %mean( Inorm )
    
    
    
    %Saves the masked normalized intensity as a fits file
    if dm_save_data
        fitswrite(Inorm,...
            [dm_datapath 'Inorm_trial_' num2str(loop_count) '_sigma_' num2str(dm_noise_std) '.fits'])
    end
    
    
    
    
end
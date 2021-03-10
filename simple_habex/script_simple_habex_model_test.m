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


global use_dm1_count;
use_dm1_count = 0;


prescription = 'habex';

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

%--Parameters for generating a sine wave on DM1
dm_use_custom = true;
dm_scale_factor = 3e-9; % Scales the height of the command DM1 surface heights.
dm_x_spat_freq = 0.20; % The spatial frequency in X
dm_y_spat_freq = 0.20; % The spatial frequency in X


%% Corrected

optval.use_dm1 = true;

% Reads in the DM commanded surface heights designed to correct for
% wavefront error
optval.dm1 = fitsread([optval.map_dir, 'flat_map.fits']);


% Prints out the statistics of dm1
dm_surf_height = optval.dm1;
disp('Old DM Map')
disp(['Std  DM Surface Height ', num2str(std(dm_surf_height(:))),  ''])
disp(['Max  DM Surface Height ', num2str(max(dm_surf_height(:))),  ''])
disp(['Min  DM Surface Height ', num2str(min(dm_surf_height(:))),  ''])
disp(['Mean DM Surface Height ', num2str(mean(dm_surf_height(:))), ''])



figure;
imagesc(optval.dm1)
title({'DM Flat Map Solution (meters)'}, 'Interpreter','Latex');
axis xy equal tight; colorbar; set(gca,'Fontsize',16); drawnow;
colorbar; 


% INSERT CUSTOM DM1 ARRAY
if dm_use_custom == true
    
    
    dm_noise_std = 0.00000001;
    %dm_noise_std = 0;
    
    
    % Adds Gaussian Noise to the DM Flat Map Solution
    dm_noise = dm_noise_std*randn(64,64);
    
    
    
    % Displays just the noise added to the DM solution
    figure;
    imagesc(dm_noise);
    title({'Noise Added to DM Flat Map',[' Std. Dev. ' num2str(dm_noise_std) ' (meters)']}, 'Interpreter','Latex');
    axis xy equal tight; colorbar; set(gca,'Fontsize',16); drawnow;
    colorbar; 
    
    
    
    optval.dm1 = optval.dm1 + dm_noise;
    
    disp('New DM Map')    
    
    disp(['Std  DM Surface Height ', num2str(std(dm_surf_height(:))),  ''])
    disp(['Max  DM Surface Height ', num2str(max(dm_surf_height(:))),  ''])
    disp(['Min  DM Surface Height ', num2str(min(dm_surf_height(:))),  ''])
    disp(['Mean DM Surface Height ', num2str(mean(dm_surf_height(:))), ''])

    
    

end





%--Phase Retrieval Pupil
optval.use_pr = true;
optval.pr_pupil_diam_pix = 248;

optval.use_fpm = 0;		%-- use focal plane mask (0 = no FPM)
optval.use_lyot_stop = 1;	%-- use Lyot stop (0 = no stop)
optval.use_field_stop = 0;	%-- use field stop (0 = no stop)
% [Epup, sampling_m]  = habex_vortex(lambda_um, gridsize, optval);


%-- PROP RUN 3 --%
[Epup, sampling_m] = prop_run(prescription, lambda_um, gridsize, 'quiet', 'passvalue', optval);

mask = 0*Epup;
mask(abs(Epup) > 0.1*max(abs(Epup(:)))) = 1;
% mask = ones(size(Epup));

figure(11); imagesc(abs(Epup)); axis xy equal tight; colorbar; title('abs(E$_{pupil}$)', 'Interpreter','Latex'); set(gca,'Fontsize',20); drawnow;
figure(12); imagesc(mask.*angle(Epup),[-1, 1]); axis xy equal tight; colorbar; title('angle(E$_{pupil}$)', 'Interpreter','Latex'); set(gca,'Fontsize',20);drawnow;

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


figure;
imagesc(IforNorm);
axis xy equal tight;
colorbar;
title({'PSF For Normalization','Unnormalized, Linear color scale'}, 'Interpreter','Latex');
set(gca,'Fontsize',20);
drawnow;


% figure;
% imagesc(IforNorm/I00);
% title({'PSF For Normalization','Normalized, Linear color scale'}, 'Interpreter','Latex');
% axis xy equal tight; colorbar; set(gca,'Fontsize',20); drawnow;


figure(13);
imagesc(log10(IforNorm/I00),[-7 0]);
title({'PSF for Normalization','Normalized, Log10 Scale'}, 'Interpreter','Latex');
axis xy equal tight; colorbar; set(gca,'Fontsize',20); drawnow;

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


% Plots the Normalized Intensity:

figure(14);
imagesc(log10(Inorm), [-7 0]);
title('Normalized Intensity', 'Interpreter','Latex');
axis xy equal tight; colorbar; set(gca,'Fontsize',20); drawnow;









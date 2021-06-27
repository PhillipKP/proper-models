% Copyright 2020, by the California Institute of Technology. ALL RIGHTS
% RESERVED. United States Government Sponsorship acknowledged. Any
% commercial use must be negotiated with the Office of Technology Transfer
% at the California Institute of Technology.
% -------------------------------------------------------------------------
%
% Script to perform WFSC for the Habex vortex model.
%
% Written by A.J. Riggs (JPL, CIT) in February 2020.
%
% Matlab's path must know the locations of
% - the Habex prescription, 'habex.m' or 'habex_multi_coro.m'
% - the PROPER library
% - the FALCO package
%
% In falco_defaults_Habex_VC.m, change the value of mp.full.map_dir to be
% for your computer.
% -------------------------------------------------------------------------
%
% Updated 19 Mar 2021 By Phillip K Poon
% 
% Changed from script to function so I can loop over this using
% phil_sim_script.m
%
% Input arguments:
% SeriesNum is an integer for naming the final *.mat file
% TrialNum is an integer for naming the final *.mat file
% dm1 and dm2 are structs which contains fields like .pinned and .Vpinned 

function [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, ...
    dm1, dm2, controller, save_dir, bw, nsbp, nwpsbp)



%% Step 1: Define Necessary Paths on Your Computer System

%--Required packages are FALCO and PROPER.
% Add FALCO to the MATLAB path with the command:  
if isunix && ~(ismac)
    full_path_to_falco = '/home/poon/dst_sim/falco-matlab';
    addpath(genpath(full_path_to_falco)); savepath;
end


%%--Output Data Directories (Comment these lines out to use defaults within falco-matlab/data/ directory.)
% mp.path.config = ; %--Location of config files and minimal output files. Default is [mp.path.falco filesep 'data' filesep 'brief' filesep]
phil_add_paths


mp.flagSaveWS = true;  %--Whether to save out entire (large) workspace at the end of trial. Default is false

% PHIL Added this to save every the workspace every iteration
mp.flagSaveWS_Itr = true;

%% Step 2: Load default model parameters

[mp] = falco_defaults_Habex_VC(mp, Nitr, dm1, dm2, controller);


%% Step 3: Overwrite default values as desired


%%--Special Computational Settings
mp.flagParfor = true; %--whether to use parfor for Jacobian calculation
mp.flagPlot = true; % 

%--Record Keeping
mp.SeriesNum = SeriesNum;
mp.TrialNum = TrialNum;

%%--[OPTIONAL] Start from a previous FALCO trial's DM settings
% fn_prev = 'ws_Series0002_Trial0001_HLC_WFIRST20180103_2DM48_z1_IWA2.7_OWA10_6lams575nm_BW12.5_EFC_30its.mat';
% temp = load(fn_prev,'out');
% mp.dm1.V = temp.out.DM1V;
% mp.dm2.V = temp.out.DM2V;
% clear temp

%--DEBUGGING
mp.fracBW = bw;       %--fractional bandwidth of the whole bandpass (Delta lambda / lambda0)
mp.Nsbp = nsbp;            %--Number of sub-bandpasses to divide the whole bandpass into for estimation and control
mp.Nwpsbp = nwpsbp; 
mp.flagParfor = false; %--whether to use parfor for Jacobian calculation

%% Step 3b: Obtain the phase retrieval phase.

%mp.full.input_field_rootname = '/Users/ajriggs/Repos/falco-matlab/data/maps/input_full';
optval = mp.full;
optval.xoffset = 0;
optval.yoffset = 0;
optval.use_dm1 = true;
optval.dm1 = fitsread([optval.map_dir, 'flat_map.fits']);

optval.use_pr = true;
%optval.end_at_fpm_exit_pupil = 1;
%optval.output_field_rootname = [fileparts(mp.full.input_field_rootname) filesep 'fld_at_xtPup'];
optval.use_fpm = 0;
nout = mp.P1.full.Narr;			% nout > pupil_diam_pix
optval.output_dim = nout;%% Get the Input Pupil's E-field

if(mp.Nsbp==1)
    lambdaFacs = 1;
else
    lambdaFacs = linspace(1-mp.fracBW/2,1+mp.fracBW/2,mp.Nsbp);
end

prescription = 'habex';

%--Get the Input Pupil's E-field
Nf = nout; %--N full
Nc = ceil_even( (mp.P1.compact.Nbeam/mp.P1.full.Nbeam)*Nf ); %--N compact
mp.P1.compact.E = ones(Nc, Nc, mp.Nsbp); %--Initialize
%mp.P1.compact.E = ones(mp.P1.compact.Nbeam+2, mp.P1.compact.Nbeam+2, mp.Nsbp); %--Initialize
for si=1:mp.Nsbp
    lambda_um = 1e6*mp.lambda0*lambdaFacs(si);
    
    [fldFull, ~] = prop_run(prescription, lambda_um, nout, 'quiet', 'passvalue', optval);
    if(mp.flagPlot)
        figure(605); imagesc(angle(fldFull)); axis xy equal tight; colorbar; colormap hsv; drawnow;
        figure(606); imagesc(abs(fldFull)); axis xy equal tight; colorbar; colormap parula; drawnow;
    end
    
    %lams = num2str(lambda_um, '%6.4f');
    %pols = ['polaxis'  num2str(optval.polaxis,2)];
    %fitswrite(real(fldFull), [mp.full.input_field_rootname '_' lams 'um_' pols '_real.fits' ]);
    %fitswrite(imag(fldFull), [mp.full.input_field_rootname '_' lams 'um_' pols '_imag.fits' ]);
    
    %%--Downsampling for the compact model
    dxF = 1;
    dxC = mp.P1.full.Nbeam/mp.P1.compact.Nbeam;
    
    xF = (-Nf/2:(Nf/2-1))*dxF;
    xC = (-Nc/2:(Nc/2-1))*dxC;
    [Xf, Yf] = meshgrid(xF);
    [Xc, Yc] = meshgrid(xC);
    fldC = interp2(Xf, Yf, fldFull, Xc, Yc, 'cubic', 0); %--Downsample by interpolation
    %fldC = pad_crop(fldC, ceil_even(mp.P1.compact.Nbeam+1));
    if(mp.flagPlot)
        figure(607+si-1); imagesc(angle(fldC)); axis xy equal tight; colorbar; colormap hsv; drawnow;
        figure(608); imagesc(abs(fldC)); axis xy equal tight; colorbar; colormap parula; drawnow;
    end
    
    %--Assign to initial E-field in compact model.
    %     temp = 0*fldC;
    %     temp(2:end,2:end) = rot90(fldC(2:end,2:end),2);
    %     mp.P1.compact.E(:,:,si) = temp;
    mp.P1.compact.E(:,:,si) = propcustom_relay(fldC, 1);
    
end


%%

%% Obtain DM1 Commands to Flatten the Wavefront Prior to WFSC

% optval.use_pr = true;
% optval.pr_pupil_diam_pix = mp.P1.compact.Nbeam;
%
% optval.use_dm1 = false;
% optval.use_dm2 = false;
%
% optval.use_errors = 1;		%-- 1 = use optical surface errors, 0 = none
% % optval.use_fpm = 0;		%-- use focal plane mask (0 = no FPM)
% % optval.use_lyot_stop = 0;	%-- use Lyot stop (0 = no stop)
% % optval.use_field_stop = 0;	%-- use field stop (0 = no stop)
% [Epup, sampling_m]  = habex_multi_coro(mp.lambda0, mp.P1.full.Narr, optval);
%
% mask = 0*Epup;
% mask(abs(Epup) > 1e-1*max(abs(Epup(:)))) = 1;
% % mask = ones(size(Epup));
%
% surfaceToFit = -0.5*mask.*angle(Epup)*(mp.lambda0/(2*pi));
%
% figure(1); imagesc(abs(Epup)); axis xy equal tight; colorbar;
% % title('', 'Fontsize', 16);
% drawnow;
% figure(2); imagesc(surfaceToFit); axis xy equal tight; colorbar;
%
%
% mp.dm1.inf0 = fitsread(mp.dm1.inf_fn);
% mp.dm1.dm_spacing = 400e-6;
% mp.dm1.dx_inf0 = mp.dm1.dm_spacing/10;
% mp.dm1.dx = mp.P2.D/mp.P2.compact.Nbeam;
% mp.dm1.centering = 'pixel';
% V0 = falco_fit_dm_surf(mp.dm1,surfaceToFit);
% figure(3); imagesc(V0); axis xy equal tight; colorbar; drawnow;
%
% fitswrite(V0, [mp.full.map_dir, 'flat_map.fits'])
%
% return



%% Step 4: Generate the label associated with this trial


mp.runLabel = ['Series',num2str(mp.SeriesNum,'%04d'),'_Trial',num2str(mp.TrialNum,'%04d_'),...
    mp.coro,'_',mp.whichPupil,'_',num2str(numel(mp.dm_ind)),'DM',num2str(mp.dm1.Nact),'_z',num2str(mp.d_dm1_dm2),...
    '_IWA',num2str(mp.Fend.corr.Rin),'_OWA',num2str(mp.Fend.corr.Rout),...
    '_',num2str(mp.Nsbp),'lams',num2str(round(1e9*mp.lambda0)),'nm_BW',num2str(mp.fracBW*100),...
    '_',mp.controller];


%% Step 5: Perform the Wavefront Sensing and Control

[mp, out] = falco_flesh_out_workspace(mp);

% Set compact model's entrance aperture as ones because it is already
% implicit in mp.P1.compact.E and shouldn't be double-counted.
mp.P1.compact.mask = ones(size(mp.P1.compact.mask));

[mp, out] = falco_wfsc_loop(mp, out);


% %--Noll zernike modes for which to compute sensitivities
% mp.eval.indsZnoll = [2, 3];
%  
% %--Amount of RMS Zernike mode used to calculate aberration sensitivities 
% % [meters]. WFIRST CGI uses 1e-9, and LUVOIR and HabEx use 1e-10. 
% mp.full.ZrmsVal = 10e-9; 
%  
% %--Annuli to compute 1nm RMS Zernike sensitivities over.
% % Columns are [inner radius, outer radius]. One row per annulus.
% mp.eval.Rsens = [3, 5; ...
%          3, 20];  
%        
% %--Compute the sensitivities. Needs to occur after calling
% % falco_flesh_out_workspace(), or after re-loading the config file.
% % The output has Nzernikes rows (one for each value in mp.eval.indsZnoll)
% % and Nannuli columns (one for each row of mp.eval.Rsens).
% sensArray = falco_get_Zernike_sensitivities(mp);

end

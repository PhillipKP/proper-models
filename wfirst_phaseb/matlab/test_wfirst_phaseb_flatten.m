%  3/14/2019, Hanying Zhou  
clear all
% addpath('/home/hanying/afta_im/properMatlab2/proper_v3.0c_matlab_4jun18')
addpath('~/Documents/MATLAB/PROPER');
addpath('~/Repos/falco-matlab/zEXTRA/');
addpath(genpath('/home/ajriggs/Documents/Sim/cgi/wfirst_phaseb/'))
cd /home/ajriggs/Documents/Sim/cgi/wfirst_phaseb/

optval.phaseb_dir = '/home/ajriggs/Documents/Sim/cgi/wfirst_phaseb/';

testcase = 1;  % 1 -hlc; 2- hlc_erkin; 3 -spc-ifs (long); 4- ifs_short;  5-spc_wide; 
optval.end_at_fpm_exit_pupil =1;
optval.output_field_rootname = ['fld_at_xtPup'];
%-------------------------------------------
nlam = 9;  
npsf = 256;
bw = 0.10;                          % 0.18 for ifs
optval.final_sampling_lam0 = 0.1;   % 0.2 for disc
optval.source_x_offset = 7;         % 12 for disc

switch testcase
    case 1      
        lambda0 =.575; 
        optval.cor_type ='hlc'; 
    case 2      
        lambda0 =.575; 
        optval.cor_type ='hlc_erkin'; 
    case 3
        lambda0 =.730;  
        bw = 0.18;
        optval.cor_type ='spc-ifs_long';
    case 4
        lambda0 =.660;  
        bw = 0.18;
        optval.cor_type ='spc-ifs_short';
    case 5
        lambda0 =.825;
        optval.cor_type ='spc-wide'; 
        optval.final_sampling_lam0 = 0.2; 
        optval.source_x_offset = 12;
end
%%

lam_array = [(1-bw/2):bw/(nlam-mod(nlam,2)):(1+bw/2)]*lambda0;

% 1. offaxis compact psf pk for normalizing factor; 
EE0 = prop_run_multi(['wfirst_phaseb_v2b_compact'  ], lam_array, npsf, 'quiet', 'passvalue',optval );

optval.source_x_offset =0;
optval.use_errors =1;

% 2. before flatten, full
EE = prop_run_multi(['wfirst_phaseb_v2b' ], lam_array, npsf, 'quiet', 'passvalue',optval );


% 3. post flatten, full
optval.dm1_m = fitsread (['/home/ajriggs/Documents/Sim/cgi/wfirst_phaseb/dm1_flatten.fits']);
%optval.dm1_m = fitsread (['/home/hanying/afta_im/idl_etc/dm1_flatten.fits']);
optval.use_dm1 =1;
Ef = prop_run_multi(['wfirst_phaseb_v2b' ], lam_array, npsf, 'quiet', 'passvalue',optval );

max_psf0 = max(max(sum(abs(EE0).^2,3)))/nlam;
psf_bfF  = sum(abs(EE).^2,3)/nlam/max_psf0;
psf_afF  = sum(abs(Ef).^2,3)/nlam/max_psf0;

figure(1), clf,imagesc([log10(abs(psf_bfF)) log10(abs(psf_afF))]);%
colorbar, caxis([-7 -2]), axis image%
title([ strrep(optval.cor_type,'_',', ') ', ' num2str(nlam) 'lam, before and after flattening' ])

% print('-dpng', [optval.cor_type '_bf_vs_aftr_flatten_NI']);


return
%% Original
lam_array = [(1-bw/2):bw/(nlam-mod(nlam,2)):(1+bw/2)]*lambda0;

% 1. offaxis compact psf pk for normalizing factor; 
EE0 = prop_run_multi(['wfirst_phaseb_v2_compact'  ], lam_array, npsf, 'quiet', 'passvalue',optval );

optval.source_x_offset =0;
optval.use_errors =1;

% 2. before flatten, full
EE = prop_run_multi(['wfirst_phaseb_v2' ], lam_array, npsf, 'quiet', 'passvalue',optval );


% 3. post flatten, full
optval.dm1_m = fitsread (['/home/ajriggs/Documents/Sim/cgi/wfirst_phaseb/dm1_flatten.fits']);
%optval.dm1_m = fitsread (['/home/hanying/afta_im/idl_etc/dm1_flatten.fits']);
optval.use_dm1 =1;
Ef = prop_run_multi(['wfirst_phaseb_v2' ], lam_array, npsf, 'quiet', 'passvalue',optval );

max_psf0 = max(max(sum(abs(EE0).^2,3)))/nlam;
psf_bfF  = sum(abs(EE).^2,3)/nlam/max_psf0;
psf_afF  = sum(abs(Ef).^2,3)/nlam/max_psf0;

figure(1), clf,imagesc([log10(abs(psf_bfF)) log10(abs(psf_afF))]);%
colorbar, caxis([-7 -2]), axis image%
title([ strrep(optval.cor_type,'_',', ') ', ' num2str(nlam) 'lam, before and after flattening' ])

print('-dpng', [optval.cor_type '_bf_vs_aftr_flatten_NI']);

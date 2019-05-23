;-- Version 1.0, 3 Jan 2019, JEK
;-- Version 1.0a, 9 Jan 2019, JEK
;--   Changes: If reading in input field using input_field_rootname, the
;--            user can specify polaxis, and the appropriate file will
;--            be used.  By default, polaxis = 0.  This is the only
;--            time polaxis can be specified for the compact model.
;-- Version 1.0c, 13 February 2019, JEK 
;--    Changes: Changed HLC design to HLC-20190210; added 'fpm_axis' parameter to specify
;--               axis of HLC FPM ('s' or 'p') due to FPM tilt; changed 'spc' coronagraph
;--               option to 'cor_type' to 'spc-ifs' and changed default SPC to SPC-20190130 and
;--               updated associated parameters; added 'spc-wide' option to 'cor_type' to use
;--               SPC-20191220.  Changed DM tilt to rotation around Y axis.

pro wfirst_phaseb_compact, wavefront, lambda_m, output_dim, sampling_m, PASSVALUE=optval

;-- "output_dim" is used to specify the output dimension in pixels at the final image plane.  
;-- The computational grid sizes are hardcoded for each coronagraph.
;-- Based on Zemax prescription "WFIRST_CGI_DI_LOWFS_Sep24_2018.zmx" by Hong Tang.
;--
;-- by John Krist

cor_type = 'hlc'		;-- 'hlc', 'spc', or 'none' (none = clear aperture, no coronagraph)
input_field_rootname = ''	;-- rootname of files containing aberrated pupil
polaxis = 0			;-- polarization condition (only used with input_field_rootname)
source_x_offset = 0		;-- source offset in lambda0_m/D radians
source_y_offset = 0
use_hlc_dm_patterns = 1		;-- use Dwight-generated HLC default DM wavefront patterns? 1 or 0
use_dm1 = 0			;-- use DM1? 1 or 0
use_dm2 = 0			;-- use DM2? 1 or 0
dm_sampling_m = 1.0d-3         	;-- actuator spacing in meters; default is 1 mm
dm1_xc_act = 23.5d		;-- for 48x48 DM, wavefront centered at actuator intersections: (0,0) = 1st actuator center
dm1_yc_act = 23.5d
dm1_xtilt_deg = 0   		;-- tilt around X axis
dm1_ytilt_deg = 5.7d		;-- effective DM tilt in deg including 9.65 deg actual tilt and pupil ellipticity
dm1_ztilt_deg = 0
dm2_xc_act = 23.5d		
dm2_yc_act = 23.5d
dm2_xtilt_deg = 0   
dm2_ytilt_deg = 5.7d
dm2_ztilt_deg = 0
fpm_axis = 'p'			;-- HLC FPM axis: '', 's', 'p'
final_sampling_lam0 = 0		;-- final sampling in lambda0/D

if ( n_elements(optval) ne 0 ) then begin
	if ( tag_exists('cor_type',optval) ) then cor_type = optval.cor_type
	if ( tag_exists('fpm_axis',optval) ) then fpm_axis = optval.fpm_axis
endif

if ( cor_type eq 'hlc' ) then begin
        file_directory = './hlc_20190210/'         ;-- must have trailing "/"
        prefix = file_directory + 'run461_nro_' 
        pupil_diam_pix = 309.0
        pupil_file = prefix + 'pupil_rotated.fits'
        lyot_stop_file = prefix + 'lyot.fits'
        lambda0_m = 0.575d-6
	lam_occ =                       [  5.4625d-07,  5.534375d-07,  5.60625d-07,  5.678125d-07,  5.75d-07,  5.821875e-07,  5.89375d-07,  5.965625d-07,  6.0375d-07 ]
	lam_occs = prefix + 'occ_lam' + [ '5.4625e-07','5.534375e-07','5.60625e-07','5.678125e-07','5.75e-07','5.821875e-07','5.89375e-07','5.965625e-07','6.0375e-07' ]
 	lam_occs = lam_occs + 'theta6.69pol' + fpm_axis + '_' 
        ;-- find nearest matching FPM wavelength
        diff = abs(lambda_m-lam_occ)
        wlam = (where(diff eq min(diff)))[0]
        occulter_file_r = lam_occs[wlam] + 'real_rotated.fits'
        occulter_file_i = lam_occs[wlam] + 'imag_rotated.fits'
	n_small = 1024	;-- gridsize in non-critical areas
	n_big = 2048 	;-- gridsize to/from FPM
	;-- these commented-out DM settings match the design to the testbed rather than flight 
	;dm_sampling_m = 0.9906d-3
	;dm1_xtilt_deg = 0.0
	;dm1_ytilt_deg = 10.0
	;dm1_ztilt_deg = -0.88
	;dm1_xtilt_deg = 0.0
	;dm1_ytilt_deg = 8.0
	;dm1_ztilt_deg =  0.45
endif else if ( cor_type eq 'spc-ifs' ) then begin
        file_dir = './spc_20190130/'        ;-- must have trailing "/"
        pupil_diam_pix = 1000.0
        pupil_file = file_dir + 'pupil_SPC-20190130.fits'
        pupil_mask_file = file_dir + 'SPM_SPC-20190130.fits'
	fpm_file = file_dir + 'fpm_0.05lamdivD.fits'
	fpm_sampling_lam0 = 0.05d	;-- sampling in lambda0/D of FPM mask 
        lyot_stop_file = file_dir + 'lyotstop_0.5mag.fits'
        lambda0_m = 0.73d-6     ;-- FPM scaled for this central wavelength
	n_small = 2048	;-- gridsize in non-critical areas
	n_big = 1400	;-- gridsize to FPM (propagation to/from FPM handled by MFT) 
endif else if ( cor_type eq 'spc-wide' ) then begin
        file_dir = './spc_20181220/'        ;-- must have trailing "/"
        pupil_diam_pix = 1000.0
        pupil_file = file_dir + 'pupil_SPC-20181220_1k.fits'
        pupil_mask_file = file_dir + 'SPM_SPC-20181220_1000_rounded9_gray.fits'
	fpm_file = file_dir + 'fpm_0.05lamdivD.fits'
	fpm_sampling_lam0 = 0.05d	;-- sampling in lambda0/D of FPM mask 
        lyot_stop_file = file_dir + 'LS_half_symm_CGI180718_Str3.20pct_38D91_N500_pixel_rotated.fits'
        lambda0_m = 0.825d-6     ;-- FPM scaled for this central wavelength
	n_small = 2048	;-- gridsize in non-critical areas
	n_big = 1400	;-- gridsize to FPM (propagation to/from FPM handled by MFT) 
endif else if ( cor_type eq 'none' ) then begin
	use_fpm = 0
	use_lyot_stop = 0
	pupil_diam_pix = 300.0
	n_small = 1024
	n_big = 1024
endif else begin
	print, 'ERROR: Unsupported cor_type: ', cor_type
	stop
endelse

if ( n_elements(optval) ne 0 ) then begin
	if ( tag_exists('lam0',optval) ) then lambda0_m = optval.lam0 * 1.0e-6
	if ( tag_exists('lambda0_m',optval) ) then lambda0_m = optval.lambda0_m
	if ( tag_exists('input_field_rootname',optval) ) then input_field_rootname = optval.input_field_rootname
	if ( tag_exists('polaxis',optval) ) then polaxis = optval.polaxis
	if ( tag_exists('source_x_offset',optval) ) then source_x_offset = optval.source_x_offset 
	if ( tag_exists('source_y_offset',optval) ) then source_y_offset = optval.source_y_offset 
	if ( tag_exists('use_hlc_dm_patterns',optval) ) then use_hlc_dm_patterns = optval.use_hlc_dm_patterns
	if ( tag_exists('use_dm1',optval) ) then use_dm1 = optval.use_dm1
	if ( tag_exists('dm1_m',optval) ) then dm1_m = optval.dm1_m
	if ( tag_exists('dm1_xc_act',optval) ) then dm1_xc_act = optval.dm1_xc_act
	if ( tag_exists('dm1_yc_act',optval) ) then dm1_yc_act = optval.dm1_yc_act
	if ( tag_exists('dm1_xtilt_deg',optval) ) then dm1_xtilt_deg = optval.dm1_xtilt_deg
	if ( tag_exists('dm1_ytilt_deg',optval) ) then dm1_ytilt_deg = optval.dm1_ytilt_deg
	if ( tag_exists('dm1_ztilt_deg',optval) ) then dm1_ztilt_deg = optval.dm1_ztilt_deg
	if ( tag_exists('use_dm2',optval) ) then use_dm2 = optval.use_dm2
	if ( tag_exists('dm2_m',optval) ) then dm2_m = optval.dm2_m
	if ( tag_exists('dm2_xc_act',optval) ) then dm2_xc_act = optval.dm2_xc_act
	if ( tag_exists('dm2_yc_act',optval) ) then dm2_yc_act = optval.dm2_yc_act
	if ( tag_exists('dm2_xtilt_deg',optval) ) then dm2_xtilt_deg = optval.dm2_xtilt_deg
	if ( tag_exists('dm2_ytilt_deg',optval) ) then dm2_ytilt_deg = optval.dm2_ytilt_deg
	if ( tag_exists('dm2_ztilt_deg',optval) ) then dm2_ztilt_deg = optval.dm2_ztilt_deg
	if ( tag_exists('final_sampling_lam0',optval) ) then final_sampling_lam0 = optval.final_sampling_lam0
endif

if ( polaxis ne 0 and input_field_rootname eq '' ) then begin
	print, 'ERROR: polaxis can only be defined when input_field_rootname is given'
	wavefront = 0
	sampling_m = 0.0
	return
endif

diam_at_dm1 = 0.0463d
d_dm1_dm2 = 1.0d

n = n_small	;-- start off with less padding
 
prop_begin, wavefront, diam_at_dm1, lambda_m, n, double(pupil_diam_pix)/n
   if ( cor_type ne 'none' ) then begin
	if ( input_field_rootname eq '' ) then begin 
 		fits_read, pupil_file, pupil
    		prop_multiply, wavefront, trim(pupil,n)
   		pupil = 0
	endif else begin
		lams = string(lambda_m*1d6, form='(f6.4)')
		pols = 'polaxis' + strtrim(string(round(polaxis)),2)
		fits_read, input_field_rootname+'_'+lams+'um_'+pols+'_real.fits', rval 
		fits_read, input_field_rootname+'_'+lams+'um_'+pols+'_imag.fits', ival 
		prop_multiply, wavefront, trim(dcomplex(rval,ival),n)
		rval = 0
		ival = 0
	endelse
   endif else begin
	prop_circular_aperture, wavefront, diam/2
   endelse
   prop_define_entrance, wavefront
   if ( source_x_offset ne 0.0 or source_y_offset ne 0.0) then begin
        ;-- compute tilted wavefront to offset source by source_x_offset,source_y_offset lambda0_m/D
        xtilt_lam = -source_x_offset * lambda0_m / lambda_m
        ytilt_lam = -source_y_offset * lambda0_m / lambda_m
        x = ((dindgen(n)-n/2)/(pupil_diam_pix/2)) # replicate(1.0d,n)
        y = transpose(x)
        prop_multiply, wavefront, exp(dcomplex(0,1) * !dpi * (xtilt_lam * x + ytilt_lam * y))
        x = 0
        y = 0
   endif
   if ( use_dm1 ) then prop_dm, wavefront, dm1_m, dm1_xc_act, dm1_yc_act, dm_sampling_m, XTILT=dm1_xtilt_deg, YTILT=dm1_ytilt_deg, ZTILT=dm1_ztilt_deg
   if ( cor_type eq 'hlc' and use_hlc_dm_patterns ) then begin
   	fits_read, prefix+'dm1wfe.fits', dm1wfe
    	prop_add_phase, wavefront, trim(dm1wfe, n)
   	dm1wfe = 0
   endif

prop_propagate, wavefront, d_dm1_dm2, 'DM2'
   if ( use_dm2 ) then prop_dm, wavefront, dm2_m, dm2_xc_act, dm2_yc_act, dm_sampling_m, XTILT=dm2_xtilt_deg, YTILT=dm2_ytilt_deg, ZTILT=dm2_ztilt_deg
   if ( cor_type eq 'hlc' ) then begin
	if ( use_hlc_dm_patterns ) then begin
   		fits_read, prefix+'dm2wfe.fits', dm2wfe
    		prop_add_phase, wavefront, trim(dm2wfe, n)
   		dm2wfe = 0
	endif
   	fits_read, prefix+'dm2mask.fits', dm2mask
    	prop_multiply, wavefront, trim(dm2mask, n)
   	dm2mask = 0
   endif

prop_propagate, wavefront, -d_dm1_dm2, 'back to DM1'

prop_end, wavefront, sampling_m, /NOABS

if ( cor_type eq 'spc-ifs' or cor_type eq 'spc-wide' ) then begin
 	fits_read, pupil_mask_file, pupil_mask
 	wavefront = wavefront * trim(pupil_mask,n)
	pupil_mask = 0
endif

if ( cor_type eq 'hlc' ) then begin
	n = n_big
	wavefront = trim(wavefront,n)
	wavefront = fftsi(wavefront,-1)	;-- to focus
       	fits_read, occulter_file_r, occ_r
       	fits_read, occulter_file_i, occ_i
	occ = dcomplex(occ_r,occ_i)
       	wavefront = wavefront * trim(occ,n) 
	occ_r = 0
	occ_i = 0
	occ = 0
	wavefront = fftsi(wavefront,+1) 		;-- FFT to Lyot stop
endif else if ( cor_type eq 'spc-ifs' or cor_type eq 'spc-wide' ) then begin
	n = n_big
	wavefront = trim(wavefront,n)
	fits_read, fpm_file, fpm
	nfpm = (size(fpm))[1]
	fpm_sampling_lam = fpm_sampling_lam0 * lambda0_m / lambda_m
	wavefront = mft2(wavefront, fpm_sampling_lam, pupil_diam_pix, nfpm, -1)		;-- MFT to highly-sampled focal plane
        wavefront = wavefront * fpm
        fpm = 0
	pupil_diam_pix = pupil_diam_pix / 2.0	;-- Shrink pupil by 1/2
        wavefront = mft2(wavefront, fpm_sampling_lam, pupil_diam_pix, fix(pupil_diam_pix), +1)	;-- MFT to Lyot stop with 1/2 magnification
endif

n = n_small
wavefront = trim(wavefront,n)
if ( cor_type ne 'none' ) then begin
	fits_read, lyot_stop_file, lyot
	wavefront = wavefront * trim(lyot,n)
	lyot = 0
endif

wavefront = fftsi(wavefront*n,-1) 		;-- FFT to final focus

if ( final_sampling_lam0 ne 0 ) then begin
	mag = (double(pupil_diam_pix)/n) / final_sampling_lam0 * (lambda_m/lambda0_m)
	wavefront = prop_magnify( wavefront, mag, output_dim, /AMP_CONSERVE )
endif else begin
	wavefront = trim(wavefront, output_dim)
endelse

wavefront = shift(rotate(wavefront,2),1,1)	;-- rotate to same orientation as full model

sampling_m = 0.0

return
end

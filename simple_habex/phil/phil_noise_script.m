clearvars

for Itr = 1:30
    
    
    SeriesNum = 2
    TrialNum = 5
    save_dir = 'noise'
    
    mp.SeriesNum = SeriesNum
    mp.TrialNum = TrialNum
    
    
    phil_add_paths % Gets the mp.path.itr
    
    itr_name = ['Series', num2str(mp.SeriesNum,'%04.f'), 'Trial', num2str(mp.TrialNum,'%04.f'), '_Itr_', num2str(Itr)]
    itr_file = [mp.path.itr itr_name]
    load(itr_file,'mp','out')
    
    
    summedImage = 0;
    for iSubband = 1:mp.Nsbp
        
        subbandImage = falco_get_sim_sbp_image(mp, iSubband);
        
        summedImage = summedImage +  mp.sbp_weights(iSubband)*subbandImage;
    end
    
    %ev.Im = falco_get_summed_image(mp)
    
    ni_list(Itr) = mean(summedImage(mp.Fend.corr.maskBool));
    
end

figure;
phil_
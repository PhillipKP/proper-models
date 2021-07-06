function [path] = return_path_for_noise_trials(SeriesVec, TrialVec, NoiseType, fi)
 
    SeriesNum = SeriesVec(fi);
    TrialNum = TrialVec(fi);
    
    label = ['Series', num2str(SeriesNum,'%04.f'), '_Trial', num2str(TrialNum,'%04.f') ''];
    
    
    
    switch NoiseType
        case 'periodic'
            save_dir = 'noise';
        case 'brownian'
            save_dir = 'noise_drift';
    end
    
    if ismac
        
        path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir,'/png/' label '/'];
        path.ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir,'/'];
        
    elseif isunix && ~ismac
        
        path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir,'/png/' label '/'];
        path.ws =  ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir,'/'];
    end
    
    
    path.full = [path.ws label '.mat']
    
        
    
end


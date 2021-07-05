function [path] = return_path_for_noise_trials(SeriesVec, TrialVec, fi)
 
    SeriesNum = SeriesVec(fi);
    TrialNum = TrialVec(fi);
    
    label = ['Series', num2str(SeriesNum,'%04.f'), '_Trial', num2str(TrialNum,'%04.f') ''];
    
    if ismac
        
        path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' label '/'];
        path.ws = '/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/';
        
    elseif isunix && ~ismac
        
        path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' label '/'];
        path.ws = '/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/';
    end
    
    
    path.full = [path.ws label '.mat']
        
    
end


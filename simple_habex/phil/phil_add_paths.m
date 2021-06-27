
series_trial_str = ['Series',num2str(SeriesNum,'%04d'),'_Trial',num2str(TrialNum,'%04d')]

% Phil's Macbook Pro
if isunix && ismac
    
    % The directory to save the completed workspace
    mp.path.ws = ['/Users/poon/Documents/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/'];
    
    % The directory to save the workspace at the end of each falco_wfsc_loop iteration
    mp.path.itr = ['/Users/poon/Documents/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/itr/',...
        series_trial_str, '/'];
    
    % Where to save the png files
    mp.path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/png/',...
    series_trial_str,'/'];

    
end

% On S383 Computers
if isunix && ~(ismac)
    
    
    mp.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/'];
    % Where to save the png files
    
        % The directory to save the workspace at the end of each falco_wfsc_loop iteration
    mp.path.itr = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/itr/',...
        series_trial_str, '/'];
    
    
    mp.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/png/',...
    series_trial_str,'/'];
end


if ~(exist(mp.path.png)) 
    mkdir(mp.path.png)
end


if ~(exist(mp.path.itr)) 
    mkdir(mp.path.itr)
end



if ~(exist(mp.path.ws))
    mkdir(mp.path.ws)
end

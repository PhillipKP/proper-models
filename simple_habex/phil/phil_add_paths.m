

% Phil's Macbook Pro
if isunix && ismac
    mp.path.ws = ['/Users/poon/Documents/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/'];
    % Where to save the png files
    mp.path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/png/',...
    'Series',num2str(SeriesNum,'%04d'),'_Trial',num2str(TrialNum,'%04d'),'/'];
    % (Mostly) complete workspace from end of trial. Default is [mp.path.falco filesep 'data' filesep 'ws' filesep];
end
% On S383 Computers
if isunix && ~(ismac)
    mp.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/'];
    % Where to save the png files
    mp.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', save_dir, '/png/',...
    'Series',num2str(SeriesNum,'%04d'),'_Trial',num2str(TrialNum,'%04d'),'/'];
end

if ~(exist(mp.path.png)) 
    mkdir(mp.path.png)
end
if ~(exist(mp.path.ws))
    mkdir(mp.path.ws)
end

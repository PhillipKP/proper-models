function [ffpath] = phil_build_full_path(SeriesNum, TrialNum, varargin)


% Defaults


% Defaults
mp.coro = 'vortex';
mp.whichPupil = 'simple';

mp.dm_ind = [1 2];
mp.dm1.Nact = 64;
mp.d_dm1_dm2 = 0.32;
mp.lambda0 = 5.5e-07;
mp.Fend.corr.Rin = 2;
mp.Fend.corr.Rout = 27; %Default is 27 if not provided
mp.Nsbp = 1;
mp.fracBW = 0.01;


% Assigned
for icav = 1:length(varargin)
    
    arg_name = varargin{icav};
    
    if ischar(arg_name)
        
        switch lower(arg_name)
            
            % Allows user to set the title
            case {'owa'}
                
                varargin{icav + 1};
                mp.Fend.corr.Rout = varargin{icav + 1};
                
            case {'nsbp'}
                
                varargin{icav + 1};
                mp.Nsbp = varargin{icav + 1};
                
            case {'bw'}
                
                varargin{icav + 1};
                mp.fracBW = varargin{icav + 1};
                
            case {'controller','con'}
                varargin{icav + 1};
                mp.controller = varargin{icav + 1};
                
                
        end
        
    end
    
end

switch SeriesNum
    case 0
        folder_name = 'pinned_actuators'
    case 1
        folder_name = 'pinned_scheduled'
end

mp.runLabel = ['Series',num2str(SeriesNum,'%04d'),'_Trial',num2str(TrialNum,'%04d_'),...
    mp.coro,'_',mp.whichPupil,'_',num2str(numel(mp.dm_ind)),'DM',num2str(mp.dm1.Nact),'_z',num2str(mp.d_dm1_dm2),...
    '_IWA',num2str(mp.Fend.corr.Rin),'_OWA',num2str(mp.Fend.corr.Rout),...
    '_',num2str(mp.Nsbp),'lams',num2str(round(1e9*mp.lambda0)),'nm_BW',num2str(mp.fracBW*100),...
    '_',mp.controller];


if (~ismac) && (isunix)
    path_to_ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/', folder_name, '/'];
elseif (ismac)
    path_to_ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/', folder_name, '/'];
end
% The full file path
ffpath = [path_to_ws, mp.runLabel, '_all.mat'];

end

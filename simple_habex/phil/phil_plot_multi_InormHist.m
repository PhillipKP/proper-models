function [] = phil_plot_multi_InormHist(SeriesNumVec, TrialNumVec, bwVec, owaVec, nsbpVec, varargin)


% Where to save the pngs
if ismac
    path_to_png = '/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/png/';
elseif (~ismac) && (isunix)
    path_to_png = '/home/poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/png/';
end




if length(bwVec) == 1
    bwVec = bwVec*ones(size(TrialNumVec));
end
if length(SeriesNumVec) == 1
    SeriesNumVec = SeriesNumVec*ones(size(TrialNumVec));
end
if length(owaVec) == 1
    owaVec = owaVec*ones(size(TrialNumVec));
end
if length(nsbpVec) == 1
    nsbpVec = nsbpVec*ones(size(TrialNumVec));
end



% Default is no title
title_flag = false;
% Default is not to tsave
save_flag = false;

for icav = 1:length(varargin)
    
    arg_name = varargin{icav}
    
    if ischar(arg_name)
        
        switch arg_name
            % Allows user to set the title
            case {'title'}
                
                % ts is the title string
                ts = varargin{icav + 1};
                % Turns on figure title
                title_flag = true;
                
                % Allows user to save the plot as a png in the mp.path.ws
                % in the png folder
            case {'save_str','save'}
                
                if ischar(  varargin{icav + 1})
                    ss = varargin{icav + 1};
                    save_flag = true;
                else
                    error('Save string must be a char class')
                end
                
                
        end
    end
    
end

for fi = 1:length(SeriesNumVec)
    full_file_path{fi} = phil_build_full_path(SeriesNumVec(fi), ...
        TrialNumVec(fi), 'bw', bwVec(fi), 'owa', owaVec(fi), ...
        'nsbp', nsbpVec(fi) );
end


figure;
for fi = 1:length(SeriesNumVec)
    
    load(full_file_path{fi})
    
    % File Prefix
    fp{fi} = mp.runLabel(1:20)
    
    % Collect stats on railed and pinned actuators
    dm1r{fi} = sum(mp.dm1.Vpinned == 200)
    dm1p{fi} = sum(mp.dm1.Vpinned < -200)
    
    dm2r{fi} = sum(mp.dm2.Vpinned == 200)
    dm2p{fi} = sum(mp.dm1.Vpinned < -200)
    
    
    
    rl{fi} = [ fp{fi},  ', DM1P: ', num2str(dm1p{fi}), ...
        ', DM2P: ', num2str(dm2p{fi}), ' BW: ', num2str(bwVec(fi)), '']
    
    
    
   % switch bwVec(fi)
   %     case 1
            semilogy(0:mp.Nitr,out.InormHist,'linewidth',3);
   %     case 10
   %         semilogy(0:mp.Nitr,out.InormHist,'--','linewidth',3);
   % end
    
    
    hold all
end

hold off


% load(full_file1_path);
% rl1 = mp.runLabel(1:20);
%
% figure;
% semilogy(0:mp.Nitr,out.InormHist,'linewidth',3);
%
% load(full_file2_path);
% rl2 = mp.runLabel(1:20);
%
% hold all
% semilogy(0:mp.Nitr,out.InormHist,'linewidth',3);
% hold off
%
grid on

xlabel('WFSC Iteration', 'interpreter', 'none');
ylabel('Mean NI')



yticks([1e-14 1e-13 1e-12 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1])

% Sets the title
if title_flag
    title(ts);
end

lh = legend(rl);

set(lh, 'Interpreter', 'none','location','northeast')

% Change the fontsize of everything
set(gca,'fontsize',16);
xlim([0 11])
ylim([1e-12 1e-4 ])

ColorOdrDef = get(gca,'ColorOrder'); %7x3 RGB array
%define your custom color order
ColorOdrCustom = ...
[0.2422       0.1504       0.6603;...
      0.28033      0.27823       0.9221;...
     0.24403      0.43583      0.99883;...
        0.154       0.5902       0.9218;...
      0.029667      0.70817      0.81633;...
      0.19377      0.77577       0.6251;...
      0.5044       0.7993        0.348;...
      0.86343       0.7406      0.15963;...
      0.9892      0.81357      0.18853;...
      0.9769       0.9839       0.0805]; %10x3 RGB array

set(gca,'ColorOrder',ColorOdrCustom);

% Saves as a png
if save_flag
    saveas(gcf,[path_to_png, ss, '.png'])
end

set(gcf,'position',[750 199 1063 654])

end
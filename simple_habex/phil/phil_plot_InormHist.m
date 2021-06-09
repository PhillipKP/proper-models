function [fig_num] = phil_plot_InormHist(mp, out, varargin)

%Inputs:
% mp: The generic stuct at the end of the FALCO run
% out: The out struct at the end of the FALCO run
% 
% Optional Key-Word Pair Input Arguments
% 'title', 'Enter the title for your figure here'
%
% 'save', 'Enter the name of your saved PNG file here'
% NOTE: It will not save a png unless you enter both.
%
% Outputs:
% fig_num: The figure number


% EXAMPLE:
% phil_plot_InormHist(mp, out, 'title','Enforce Constraints At Beginning', 'save','Enforce Constraints At Beginning')



%%%%

format short g

disp('NI History');
disp(out.InormHist.')

nargin

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
                
                if ischar(  varargin{icav + 1})
                    ts = varargin{icav + 1};
                    title_flag = true;

                end
                
                
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


if nargin == 3
    
    fig_num = varargin{2};
    figure(fig_num);
    
else
    
    inpfg = figure;
    fig_num = inpfg.Number;
    

    
end



semilogy(0:mp.Nitr, out.InormHist,'-o','linewidth',3);
grid on;

xticks([1:out.Nitr]);
xlabel({'WFSC Iteration',mp.runLabel(1:20)}, 'interpreter', 'none');

%ylim([1e-10 1e-5])
ylabel('Mean NI');

xlim([0 mp.Nitr-1])

if (max(out.InormHist) < 1e-5) && (min(out.InormHist) > 1e-11)
    ylim([1e-11 1e-5 ])
end

yticks([1e-12 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1])



% Sets the title
if title_flag; 
    title(ts); 
end

% Change the fontsize of everything
set(gca,'fontsize',16);

% Saves as a png
if save_flag
    saveas(gcf,[mp.path.ws, 'png/', ss, '.png'])
end





end


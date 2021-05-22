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

for icav = 1:length(varargin)
    
    arg_name = varargin{icav}
    
    if ischar(arg_name)
        
        switch arg_name
            
            
            % Allows user to set the title
            case {'title'}
                
                if ischar(  varargin{icav + 1})
                    ts = varargin{icav + 1};
                    title_flag = true;
                else
                    error('Title must be a char class')
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



semilogy(out.InormHist,'-o','linewidth',3);
grid on;

xticks([1:out.Nitr]);
xlabel('WFSC Iteration');

%ylim([1e-10 1e-5])
ylabel('Mean NI');


% Sets the title
if title_flag; title(ts); end
    
set(gca,'fontsize',16);

% Saves as a png
if save_flag
    saveas(gcf,[mp.path.ws, 'png/', ss, '.png'])
end





end


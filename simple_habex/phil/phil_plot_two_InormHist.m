function [] = phil_plot_two_InormHist(SeriesNum1, TrialNum1, SeriesNum2,...
    TrialNum2, varargin)



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


full_file1_path = phil_build_full_path(SeriesNum1, TrialNum1);
full_file2_path = phil_build_full_path(SeriesNum2, TrialNum2);


load(full_file1_path);
rl1 = mp.runLabel(1:20);

figure;
semilogy(0:mp.Nitr,out.InormHist,'linewidth',3);

load(full_file2_path);
rl2 = mp.runLabel(1:20);

hold all
semilogy(0:mp.Nitr,out.InormHist,'linewidth',3);
hold off

grid on

xlabel('WFSC Iteration', 'interpreter', 'none');
ylabel('Mean NI')

xlim([0 mp.Nitr-1])
ylim([1e-11 1e-4 ])

yticks([ 1e-11 1e-10 1e-9 1e-8 1e-7 1e-6 1e-5 1e-4])

% Sets the title
if title_flag
    title(ts);
end

lh = legend(rl1,rl2);

set(lh, 'Interpreter', 'none')

% Change the fontsize of everything
set(gca,'fontsize',16);

% Saves as a png
if save_flag
    saveas(gcf,[mp.path.ws, 'png/', ss, '.png'])
end

end
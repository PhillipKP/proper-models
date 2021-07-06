function [volt] = phil_gen_drift_volt_std(Nact, des_std, num_steps, varargin)




% The number of actuators on each DM
volt.Nact = Nact;

% Desired PV
volt.des_std = des_std;

% Number of steps in time
volt.num_steps = num_steps;

% Initial stack to store the voltages
volt.stack = zeros(Nact, Nact, num_steps);


for ri = 1:Nact
    for ci = 1:Nact
        
        clear displacement x
        
        displacement = randn(1,num_steps);
        x = cumsum(displacement);
        
        %figure(42);plot(x);
        
        mean_x = mean(x);
        
        % The standard deviation before scaling
        stdxb = std(x);
        
        % Subtract off the mean
        x = x - mean_x;
        
        % Scale to the new standard deviation
        x = (volt.des_std / stdxb) * x;
        
        
        % Restore to the previous mean
        x = x + mean_x;
        
        % Make it start at zero
        x = x - x(1);
        
        %std(x), mean(x),
        %figure(43);plot(x);
        
        % Insert x into the stack of voltages
        volt.stack(ri,ci,:) = x;
        
    end
end


% Compute the std of the entire stack not just individual channels
volt.stack_std = std(volt.stack(:));




% 
% vs11 = squeeze(volt.stack(1,1,:));
% vs12 = squeeze(volt.stack(1,2,:));
% vs21 = squeeze(volt.stack(2,1,:));
% vs22 = squeeze(volt.stack(2,2,:));
% 
% 
% figure;
% plot(vs11/(1e-3),'linewidth',3);
% hold all
% plot(vs12/(1e-3),'linewidth',3);
% plot(vs21/(1e-3),'linewidth',3);
% plot(vs22/(1e-3),'linewidth',3);
% grid on
% ylabel('Drift from Initial Voltage [mV]')
% xlabel('Time Step [Arb. Units]')
% set(gca,'fontsize',16)
% hold off


end


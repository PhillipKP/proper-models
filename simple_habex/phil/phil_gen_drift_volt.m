function [volt] = phil_gen_drift_volt(Nact, des_pv, num_steps, varargin)

% Normalize each channel's voltages by des_pv
volt.ind_pv = false;

% Normalize the entire stack of voltages by des_pv
volt.stack_pv = true;

% The number of actuators on each DM
volt.Nact = Nact;

% Desired PV
volt.des_pv = des_pv;

% Number of steps in time
volt.num_steps = num_steps;

% Initial stack to store the voltages
volt.stack = zeros(Nact, Nact, num_steps);


for ri = 1:Nact
    for ci = 1:Nact
        
        clear displacement x
        displacement = randn(1,num_steps);
        
        x = cumsum(displacement);
        
        % Normalize each actuator to the desired PV
        if volt.ind_pv
        
            % Before PV
            pvxb = max(x) - min(x);
            
            % Normalize each e
            x = (x / pvxb) * des_pv;
            
        end
        
        volt.avg_pv(ri,ci) = max(x) - min(x);
        volt.stack(ri,ci,:) = x;
        
    end
end




pvsb = max(volt.stack(:)) - min(volt.stack(:));

if volt.stack_pv
    volt.stack = (volt.stack / pvsb) * des_pv;
end


volt.pvsa = max(volt.stack(:)) - min(volt.stack(:));


% 
% 
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


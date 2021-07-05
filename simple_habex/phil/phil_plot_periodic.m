function [] = phil_plot_periodic(SeriesVec, TrialVec)


if length(SeriesVec) == 1
    SeriesVec = SeriesVec*ones(size(TrialVec));
end

amp_list = [];
avg_ni_list = [];
delta_ni_list = [];



for fi = 1:length(TrialVec)
  
    [path] = return_path_for_noise_trials(SeriesVec, TrialVec, fi)
    
    load(path.full)
   
    
    
    amp_list = [amp_list run.amplitude];
    
    
    
    avg_ni_list = [avg_ni_list run.avg_ni];
    
    delta_ni_list = [delta_ni_list run.delta_ni];
    
    
end

% figure;
% plot(amp_list, avg_ni_list,'linewidth',3)
% xlabel('Amplitude [Volt]')
% ylabel('Mean NI after Periodic Voltage Added')
% title({'Mean NI vs Amplitude','with starting NI=8.6e-12. 10 Samples '})
% grid on
% set(gca,'fontsize',16)


figure;
plot(amp_list/(1e-3) ,  delta_ni_list/(1e-11),'linewidth',3)
xlabel('Amplitude [mV]')
ylabel('Delta NI (1e-11)')
title({'Delta NI vs Amplitude ','with starting NI=8.6e-12. 10 Samples '})
grid on
set(gca,'fontsize',16)


figure;
plot( (amp_list / sqrt(2)) / (1e-3) , delta_ni_list/(1e-11),'linewidth',3)
xlabel('RMS [mV]')
ylabel('Delta NI (1e-11)')
title({'Delta NI vs RMS ','with starting NI=8.6e-12. 10 Samples '})
grid on
set(gca,'fontsize',16)



% figure;
% plot(amp_list/(1e-3), delta_ni_list/(1e-11),'linewidth',3)
% xlabel('Amplitude [mV]')
% ylabel('Delta NI (1e-11)')
% title({'Delta NI vs Noise Std','with starting NI=8.6e-12. 10 Samples'})
% grid on
% %yticks([0 1 -0.2 0 0.2 0.8 1])
% set(gca,'fontsize',16)
% 
% figure;
% plot(amp_list*1e-9, delta_ni_list/(1e-12),'linewidth',3)
% xlabel('Amplitude [pm]')
% ylabel('Delta NI (1e-11)')
% title({'Mean NI vs Amplitude','with starting NI=8.6e-12. 10 Samples'})
% grid on
% set(gca,'fontsize',16)

end
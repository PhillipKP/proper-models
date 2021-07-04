function [] = phil_plot_noise(SeriesVec, TrialVec, VtoH)


if length(SeriesVec) == 1
    SeriesVec = SeriesVec*ones(size(TrialVec));
end

std_list = [];
avg_ni_list = [];
delta_ni_list = [];



for fi = 1:length(TrialVec)
   
    SeriesNum = SeriesVec(fi)
    TrialNum = TrialVec(fi)
    
   
    label = ['Series', num2str(SeriesNum,'%04.f'), '_Trial', num2str(TrialNum,'%04.f') ''];

    if ismac
        
        path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' label '/'];
        path.ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];
    end
    
    
    path.full = [path.ws label '.mat']
        
    load(path.full)
   
    std_list = [std_list run.noise_std];
    
    avg_ni_list = [avg_ni_list run.avg_ni];
    
    delta_ni_list = [delta_ni_list run.delta_ni];
    
    
end



figure;
plot(std_list/(1e-3), avg_ni_list,'linewidth',3)
xlabel('Noise Std [mV]')
ylabel('Mean NI after Noise Added')
title({'Mean NI vs Noise Std','with starting NI=8.6e-12. 100 Noise Trials'})
grid on
set(gca,'fontsize',16)

figure;
plot(std_list/(1e-3), delta_ni_list/(1e-11),'linewidth',3)
xlabel('Noise Std [mV]')
ylabel('Delta NI (1e-11)')
title({'Delta NI vs Noise Std','with starting NI=8.6e-12. 100 Noise Trials'})
grid on
set(gca,'fontsize',16)


figure;
plot(std_list / VtoH, avg_ni_list,'linewidth',3)
xlabel('Noise Std [x10 nm]')
ylabel('Mean NI after Noise Added')
title({'Mean NI vs Noise Std','with starting NI=8.6e-12. 100 Noise Trials'})
grid on
set(gca,'fontsize',16)

end
clear all
close all
clc

% For the x-axis variables.
paa.amplitude_list = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1];
paa.rms_list = paa.amplitude_list / sqrt(2);

paa.mean_delta_ni_list = [2.48E-13 9.94E-13 2.24E-12 3.96E-12 6.16E-12...
    8.94E-12 1.22E-11 1.58E-11 2.01E-11 2.55E-11 3.00E-11];

paa.std_of_the_mean_list = [9.14E-15 3.65E-14 7.82E-14 1.21E-13 1.93E-13...
    3.24E-13 4.13E-13 5.00E-13 6.31E-13 4.95E-13 1.08E-12];

% figure
% % errorbar(rms_list,mean_delta_ni_list/(1e-11),...
% %     std_of_the_mean_list/(1e-11),'linewidth',3,...
% %     'color',[0 0 0])
% grid on
% xlabel('RMS Voltage [mV]')
% ylabel('Delta NI [1E-11]')
% title('Periodic voltage on all actuators both DMs')
% set(gca,'fontsize',16)

% Zero Mean Normally Distrubuted Noise on All Actuators
naa.std_list = [0.1000    0.2000    0.3000    0.4000    0.5000 ...
    0.6000    0.7000    0.8000 ]
naa.mean_delta_ni_list = 


figure;
plot(paa.amplitude_list, paa.mean_delta_ni_list/1e-11,'linewidth',3)
grid on
xlabel('Voltage Amplitude [mV]')
ylabel('Delta NI (1E-11)')
title('Periodic Noise on All Actuators on Both DMs')

set(gca,'fontsize',16)


figure;
plot(paa.rms_list, paa.mean_delta_ni_list/1e-11,'linewidth',3)
grid on
xlabel('Voltage RMS [mV]')
ylabel('Delta NI (1E-11)')
title('Periodic Noise on All Actuators on Both DMs')
xlim([0 1])
ylim([0 3])
set(gca,'fontsize',16)

return
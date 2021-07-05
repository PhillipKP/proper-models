
num_samples = 10;
run.freq = 1;

run.amplitude = 0.024


Itr = 8;
SeriesNum = 2;
TrialNum = 6;
save_dir = 'noise';

%phil_add_paths; % Gets the mp.path.itr

itr_name = ['Series', num2str(SeriesNum,'%04.f'), 'Trial', num2str(TrialNum,'%04.f'), '_Itr_', num2str(Itr)];

if ismac
    path_to_file = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
else
    path_to_file = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
end

itr_file = [path_to_file itr_name '.mat'];

load(itr_file,'mp','out');

origDm1V = mp.dm1.V;
origDm2V = mp.dm2.V;
origDm1FlatMap = mp.full.dm1.flatmap;

volt_vec = []

mpo.dm1.surfM = falco_gen_dm_surf(mp.dm1, mp.dm1.dx, mp.dm1.NdmPad);
mpo.dm2.surfM = falco_gen_dm_surf(mp.dm2, mp.dm2.dx, mp.dm2.NdmPad);
    
for t = linspace(0,1,num_samples)
    
    disp(['Phase :', num2str(t), ' (2*pi)'])
    
    volt_val = run.amplitude*sin(2*pi*run.freq*t)
    
    volt_vec = [volt_vec volt_val];
    

    
    mp.dm1.V(run.dm1_mid_ind,run.dm1_mid_ind) = origDm1V(run.dm1_mid_ind,run.dm1_mid_ind) + volt_val;
    mp.dm2.V(run.dm2_mid_ind,run.dm2_mid_ind) = origDm2V(run.dm2_mid_ind,run.dm2_mid_ind) + volt_val;
    
    
    mp.dm1.surfM = falco_gen_dm_surf(mp.dm1, mp.dm1.dx, mp.dm1.NdmPad);
    mp.dm2.surfM = falco_gen_dm_surf(mp.dm2, mp.dm2.dx, mp.dm2.NdmPad);
    
    figure;
    
    subplot(1,3,1)
    imagesc(mpo.dm1.surfM / (1e-9) )
    title('Original DM1 (nm)')
    axis equal; axis tight;
    colorbar;
    set(gca,'fontsize',18)

    
    subplot(1,3,2)
    imagesc(mp.dm1.surfM / (1e-9))
    title('Corrupted DM1 (nm) ')
    axis equal; axis tight;
    colorbar;
    set(gca,'fontsize',18)

    subplot(1,3,3)
    imagesc( (mpo.dm1.surfM - mp.dm1.surfM)/ (1e-12) )
    title('Difference (pm)')
    axis equal; axis tight;
    colorbar;
    set(gca,'fontsize',18)
    
    set(gcf,'position',[-1414 786 1366 322])
    
    
end

figure;
plot(linspace(0,1,num_samples), volt_vec/(1e-3),'linewidth',3)
grid on
title('Plot of Voltage Added to Actuator 32,32 over Time')
ylabel('Voltage added [mV]')
xlabel('Cycles [Arb. Unit]')
set(gca,'fontsize',18)


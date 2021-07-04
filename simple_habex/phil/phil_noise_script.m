function [run] = phil_noise_script(InputSeriesNum, InputTrialNum, noise_std)

%close all




run.SeriesNum = InputSeriesNum;
run.TrialNum  = InputTrialNum;


run.start_time = now;
run.flagPlot = false;
run.savePlot = false;

run.noise_std = noise_std;

run.noise_std_in_meters = run.noise_std * 1e-9;

run.num_noise_trials = 10;

run.loadFlag = true;

%% Initial File and Directory Handling

run.label = ['Series', num2str(run.SeriesNum,'%04.f'), '_Trial', num2str(run.TrialNum,'%04.f') ''];

run.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' run.label '/'];
run.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];

if ~exist(run.path.png)
    mkdir(run.path.png);
end



%% Information for the save file to load

Itr = 8;
SeriesNum = 2;
TrialNum = 5;
save_dir = 'noise'



%phil_add_paths; % Gets the mp.path.itr

itr_name = ['Series', num2str(SeriesNum,'%04.f'), 'Trial', num2str(TrialNum,'%04.f'), '_Itr_', num2str(Itr)];

path_to_file = '/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series0002_Trial0005/'

itr_file = [path_to_file itr_name '.mat']

    load(itr_file,'mp','out');
    
    origDm1V = mp.dm1.V;
    origDm2V = mp.dm2.V;
    origDm1FlatMap = mp.full.dm1.flatmap;


summedImage_tot = zeros(182,182);



%% Begin looping
for nitr = 1: run.num_noise_trials
    
    
    
    mp.dm1.V = origDm1V + run.noise_std*randn(64,64);
    mp.dm2.V = origDm2V + run.noise_std*randn(64,64);
    
    if run.flagPlot
        figure(100);
        subplot(1,2,1);
        imagesc(mp.dm1.V); colorbar;
        title('mp.dm1.V');
        axis equal; axis tight;
        subplot(1,2,2);
        imagesc(mp.dm2.V); colorbar;
        axis equal; axis tight;
        title('mp.dm2.V');
        
        if run.savePlot
            saveas(gcf, [run.path.png run.label '_DeltaV_Itr' num2str(nitr) '.png']);
        end
    end
    
    if any(mp.dm_ind == 1)
        mp.dm1.surfM = falco_gen_dm_surf(mp.dm1, mp.dm1.dx, mp.dm1.NdmPad);
    end
    if any(mp.dm_ind == 2)
        mp.dm2.surfM = falco_gen_dm_surf(mp.dm2, mp.dm2.dx, mp.dm2.NdmPad);
    end
    if any(mp.dm_ind == 9)
        mp.dm9.phaseM = falco_dm_surf_from_cube(mp.dm9, mp.dm9);
    end
    
    if run.flagPlot
        figure(101);
        subplot(1,2,1)
        imagesc(mp.dm1.surfM/1e-9); colorbar;colorbar;
        title('DM1 Surface [nm]')
        axis equal; axis tight;
        subplot(1,2,2)
        imagesc(mp.dm2.surfM/1e-9); colorbar;
        title('DM2 Surface [nm]')
        axis equal; axis tight;
        set(gcf,'position',[1440 902 810 436])
        
        
        if run.savePlot
            saveas(gcf, [run.path.png run.label '_Instant_DMSurf_Itr' num2str(nitr) '.png']);
        end
    end
    
    % summedImage is
    summedImage = 0;
    for iSubband = 1:mp.Nsbp
        
        subbandImage = falco_get_sim_sbp_image(mp, iSubband);
        
        summedImage = summedImage +  mp.sbp_weights(iSubband)*subbandImage;
    end
    
    %NI for this iteration
    itr_ni = mean(summedImage(mp.Fend.corr.maskBool));
    
    
    
    % Plot the local NI
    figure(102);
    imagesc(log10(summedImage)); colorbar;
    title(['Image for Noise Itr ', num2str(nitr), '. NI = ', num2str(itr_ni), ''])
    axis equal; axis tight; colorbar;
    drawnow;
    if run.savePlot
        saveas(gcf, [run.path.png run.label '_Instant_DH_Itr' num2str(nitr) '.png'])
    end
    
    % Perform a running sum
    summedImage_tot = summedImage_tot + summedImage;
    
    % Calculate the current avg NI
    curr_avg_image = 1/nitr * summedImage_tot;
    curr_avg_NI = mean(curr_avg_image(mp.Fend.corr.maskBool));
    
    disp(['Itr: ', num2str(nitr) '  The NI for this noise trial is: ', num2str(itr_ni), '.  Avg NI: ', num2str(curr_avg_NI) ''])
    
    
end

%% Process noise trials

% Average
run.avg_img = (1/run.num_noise_trials) * summedImage_tot;

% Compute NI
run.avg_ni = mean(run.avg_img(mp.Fend.corr.maskBool));


disp(['The Average NI is ', num2str(run.avg_ni), ' '])

if run.flagPlot
    % Plot the local NI
    figure(104);
    imagesc(log10(run.avg_img)); colorbar;
    title({['Averaged Image Over ', num2str(run.num_noise_trials), ' Noise Trials.'],['The Average NI is ', num2str(run.avg_ni), '']})
    axis equal; axis tight; colorbar;
    drawnow;
    
    if run.savePlot
        saveas(gcf, [run.path.png run.label '_Mean_DH.png'])
    end
    
end

run.end_time = now;

run.run_time = run.end_time - run.start_time;

thing = toc;
save([run.path.ws run.label '.mat'],'run');

end

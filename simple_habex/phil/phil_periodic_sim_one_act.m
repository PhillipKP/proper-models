function [run] = phil_periodic_sim_one_act(InputSeriesNum, InputTrialNum, amplitude, varargin)

%close all
%clearvars


run.SeriesNum = InputSeriesNum;
run.TrialNum  = InputTrialNum;
run.amplitude = amplitude;

run.start_time = now;
run.flagPlot = true;
run.savePlot = true;
run.num_samples = 10;

run.freq = 1;
run.VtoH = 10e-9;

if ismac
    run.map_dir = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/maps_dir/';
end

run.amplitude_meters = run.amplitude * 1e-9;


run.loadFlag = true;


for icav = 1:length(varargin)
    
    arg_name = varargin{icav}
    
    if ischar(arg_name)
        
        switch arg_name
            % Allows user to set the title
            
            case {'num_samples'}
                
                run.num_samples = varargin{icav + 1};
                
            case {'vtoh','VtoH','gain'}
                
                % ts is the title string
                run.VtoH = varargin{icav + 1};
                
                
            case {'flagPlot'}
                
                fpbool = varargin{icav + 1};
                
                run.flagPlot = fpbool;
                
            case {'computeDelta','compute_delta','computedelta'}
                
                % cdbool must a boolean value
                cdbool = varargin{icav + 1};
                run.computeDelta = cdbool;
                
        end
    end
    
end

%% Initial File and Directory Handling

run.label = ['Series', num2str(run.SeriesNum,'%04.f'), '_Trial', num2str(run.TrialNum,'%04.f') ''];

if ismac
    run.path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' run.label '/'];
    run.path.ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];
else
    run.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' run.label '/'];
    run.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];
end

if ~exist(run.path.png)
    mkdir(run.path.png);
end



%% Information for the save file to load
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


%- Overwrite the map_dir if on Phillip's Macbook Pro
if ismac
    mp.full.map_dir = run.map_dir;
end


%%


%- Compute the NI that correspond to perfect DMs at this FALCO iteration
if run.computeDelta
    
    summedImage = 0;
    for iSubband = 1:mp.Nsbp
        subbandImage = falco_get_sim_sbp_image(mp, iSubband);
        summedImage = summedImage +  mp.sbp_weights(iSubband)*subbandImage;
    end
    run.original_ni =  mean(summedImage(mp.Fend.corr.maskBool));
    disp(['Original NI: ' num2str(run.original_ni) ''])
end

summedImage_tot = zeros(182,182);

%% Overwrite Gain

mp.dm1.VtoH = run.VtoH*ones(mp.dm1.Nact);
mp.dm2.VtoH = run.VtoH*ones(mp.dm2.Nact);

%% Begin looping


run.dm1_mid_ind = floor(mp.dm1.Nact/2);
run.dm2_mid_ind = floor(mp.dm2.Nact/2);

tl = linspace(0,1,run.num_samples);

volt_val_vec = [];

for titr = 1: run.num_samples
    
    t = tl(titr);
    
    volt_val = run.amplitude*sin(2*pi*run.freq*t);
    
    %
    volt_val_vec = [volt_val_vec volt_val];
    
    % Added to the original signal
    mp.dm1.V(run.dm1_mid_ind,run.dm1_mid_ind) = origDm1V(run.dm1_mid_ind,run.dm1_mid_ind) + volt_val;
    mp.dm2.V(run.dm2_mid_ind,run.dm2_mid_ind) = origDm2V(run.dm2_mid_ind,run.dm2_mid_ind) + volt_val;
    
    if run.flagPlot
        
        figure(100);
        subplot(1,2,1);
        imagesc(mp.dm1.V); colorbar;
        title(['mp.dm1.V Phase Sample', num2str(t) '']);
        axis equal; axis tight;
        subplot(1,2,2);
        imagesc(mp.dm2.V); colorbar;
        axis equal; axis tight;
        title(['mp.dm2.V Phase Sample', num2str(t) '']);
        
       
        
        if run.savePlot
            saveas(gcf, [run.path.png run.label '_DeltaV_Itr' num2str(titr) '.png']);
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
        
        f = figure(101);
        p = uipanel('Parent',f,'BorderType','none');
        p.Title = ['DM Surf. Phase = ', num2str(t), ' (2*pi)'];
        p.TitlePosition = 'centertop';
        p.FontSize = 12;
        p.FontWeight = 'bold';
        
        
        %figure(101);
        subplot(1,2,1,'Parent',p)
        imagesc(mp.dm1.surfM/1e-9); colorbar;colorbar;
        title('DM1 Surface [nm]')
        axis equal; axis tight;
        subplot(1,2,2,'Parent',p)
        imagesc(mp.dm2.surfM/1e-9); colorbar;
        title('DM2 Surface [nm]')
        axis equal; axis tight;
        %set(gcf,'position',[1440 902 810 436])
         set(gcf,'position',[181 217 810 435])
        
        if run.savePlot
            saveas(gcf, [run.path.png run.label '_Instant_DMSurf_Itr' num2str(titr) '.png']);
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
    title(['Image for Noise Itr ', num2str(titr), '. NI = ', num2str(itr_ni), ''])
    axis equal; axis tight; colorbar;
    drawnow;
    if run.savePlot
        saveas(gcf, [run.path.png run.label '_Instant_DH_Itr' num2str(titr) '.png'])
    end
    
    % Perform a running sum
    summedImage_tot = summedImage_tot + summedImage;
    
    % Calculate the current avg NI
    curr_avg_image = 1/titr * summedImage_tot;
    curr_avg_NI = mean(curr_avg_image(mp.Fend.corr.maskBool));
    
    disp(['Itr: ', num2str(titr) '  The NI for this time sample is: ', num2str(itr_ni), '.  Avg NI: ', num2str(curr_avg_NI) ''])
    
    
end

%% Process noise trials

% Average
run.avg_img = (1/run.num_samples) * summedImage_tot;

% Compute NI
run.avg_ni = mean(run.avg_img(mp.Fend.corr.maskBool));


disp(['The Average NI is ', num2str(run.avg_ni), ' '])

if run.computeDelta
    run.delta_ni = run.avg_ni - run.original_ni;
    disp(['The Delta NI is ', num2str(run.delta_ni), ' '])
end


if run.flagPlot
    % Plot the local NI
    figure(104);
    imagesc(log10(run.avg_img)); colorbar;
    title({['Averaged Image Over ', num2str(run.num_samples), ' Noise Trials.'],['The Average NI is ', num2str(run.avg_ni), '']})
    axis equal; axis tight; colorbar;
    drawnow;
    
    if run.savePlot
        saveas(gcf, [run.path.png run.label '_Mean_DH.png'])
    end
    
    
    figure(105);
    plot(volt_val_vec);
    title('Voltage Added vs Phase')
    ylabel('Added Voltage')
    xlabel('Phase ')
end



run.end_time = now;

run.run_time = run.end_time - run.start_time;

thing = toc;
save([run.path.ws run.label '.mat'],'run');

end

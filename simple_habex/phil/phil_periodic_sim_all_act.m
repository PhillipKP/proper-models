function [run] = phil_periodic_sim_all_act(InputSeriesNum, InputTrialNum, amplitude, varargin)

%close all
%clearvars


run.SeriesNum = InputSeriesNum;
run.TrialNum  = InputTrialNum;
run.amplitude = amplitude;

run.start_time = now;
run.flagPlot = false;
run.savePlot = true;
run.num_samples = 10;

run.freq = 1;
run.VtoH = 10e-9;

run.amplitude_meters = run.amplitude * run.VtoH;


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

if isunix
    run.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' run.label '/'];
    run.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];
else
    run.path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/png/' run.label '/'];
    run.path.ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/'];
    
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



tl = linspace(0,1,run.num_samples);



% Allocate memory to store the stack of voltage commands
run.dm1.stack = zeros(mp.dm1.Nact, mp.dm1.Nact, run.num_samples);
run.dm2.stack = zeros(mp.dm2.Nact, mp.dm2.Nact, run.num_samples);


% 2D matrix
run.dm1.init_phase = 2*pi*rand(mp.dm1.Nact);
run.dm2.init_phase = 2*pi*rand(mp.dm2.Nact);

for titr = 1: run.num_samples
    
    t = tl(titr);
    
    % The voltage that will be added to the original voltage on DM1 and DM2
    dm1_volt_val = run.amplitude*sin(2*pi*run.freq*t + run.dm1.init_phase);
    dm2_volt_val = run.amplitude*sin(2*pi*run.freq*t + run.dm2.init_phase);
    
    %
    run.dm1.stack(:,:,titr) = dm1_volt_val;
    run.dm2.stack(:,:,titr) = dm2_volt_val;
    
    % Added voltage to the original voltage
    mp.dm1.V = origDm1V + dm1_volt_val;
    mp.dm2.V = origDm2V + dm2_volt_val;
    
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

    hold all

    for ri = 1:mp.dm1.Nact
        for ci = 1:mp.dm1.Nact
            plot(tl, squeeze(run.dm1.stack(ri,ci,:)))
        end
    end
    hold off
    if run.savePlot
        saveas(gcf, [run.path.png run.label '_DM1_Volt_Vals.png'])
    end


end



run.end_time = now;

run.run_time = run.end_time - run.start_time;

thing = toc;
save([run.path.ws run.label '.mat'],'run');

end

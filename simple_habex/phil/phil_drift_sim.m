function [run] = phil_drift_sim(SeriesNum, TrialNum, num_steps, drift_type, drift_val)

run.SeriesNum = SeriesNum;
run.TrialNum = TrialNum;

    
run.num_steps = num_steps;

% The gain of DM1 and DM2
run.VtoH = 10e-9;



switch drift_type
    case 'pv'
        run.des_pv = drift_val;
    case 'std'
        run.des_std = drift_val;
end




run.map_dir = '/Users/poon/Documents/dst_sim/proper-models/simple_habex/maps_dir/';


%% Initial File and Directory Handling

run.label = ['Series', num2str(run.SeriesNum,'%04.f'), '_Trial', num2str(run.TrialNum,'%04.f') ''];

if isunix && ~ismac
    
    run.path.png = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise_drift/png/' run.label '/'];
    run.path.ws = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise_drift/'];
else
    run.path.png = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise_drift/png/' run.label '/'];
    run.path.ws = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise_drift/'];
    
end

if ~exist(run.path.png)
    mkdir(run.path.png);
end

%% Load original data
Itr = 8;
SeriesNum = 2;
TrialNum = 6;
save_dir = 'noise_drift';


falco_itr_name = ['Series', num2str(SeriesNum,'%04.f'), 'Trial', num2str(TrialNum,'%04.f'), '_Itr_', num2str(Itr)];

if ismac
    path_to_file = ['/Volumes/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
else
    path_to_file = ['/home/poon/dst_sim/proper-models/simple_habex/workspaces/noise/itr/Series', num2str(SeriesNum,'%04.f'), '_Trial' num2str(TrialNum,'%04.f') '/'];
end
itr_file = [path_to_file falco_itr_name '.mat'];

load(itr_file,'mp','out');

% Need to change the map directory if you are on your macbook
if ismac
    mp.full.map_dir = run.map_dir;
end

run.origDm1V = mp.dm1.V;
run.origDm2V = mp.dm2.V;
run.origDm1FlatMap = mp.full.dm1.flatmap;


%%%- Compute original NI



% Use falco_get_summed_image to compute the original 2D NI
run.orig_img = falco_get_summed_image(mp);

% Compute the original mean NI in the correction region of the 2D NI
run.original_ni =  mean(run.orig_img(mp.Fend.corr.maskBool));

disp(['Original NI: ' num2str(run.original_ni) ''])


%- Overwrite Gain
mp.dm1.VtoH = run.VtoH*ones(mp.dm1.Nact);
mp.dm2.VtoH = run.VtoH*ones(mp.dm2.Nact);


%- Generate drift
switch drift_type
    case 'pv'
        dm1volt = phil_gen_drift_volt(mp.dm1.Nact, run.des_pv, run.num_steps, false);
        dm2volt = phil_gen_drift_volt(mp.dm2.Nact, run.des_pv, run.num_steps, false);
    case 'std'
        dm1volt = phil_gen_drift_volt_std(mp.dm1.Nact, run.des_std, run.num_steps, false);
        dm2volt = phil_gen_drift_volt_std(mp.dm2.Nact, run.des_std, run.num_steps, false);
end

% Initialize for speed
summedImage_tot = zeros(mp.Fend.Neta, mp.Fend.Nxi);



for titr = 1:run.num_steps
    
    %- Apply to all actuators
    
    mp.dm1.V = run.origDm1V + dm1volt.stack(:,:,titr);
    mp.dm2.V = run.origDm2V + dm2volt.stack(:,:,titr);
    
    
    %- Compute corrupted NI
    summedImage = falco_get_summed_image(mp);
    
    %- Compute average NI
    itr_ni = mean(summedImage(mp.Fend.corr.maskBool));
    
    
    %- Perform a running sum
    summedImage_tot = summedImage_tot + summedImage;
    
    
    % Calculate the current avg NI
    curr_avg_image = 1/titr * summedImage_tot;
    curr_avg_NI = mean(curr_avg_image(mp.Fend.corr.maskBool));
    
    disp(['Itr: ', num2str(titr) '  The NI for this time sample is: ', num2str(itr_ni), '.  Avg NI: ', num2str(curr_avg_NI) ''])
    
    
    
end


%% Process noise trials

% Average
run.avg_img = (1/run.num_steps) * summedImage_tot;

% Compute NI
run.avg_ni = mean(run.avg_img(mp.Fend.corr.maskBool));


disp(['The Average NI is ', num2str(run.avg_ni), ' '])


run.delta_ni = run.avg_ni - run.original_ni;
disp(['The Delta NI is ', num2str(run.delta_ni), ' '])

std(dm1volt.stack(:))
std(dm2volt.stack(:))

save([run.path.ws run.label '.mat'],'run');

end
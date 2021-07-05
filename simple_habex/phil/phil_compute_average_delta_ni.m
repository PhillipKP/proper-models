function [data] = phil_compute_average_delta_ni(SeriesVec, TrialNumVec)


if length(SeriesVec) == 1
   SeriesVec = SeriesVec*ones(size(TrialNumVec)); 
end

    
delta_ni_list = [];
    
amplitude_list = [];

for fi = 1:length(TrialNumVec)
   
    path = return_path_for_noise_trials(SeriesVec, TrialNumVec, fi);
    
    load(path.full)
    
    delta_ni_list = [delta_ni_list run.delta_ni];
    
    amplitude_list = [amplitude_list run.amplitude];
    
end

if length(unique(amplitude_list)) > 1
    
    error('amplitude_list has more than 1 unqiue value')
end

data.mean_delta_ni = mean(delta_ni_list);
data.std_of_the_mean_delta_ni = std(delta_ni_list);
data.unique_amplitude_values = unique(amplitude_list);

end
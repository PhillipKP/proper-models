function [data] = phil_compute_average_delta_ni(SeriesVec, TrialNumVec, NoiseType)


if length(SeriesVec) == 1
    SeriesVec = SeriesVec*ones(size(TrialNumVec));
end


delta_ni_list = [];

switch NoiseType
    case 'periodic'
        amplitude_list = [];
    case 'brownian'
        std_list = [];
    otherwise
        error('Noise Type not found')
end


for fi = 1:length(TrialNumVec)
    
    path = return_path_for_noise_trials(SeriesVec, TrialNumVec, NoiseType, fi);
    
    load(path.full)
    
    delta_ni_list = [delta_ni_list run.delta_ni];
    
    switch NoiseType
        case 'periodic'
            amplitude_list = [amplitude_list run.amplitude];
        case 'brownian'
            std_list = [std_list run.des_std];
    end
    
    
    
end


switch NoiseType
    
    case 'periodic'
        
        if length(unique(amplitude_list)) > 1
            error('amplitude_list has more than 1 unqiue value')
        end
        data.unique_amplitude_values = unique(amplitude_list);
        
    case 'brownian'
        
        data.unique_std_values = unique(std_list);
        
        
end

data.mean_delta_ni = mean(delta_ni_list);
data.std_of_the_mean_delta_ni = std(delta_ni_list);




end
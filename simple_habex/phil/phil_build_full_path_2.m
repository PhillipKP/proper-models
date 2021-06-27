function full_path = phil_build_full_path_2(SeriesNum, TrialNum)


if ~(ismac)
    prepath = '/home/'
elseif ismac
    prepath = '/Volumes/'
end
    

switch SeriesNum 
    
    case 0
        mat_dir_path = [prepath,'poon/dst_sim/proper-models/simple_habex/workspaces/pinned_actuators/']
    case 1
        mat_dir_path = [prepath,'poon/dst_sim/proper-models/simple_habex/workspaces/pinned_scheduled/']
        
end
   
file_list = dir(mat_dir_path);
filenames = {file_list.name};

string_to_match = ['Series',num2str(SeriesNum,'%04.f'), '_Trial', num2str(TrialNum,'%04.f')];


Index = find(contains(filenames, string_to_match) .* ~contains(filenames,'copy'));


if length(Index) > 1
    error('More than 1 Match!!!')
end

matfile = filenames{Index};

full_path = [mat_dir_path matfile];
 
end

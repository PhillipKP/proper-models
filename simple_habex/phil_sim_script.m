% This script loops the falco_main_Habex_VC script

clearvars

% Calls falco_main_Habex_VC
SeriesNum = 664;

dm1.pinned = [2016 2017 2018 2019];
dm1.Vpinned = [1000 -1000 1000 -1000];
%
dm2.pinned = [2016 2017 2018 2019];
dm2.Vpinned = [1000 -1000 1000 -1000];

% dm1.pinned = [];
% dm1.Vpinned = [];
%
% dm2.pinned = [];
% dm2.Vpinned = [];


Nitr = 5

for TrialNum = 1:1
    
    dm1.pinned = [2016 2017 2018 2019];
    dm1.Vpinned = [0 0 0 1000];
    %
    dm2.pinned = [];
    dm2.Vpinned = [];
    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
    
end


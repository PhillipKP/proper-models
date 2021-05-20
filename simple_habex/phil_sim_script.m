% This script loops the falco_main_Habex_VC script


% Calls falco_main_Habex_VC
SeriesNum = 666;

dm1.pinned = [];
dm1.Vpinned = [];

dm2.pinned = [];
dm2.Vpinned = [];

Nitr = 2

for TrialNum = 1:1
    
    [mp, out] = falco_main_Habex_VC(Nitr, SeriesNum, TrialNum, dm1, dm2);
    
    
end

clear all
close all
clc


mp1.f1 = zeros(3,3)
mp1.f2 = true
mp1.f3 = 1:4
mp1.f4 = 40.4
mp1.f6 = rand(5)

mp2.f1 = zeros(3,3)
mp2.f2 = true
mp2.f3 = 1:4
mp2.f4 = 40.4
mp2.f5 = rand(4)


isequal(mp1,mp2)

common_fields = intersect( fieldnames(mp1), fieldnames(mp2) )


uncommon_fields_2 = setdiff( fieldnames(mp2), fieldnames(mp1) );

uncommon_fields_1 = setdiff( fieldnames(mp1), fieldnames(mp2) );

uncommon_fields = union(uncommon_fields_1, uncommon_fields_2);

pause(1)
if (isempty(uncommon_fields) == 0) && (isempty(uncommon_fields_1) == 0)
    disp(['The field(s)', uncommon_fields_1, ' is/are in mp1 but not mp2'])
end

if (isempty(uncommon_fields) == 0) && (isempty(uncommon_fields_2) == 0)
    %disp(uncommon_fields_2) 
    disp(['The field(s)', uncommon_fields_2, ' is/are in mp2 but not mp1'])
end



% 
% if isempty(unco
% 
% fn = fieldnames(mp1);
% 
% for k = 1:numel(fn)
%     
%     isequal( mp1.( fn{k} ) , mp
%         
% end

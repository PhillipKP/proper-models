% Phillip K Poon (383H)


clearvars; clc; close all;


% 1. You must type clear functions to clear all functions from memory
% 2. Execute the script or function you want to check
% 3. Type inmem to display all the program files used (mex files need extra
% handling google it)
% 4. Type inmem_list = inmem; save('inmem_list.mat','inmem_list')
% 5. Run this script in the same folder where inmem_list.mat is
% 6. Type the string you want to find
stringToBeFound = ''


load('inmem_list.mat','inmem_list');

[num_of_files,~] = size(inmem_list);

%- Generate a new list of files that has the word 'falco' or 'proper'

proper_falco_only_list = {};
new_counter = 1;


% Goes through inmem_list and creates a new list of files that only have
% the words proper or falco in its path
for file_index = 1:num_of_files
    
    filename_in_cell = inmem_list(file_index);
    
    filename_in_without_extension = filename_in_cell{1};
    
    % Assumes it has a .m extension
    %filename = [filename_in_without_extension '.m'];
    filename = filename_in_without_extension;
    
    %which(filename);
    
    
    % Checkes to see if the words falco or proper is in the path name
    if contains(which(filename),'falco') || contains(which(filename),'proper')
        %which(filename);
        %disp('NOT A DEFAULT MATLAB FILE!');
        proper_falco_only_list{new_counter,1} = filename;
        new_counter = new_counter + 1;
    end
    
end


% Shows the files not included in the new list list
non_included_list = setdiff(inmem_list, proper_falco_only_list)


number_of_files = size(proper_falco_only_list,1);


% list of files that have that string in it
list_of_files_with_str_in_it = {};


counter2 = 1;

for file_ind = 1:number_of_files
    
    
    filename_from_new_list = proper_falco_only_list{file_ind,1};
    
     
    fid = fopen(which(filename_from_new_list));
     
     
     while(~feof(fid))                                           % Execute till EOF has been reached
         
         contentOfFile = fgetl(fid);                             % Read the file line-by-line and store the content
         
         found = strfind(contentOfFile,stringToBeFound);         % Search for the stringToBeFound in contentOfFile
         
         if ~isempty(found)
             
             %foundString = strcat('Found in file------', filename_from_new_list);
             
             %disp(foundString);
             
             list_of_files_with_str_in_it{counter2,1} = filename_from_new_list;
             
             counter2 = counter2 + 1;
             
             break;
             
         end
         
     end
     
     fclose(fid);
    
end


for fi = 1:length(list_of_files_with_str_in_it)
   
    filename = list_of_files_with_str_in_it{fi,1};
    filename = [filename '.m'];
    
    foundString = strcat(sprintf('\nFound in file------'), filename);
    disp(foundString)
    line_nums_matched = find_line_nums_in_file(filename,stringToBeFound);
    
    for lni = line_nums_matched
       jumptoline(filename,lni,'concise') 
    end
    
end


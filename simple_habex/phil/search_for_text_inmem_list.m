% Phillip K Poon (383H)
% phillip.poon@jpl.nasa.gov
% For NASA JPL Internal Use Only
% Not Licensed for External Use.
% Last updated 26 May 2021

function [] = search_for_text_inmem_list(stringToBeFound)

% READ ME!
%
% GENERAL DESCRIPTION:
% This function searches inmem_list for files that have the words
% 'falco' or 'proper' in the path string and creates a new cell array with
% only those files called 'proper_falco_only_list'. It then creates a 
% list, which is a subset of the first list. This list has files with only 
% that string you want to find. It then searches for the line numbers where 
% the strings appear and displays them as linkable text for you to click on.
%
%
% WARNING:
% Before running this function you must have a *.mat file names
% inmem_list.mat which contains a cell array named 'inmem_list'
% This is the list of all the functions, scripts, and other dependancies
% that your script depends on.
%
% EXACT STEPS FOR CREATING 'inmem_list.mat'
% 1. You must type 'clear functions' in the command window to clear all functions from memory
% 2. Execute the script or function you want to check for dependancies
% 3. Type inmem to display all the files used (mex files need extra handling I don't cover that here, google it)
% 4. Type 'inmem_list = inmem'; save('inmem_list.mat','inmem_list')
% 5. Make sure this function and inmem_list.mat are visible in the same
% path



% This must exist in your path somewhere.
load('inmem_list.mat','inmem_list');


%- PART 1: Create a smaller list of files with tje word 'falco' or 'proper'
%in the path
[num_of_files,~] = size(inmem_list);

%- Initialize a new list of files that has the word 'falco' or 'proper'
proper_falco_only_list = {};

new_counter = 1;

for file_index = 1:num_of_files
    
    filename_in_cell = inmem_list(file_index);
    
    filename_in_without_extension = filename_in_cell{1};
    
    % Assumes it has a .m extension
    %filename = [filename_in_without_extension '.m'];
    filename = filename_in_without_extension;
    
    
    % Check to see if the words 'falco' or 'proper' is in the path name
    if contains(which(filename),'falco') || contains(which(filename),'proper')

        proper_falco_only_list{new_counter,1} = filename;
        new_counter = new_counter + 1;
    end
    
end


% Shows the files not included in the new list. Currently not used.
non_included_list = setdiff(inmem_list, proper_falco_only_list);


number_of_files = size(proper_falco_only_list,1);


%- PART 2: Searches the second list to see which files contain that string in the
%file

% list of files that have that string in it
list_of_files_with_str_in_it = {};
% initialize counting variable
counter2 = 1;

for file_ind = 1:number_of_files
    
    % Gets the a filename
    filename_from_new_list = proper_falco_only_list{file_ind,1};
    
    % Opens the file for reading
    fid = fopen(which(filename_from_new_list));
    
    % Execute till EOF has been reached
    while(~feof(fid))                                           
        
        % Read the file line-by-line and store the content
        contentOfFile = fgetl(fid);                             
        % Search for the stringToBeFound in contentOfFile
        found = strfind(contentOfFile,stringToBeFound);         
        
        % If found is not empty adds it to a new list of files with the
        % string in it
        if ~isempty(found)
            
            list_of_files_with_str_in_it{counter2,1} = filename_from_new_list;
            counter2 = counter2 + 1;
            
            % Break the while loop for reading this file
            break;
            
        end
        
    end
    
    % Closes this file for reading
    fclose(fid);
    
end


%- PART 3: Now you have a list of files with 'proper' or 'falco' in the 
% path AND have the string you want to find in it.
% This  next step is to find line numbers they are on and display them as
% linkable text you can click on. 
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

end
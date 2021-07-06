
function [whichline] = find_line_nums_in_file(filename, string_to_find)

%clearvars; close all; clc;

%filename = 'falco_wfsc_loop.m'
%string_to_find = 'ev.Im'

A = regexp(fileread(filename),'\n','split');
whichline = find(contains(A,string_to_find));





end

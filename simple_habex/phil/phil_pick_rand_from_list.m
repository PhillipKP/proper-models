function [list] = phil_pick_rand_from_list(input_list, num)


msize = numel(input_list);

list = input_list(randperm(msize, num));

end

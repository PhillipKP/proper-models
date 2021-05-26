function [dmm_ind] ...
    = phil_gen_stuck_acts_in_rows(Nact, Num_Stuck, allincol )


nsa = Num_Stuck;

dmm = zeros(Nact,Nact);

ri = randi(64,1);
ci = randi(64,1);


if allincol == true
    dmm(ri:ri + nsa, ci) = 1;
else
    dmm(ri, ci:ci+nsa) = 1;
end

dmm_ind = find(dmm(:));


end
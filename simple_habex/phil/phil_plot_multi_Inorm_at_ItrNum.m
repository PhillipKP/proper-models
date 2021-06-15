function [] = phil_plot_multi_Inorm_at_ItrNum(SeriesList, TrialNumList, ItrNum)


ni_list = [];

for FI = 1:length(SeriesList)
    
    SeriesNum = SeriesList(FI)
    TrialNum  = TrialNumList(FI)
    
    load(phil_build_full_path(SeriesNum, TrialNum),'out')
    
    ni_list = [ni_list out.InormHist(ItrNum+1)]
    
end

plot(ni_list,'o-','linewidth',3)

xlabel('Number of Pinned Actuators on DM1 and DM2')
ylabel('Mean NI on Itr 0')

end
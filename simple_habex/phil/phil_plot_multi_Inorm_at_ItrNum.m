function [] = phil_plot_multi_Inorm_at_ItrNum(SeriesNumVec, TrialNumVec, bwVec, owaVec, nsbpVec, ItrNum)

ni_list = [];
xaxis = [];


% Instead of explicitely given each element in the vector
if length(bwVec) == 1
    bwVec = bwVec*ones(size(TrialNumVec));
end
if length(SeriesNumVec) == 1
    SeriesNumVec = SeriesNumVec*ones(size(TrialNumVec));
end
if length(owaVec) == 1
    owaVec = owaVec*ones(size(TrialNumVec));
end
if length(nsbpVec) == 1
    nsbpVec = nsbpVec*ones(size(TrialNumVec));
end



for FI = 1:length(TrialNumVec)
    
    SeriesNum = SeriesNumVec(FI);
    TrialNum  = TrialNumVec(FI);
    lams      = nsbpVec(FI);
    bw        = bwVec(FI);
    owa       = owaVec(FI);
    
    load(phil_build_full_path(SeriesNum, TrialNum, 'owa', owa, 'nsbp', lams, 'bw', bw), 'mp','out');
    
    ni_list = [ni_list out.InormHist(ItrNum+1)];
    xaxis = [xaxis length(mp.dm1.pinned) ];
    
end



figure
semilogy(xaxis, ni_list,'o-','linewidth',3)
grid on
xlabel('Number of Pinned Actuators on DM1 and DM2')
ylabel(['Mean NI on Itr ', num2str(ItrNum), ''])
set(gca,'fontsize',16)
set(gcf,'position',[  2661         145         828         420])


end
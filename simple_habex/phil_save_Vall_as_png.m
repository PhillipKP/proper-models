function [] = phil_save_Vall_as_png(mp,out,title_str, save_str)

Nitr = mp.Nitr + 1;


maxV = max(max([ out.dm1.Vall(:) out.dm2.Vall(:) ]));
minV = min(min([ out.dm1.Vall(:) out.dm2.Vall(:) ]));


for itr = 1:Nitr

    % Save DM1 Voltages as a figure
    figure;
    imagesc(out.dm1.Vall(:,:,itr),[ minV maxV])
    colorbar
    title([title_str, ' DM1 ',num2str(itr)])
    
    
    fn1 = [mp.path.ws,'png/',mp.runLabel,save_str, num2str(itr), '_dm1.png'];
    
    saveas(gcf,fn1)
    
    
    
     % Save DM2 Voltages as a figure
    figure;
    imagesc(out.dm2.Vall(:,:,itr),[minV maxV])
    colorbar
    title([title_str, ' DM2 ',num2str(itr)])
    
    
    fn2 = [mp.path.ws,'png/',mp.runLabel,save_str, num2str(itr), '_dm2.png'];
    
    saveas(gcf,fn2)
    
    
    itr

end



end

function [] = phil_plot_sms(SeriesNum, TrialNum, Itr)

load(phil_build_full_path_2(SeriesNum, TrialNum),'mp','out');

s = out.sm{Itr};
alpha2 = out.alpha2{Itr};

figure(401);
if(Itr == 1); hold off; end
loglog(out.sm{Itr}.^2/out.alpha2{Itr},smooth(out.smspectra{Itr},31), 'Linewidth', 2,...
    'Color', [0.3, 1-(0.2+Itr/mp.Nitr)/(1.3), 1]);
grid on; set(gca,'minorgridlines','none')
set(gcf,'Color',[1 1 1]);
title(['Singular Mode Spectrum. Iteration: ', num2str(Itr), ''])%,'Fontsize',20)
xlim([1e-10, 2*max(s.^2/alpha2)])
ylim([1e-12, 1e-0])
drawnow;
hold on;

set(gca,'fontsize',14)

end
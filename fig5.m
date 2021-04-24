%% Replicating Figure 5 from "Asset Pricing and FOMC Press Conferences"
% ########################################################################### %
% Written by:                                                                 %
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg                     %
% Department of Economics and Business Economics                              %
% Aarhus University and CREATES                                               %
%                                                                             %
% Encoding: UTF8                                                              %
% Last modified: March, 2021                                                  %
% ########################################################################### %

clear; clc; tStart = tic; close all; format shortg; c = clock;
disp('# ****************************************************************** #');
disp('# Replicating Figure 5 from "Asset Pricing and FOMC Press Conferences"');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/currencyData.mat');

% Estimating Security Market Lines using 10 beta-sorted portfolios
fmbFX           = fmbFOMC(carryPF(4345:end,:),ff.ff3f(4345:end,2),fomcIdx(4345:end,2:3));

% Plotting the SML for (non-)Press conference days over the 2011-2018 sample
figure;
subplot(1,2,1);
hold on
p1 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaF.pc(2).*(-0.5:0.05:0.25)+fmbFX.gammaF.pc(1)));
p1.Color = colorBrewer(1);
p1.LineStyle = '-';
p2 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaF.npc(2).*(-0.5:0.05:0.25)+fmbFX.gammaF.npc(1)));
p2.Color = colorBrewer(2);
p2.LineStyle = '-.';
p3 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaF.ndays(2).*(-0.5:0.05:0.25)+fmbFX.gammaF.ndays(1)));
p3.Color = colorBrewer(3);
p3.LineStyle = '--';
labels = num2str((1:size(fmbFX.betas.full,2))','CT%d');
text(fmbFX.betas.full(2,:), 100.*fmbFX.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str((1:size(fmbFX.betas.full,2))','CT%d');
text(fmbFX.betas.full(2,:), 100.*fmbFX.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str((1:size(fmbFX.betas.full,2))','CT%d');
text(fmbFX.betas.full(2,:), 100.*fmbFX.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([-0.25 0.25 -12 20]);
box on
title('Full-sample betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','fontSize',8);
set(leg,'Box','Off','Location','NorthEast')
subplot(1,2,2);
hold on
p4 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaD.pc(2).*(-0.5:0.05:0.25)+fmbFX.gammaD.pc(1)));
p4.Color = colorBrewer(1); 
p4.LineStyle = '-';
p5 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaD.npc(2).*(-0.5:0.05:0.25)+fmbFX.gammaD.npc(1)));
p5.Color = colorBrewer(2); 
p5.LineStyle = '-.';
p6 = plot(-0.5:0.05:0.25,100.*(fmbFX.gammaD.ndays(2).*(-0.5:0.05:0.25)+fmbFX.gammaD.ndays(1)));
p6.Color = colorBrewer(3); 
p6.LineStyle = '--';
labels = num2str((1:size(fmbFX.betas.pc,2))','CT%d');
text(fmbFX.betas.pc(2,:), 100.*fmbFX.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str((1:size(fmbFX.betas.npc,2))','CT%d');
text(fmbFX.betas.npc(2,:), 100.*fmbFX.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str((1:size(fmbFX.betas.ndays,2))','CT%d');
text(fmbFX.betas.ndays(2,:), 100.*fmbFX.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([-0.25 0.25 -12 20]);
box on
title('Day-specific betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','FontSize',8);
set(leg,'Box','Off','Location','NorthEast')
set(gcf, 'PaperUnits', 'Centimeters','PaperSize',[21 9],'PaperPosition',[0.5 0.5 20 8]);
print(gcf,'-depsc','output/figure5.eps');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
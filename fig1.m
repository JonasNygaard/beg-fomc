%% Replicating Figure 1 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Figure 1 from "Asset Pricing and FOMC Press Conferences"');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/portfolioData.mat');

% Estimating Security Market Lines using 10 beta-sorted portfolios
fmbBeta     = fmbFOMC(beta10vw(4345:end,:),ff.ff3f(4345:end,2),fomcIdx(4345:end,2:3));
fmbAll      = fmbFOMC([beta10vw(4345:end,:) ivol10vw(4345:end,:) ff.sizval25vw(4345:end,2:end)-ff.ff3f(4345:end,end)],ff.ff3f(4345:end,2),fomcIdx(4345:end,2:3));

% Plotting the SML for (non-)Press conference days over the 2011-2018 sample
figure;
subplot(2,2,1);
hold on
p1 = plot(0:1:2,100.*(fmbBeta.gammaF.pc(2).*(0:1:2)+fmbBeta.gammaF.pc(1)));
p1.Color = colorBrewer(1);
p1.LineStyle = '-';
p2 = plot(0:1:2,100.*(fmbBeta.gammaF.npc(2).*(0:1:2)+fmbBeta.gammaF.npc(1)));
p2.Color = colorBrewer(2);
p2.LineStyle = '-.';
p3 = plot(0:1:2,100.*(fmbBeta.gammaF.ndays(2).*(0:1:2)+fmbBeta.gammaF.ndays(1)));
p3.Color = colorBrewer(3);
p3.LineStyle = '--';
labels = num2str((1:size(fmbBeta.betas.full,2))','B%d');
text(fmbBeta.betas.full(2,:), 100.*fmbBeta.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str((1:size(fmbBeta.betas.full,2))','B%d');
text(fmbBeta.betas.full(2,:), 100.*fmbBeta.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str((1:size(fmbBeta.betas.full,2))','B%d');
text(fmbBeta.betas.full(2,:), 100.*fmbBeta.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([0 2 -60 120]);
box on
title('Full-sample betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','fontSize',8);
set(leg,'Box','Off','Location','NorthWest')
subplot(2,2,2);
hold on
p4 = plot(0:1:2,100.*(fmbBeta.gammaD.pc(2).*(0:1:2)+fmbBeta.gammaD.pc(1)));
p4.Color = colorBrewer(1); 
p4.LineStyle = '-';
p5 = plot(0:1:2,100.*(fmbBeta.gammaD.npc(2).*(0:1:2)+fmbBeta.gammaD.npc(1)));
p5.Color = colorBrewer(2); 
p5.LineStyle = '-.';
p6 = plot(0:1:2,100.*(fmbBeta.gammaD.ndays(2).*(0:1:2)+fmbBeta.gammaD.ndays(1)));
p6.Color = colorBrewer(3); 
p6.LineStyle = '--';
labels = num2str((1:size(fmbBeta.betas.pc,2))','B%d');
text(fmbBeta.betas.pc(2,:), 100.*fmbBeta.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str((1:size(fmbBeta.betas.npc,2))','B%d');
text(fmbBeta.betas.npc(2,:), 100.*fmbBeta.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str((1:size(fmbBeta.betas.ndays,2))','B%d');
text(fmbBeta.betas.ndays(2,:), 100.*fmbBeta.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([0 2 -60 120]);
box on
title('Day-specific betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','FontSize',8);
set(leg,'Box','Off','Location','NorthWest')
subplot(2,2,3);
hold on
p1 = plot(0:1:2,100.*(fmbAll.gammaF.pc(2).*(0:1:2)+fmbAll.gammaF.pc(1)));
p1.Color = colorBrewer(1);
p1.LineStyle = '-';
p2 = plot(0:1:2,100.*(fmbAll.gammaF.npc(2).*(0:1:2)+fmbAll.gammaF.npc(1)));
p2.Color = colorBrewer(2);
p2.LineStyle = '-.';
p3 = plot(0:1:2,100.*(fmbAll.gammaF.ndays(2).*(0:1:2)+fmbAll.gammaF.ndays(1)));
p3.Color = colorBrewer(3);
p3.LineStyle = '--';
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.full(2,:), 100.*fmbAll.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.full(2,:), 100.*fmbAll.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.full(2,:), 100.*fmbAll.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([0 2 -60 120]);
box on
title('Full-sample betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','fontSize',8);
set(leg,'Box','Off','Location','NorthWest')
subplot(2,2,4);
hold on
p4 = plot(0:1:2,100.*(fmbAll.gammaD.pc(2).*(0:1:2)+fmbAll.gammaD.pc(1)));
p4.Color = colorBrewer(1); 
p4.LineStyle = '-';
p5 = plot(0:1:2,100.*(fmbAll.gammaD.npc(2).*(0:1:2)+fmbAll.gammaD.npc(1)));
p5.Color = colorBrewer(2); 
p5.LineStyle = '-.';
p6 = plot(0:1:2,100.*(fmbAll.gammaD.ndays(2).*(0:1:2)+fmbAll.gammaD.ndays(1)));
p6.Color = colorBrewer(3); 
p6.LineStyle = '--';
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.pc(2,:), 100.*fmbAll.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.npc(2,:), 100.*fmbAll.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = {'B1','B2','B3','B4','B5','B6','B7','B8','B9','B10','IV1','IV2','IV3','IV4','IV5','IV6','IV7','IV8','IV9','IV10','SV11','SV12','SV13','SV14','SV15','SV21','SV22','SV23','SV24','SV25',...
'SV31','SV32','SV33','SV34','SV35','SV41','SV42','SV43','SV44','SV45','SV51','SV52','SV53','SV54','SV55'};
text(fmbAll.betas.ndays(2,:), 100.*fmbAll.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([0 2 -60 120]);
box on
title('Day-specific betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','FontSize',8);
set(leg,'Box','Off','Location','NorthWest');
set(gcf, 'PaperUnits', 'Centimeters','PaperSize',[21 19],'PaperPosition',[0.5 0.5 20 18]);
print(gcf,'-depsc','output/figure1.eps');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
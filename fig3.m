%% Replicating Figure 3 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Figure 3 from "Asset Pricing and FOMC Press Conferences"');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/betaDispData.mat');

% Setting frequency in minutes
freq = 3;

figure;
subplot(3,3,1:6)
hold on 
p1 = plot(betaDispPC);
p2 = plot(betaDispNPC);
p3 = plot(betaDispN);
h1 = line([3*(60/freq)-(60/freq)+1 3*(60/freq)-(60/freq)+1],[0.04 0.22]);
hold off 
p1.Color = colorBrewer(1);
p2.Color = colorBrewer(2);
p3.Color = colorBrewer(3);
h1.Color = 'k';
p1.LineStyle = '-';
p2.LineStyle = '-.';
p3.LineStyle = '--';
h1.LineStyle = ':';
h1.LineWidth = 1.5;
p1.LineWidth = 1.2;
p2.LineWidth = 1.2;
p3.LineWidth = 1.2;
xticks([11 21 31 41 51 61 71])
xticklabels({'-90','-60','-30','Ann.','30','60','90'});
axis([0 77 0.04 0.22]);
ylabel('Intra-day beta dispersion','FontSize',10);
xlabel('Minutes around announcement','FontSize',10);
box on
leg = legend('PC days','Non-PC days','Non-ann. days');
set(leg,'Box','Off','Location','NorthEast');
subplot(3,3,7);
hold on
p1 = plot(betaPC);
h1 = line([3*(60/freq)-(60/freq)+1 3*(60/freq)-(60/freq)+1],[0.4 2]);
hold off
p1(1).Color = colorBrewer(1);
p1(2).Color = [0.8 0.8 0.8];
p1(3).Color = [0.8 0.8 0.8];
p1(4).Color = colorBrewer(2);
p1(5).Color = [0.8 0.8 0.8];
p1(6).Color = [0.8 0.8 0.8];
p1(7).Color = colorBrewer(3);
p1(8).Color = [0.8 0.8 0.8];
p1(9).Color = [0.8 0.8 0.8];
p1(10).Color = colorBrewer(4);
p1(1).LineWidth = 1.2;
p1(2).LineWidth = 0.5;
p1(3).LineWidth = 0.5;
p1(4).LineWidth = 1.2;
p1(5).LineWidth = 0.5;
p1(6).LineWidth = 0.5;
p1(7).LineWidth = 1.2;
p1(8).LineWidth = 0.5;
p1(9).LineWidth = 0.5;
p1(10).LineWidth = 1.2;
p1(2).LineStyle = '--';
p1(3).LineStyle = '--';
p1(5).LineStyle = '--';
p1(6).LineStyle = '--';
p1(8).LineStyle = '--';
p1(9).LineStyle = '--';
h1.Color = 'k';
h1.LineStyle = ':';
h1.LineWidth = 1.5;
xticks([21 41 61])
xticklabels({'-60','Ann.','60'});
xlabel('Minutes around announcement','FontSize',8);
axis([0 77 0.4 2]);
ylabel('Intra-day betas','FontSize',8);
set(gca,'FontSize',8)
box on
title('PC days','FontWeight','Normal','FontSize',8);
leg = legend([p1(1) p1(4) p1(7) p1(10)],'P1','P4','P7','P10');
set(leg,'Box','Off','Location','NorthEast','fontSize',4);
subplot(3,3,8);
hold on
p1 = plot(betaNPC);
h1 = line([3*(60/freq)-(60/freq)+1 3*(60/freq)-(60/freq)+1],[0.4 2]);
hold off
p1(1).Color = colorBrewer(1);
p1(2).Color = [0.8 0.8 0.8];
p1(3).Color = [0.8 0.8 0.8];
p1(4).Color = colorBrewer(2);
p1(5).Color = [0.8 0.8 0.8];
p1(6).Color = [0.8 0.8 0.8];
p1(7).Color = colorBrewer(3);
p1(8).Color = [0.8 0.8 0.8];
p1(9).Color = [0.8 0.8 0.8];
p1(10).Color = colorBrewer(4);
p1(1).LineWidth = 1.2;
p1(2).LineWidth = 0.5;
p1(3).LineWidth = 0.5;
p1(4).LineWidth = 1.2;
p1(5).LineWidth = 0.5;
p1(6).LineWidth = 0.5;
p1(7).LineWidth = 1.2;
p1(8).LineWidth = 0.5;
p1(9).LineWidth = 0.5;
p1(10).LineWidth = 1.2;
p1(2).LineStyle = '--';
p1(3).LineStyle = '--';
p1(5).LineStyle = '--';
p1(6).LineStyle = '--';
p1(8).LineStyle = '--';
p1(9).LineStyle = '--';
h1.Color = 'k';
h1.LineStyle = ':';
h1.LineWidth = 1.5;
xticks([21 41 61])
xticklabels({'-60','Ann.','60'});
xlabel('Minutes around announcement','FontSize',8);
axis([0 77 0.4 2]);
ylabel('Intra-day betas','FontSize',8);
set(gca,'FontSize',8)
box on
title('Non-PC days','FontWeight','Normal','FontSize',8);
leg = legend([p1(1) p1(4) p1(7) p1(10)],'P1','P4','P7','P10');
set(leg,'Box','Off','Location','NorthEast','fontSize',4);
subplot(3,3,9);
hold on
p1 = plot(betaN);
h1 = line([3*(60/freq)-(60/freq)+1 3*(60/freq)-(60/freq)+1],[0.4 2]);
hold off
p1(1).Color = colorBrewer(1);
p1(2).Color = [0.8 0.8 0.8];
p1(3).Color = [0.8 0.8 0.8];
p1(4).Color = colorBrewer(2);
p1(5).Color = [0.8 0.8 0.8];
p1(6).Color = [0.8 0.8 0.8];
p1(7).Color = colorBrewer(3);
p1(8).Color = [0.8 0.8 0.8];
p1(9).Color = [0.8 0.8 0.8];
p1(10).Color = colorBrewer(4);
p1(1).LineWidth = 1.2;
p1(2).LineWidth = 0.5;
p1(3).LineWidth = 0.5;
p1(4).LineWidth = 1.2;
p1(5).LineWidth = 0.5;
p1(6).LineWidth = 0.5;
p1(7).LineWidth = 1.2;
p1(8).LineWidth = 0.5;
p1(9).LineWidth = 0.5;
p1(10).LineWidth = 1.2;
p1(2).LineStyle = '--';
p1(3).LineStyle = '--';
p1(5).LineStyle = '--';
p1(6).LineStyle = '--';
p1(8).LineStyle = '--';
p1(9).LineStyle = '--';
h1.Color = 'k';
h1.LineStyle = ':';
h1.LineWidth = 1.5;
xticks([21 41 61])
xticklabels({'-60','Ann.','60'});
xlabel('Minutes around announcement','FontSize',8);
axis([0 77 0.4 2]);
ylabel('Intra-day betas','FontSize',8);
set(gca,'FontSize',8)
box on
title('Non-ann. days','FontWeight','Normal','FontSize',8);
leg = legend([p1(1) p1(4) p1(7) p1(10)],'P1','P4','P7','P10');
set(leg,'Box','Off','Location','NorthEast','fontSize',4);
set(gcf, 'PaperUnits', 'Centimeters','PaperSize',[21 21],'PaperPosition',[0.5 0.5 20 20]);
print(gcf,'-depsc','output/figure3.eps');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
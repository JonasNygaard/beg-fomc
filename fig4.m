%% Replicating Figure 4 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Figure 4 from "Asset Pricing and FOMC Press Conferences"');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/treasuryData.mat');

% Setting up the data for estimation and plotting
mktRet                  = ff.ff3f;
mktRet(:,1)             = datenum(num2str(mktRet(:,1)),'yyyymmdd');
[~,tmp,tmp1]            = intersect(treasuryData(:,1),mktRet(:,1),'stable');
mktRet                  = mktRet(tmp1,:);
fomcTreasury            = fomcIdx(tmp1,:);
treasuryData            = treasuryData(tmp,:);
treasuryData(:,2:end)   = treasuryData(:,2:end) - mktRet(:,end);

% Estimating Security Market Lines using 10 beta-sorted portfolios
fmbBonds                = fmbFOMC(treasuryData(4306:end,2:end),mktRet(4306:end,2),fomcTreasury(4306:end,2:3));

% Plotting the SML for (non-)Press conference days over the 2011-2018 sample
figure;
subplot(1,2,1);
hold on
p1 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaF.pc(2).*(-0.8:0.2:0.4)+fmbBonds.gammaF.pc(1)));
p1.Color = colorBrewer(1);
p1.LineStyle = '-';
p2 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaF.npc(2).*(-0.8:0.2:0.4)+fmbBonds.gammaF.npc(1)));
p2.Color = colorBrewer(2);
p2.LineStyle = '-.';
p3 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaF.ndays(2).*(-0.8:0.2:0.4)+fmbBonds.gammaF.ndays(1)));
p3.Color = colorBrewer(3);
p3.LineStyle = '--';
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.full(2,:), 100.*fmbBonds.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.full(2,:), 100.*fmbBonds.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.full(2,:), 100.*fmbBonds.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([-0.6 0.4 -5 30]);
box on
title('Full-sample betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','fontSize',8);
set(leg,'Box','Off','Location','NorthEast')
subplot(1,2,2);
hold on
p4 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaD.pc(2).*(-0.8:0.2:0.4)+fmbBonds.gammaD.pc(1)));
p4.Color = colorBrewer(1); 
p4.LineStyle = '-';
p5 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaD.npc(2).*(-0.8:0.2:0.4)+fmbBonds.gammaD.npc(1)));
p5.Color = colorBrewer(2); 
p5.LineStyle = '-.';
p6 = plot(-0.8:0.2:0.4,100.*(fmbBonds.gammaD.ndays(2).*(-0.8:0.2:0.4)+fmbBonds.gammaD.ndays(1)));
p6.Color = colorBrewer(3); 
p6.LineStyle = '--';
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.pc(2,:), 100.*fmbBonds.means.pc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(1));
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.npc(2,:), 100.*fmbBonds.means.npc, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(2));
labels = num2str([1 2 5 7 10 20 30]','%dY');
text(fmbBonds.betas.ndays(2,:), 100.*fmbBonds.means.ndays, labels,'HorizontalAlignment','center','FontSize',8,'Color',colorBrewer(3));
hold off
axis([-0.6 0.4 -5 30]);
box on
title('Day-specific betas','FontSize',10,'FontWeight','Normal');
ylabel('Average excess returns (bps)','FontSize',10);
xlabel('CAPM beta','FontSize',10);
leg = legend('PC days','Non-PC days','Non-ann. days','FontSize',8);
set(leg,'Box','Off','Location','NorthEast')
set(gcf, 'PaperUnits', 'Centimeters','PaperSize',[21 9],'PaperPosition',[0.5 0.5 20 8]);
print(gcf,'-depsc','output/figure4.eps');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
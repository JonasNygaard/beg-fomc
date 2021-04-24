%% Replicating Figure 2 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Figure 2 from "Asset Pricing and FOMC Press Conferences"');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/portfolioData.mat');

% Defining the different types of days
fomc            = fomcIdx(4345:end,:);
pcIdx           = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx          = (fomc(:,2) == 1 & fomc(:,3) == 0);

% Setting up test assets for beta estimation
testAss         = [beta10vw ivol10vw ff.sizval25vw(:,2:end)-ff.ff3f(:,end)];
testAss         = testAss(4345:end,:);
mkt             = ff.ff3f(4345:end,2);

% Running regressions
resBeta         = linRegress(testAss,[pcIdx npcIdx mkt mkt.*pcIdx mkt.*npcIdx],1,'NW',12);

% Estimating beta dispersions for beta sorted portfolios
betaDisp.nday1      = mean( (resBeta.bv(4,1:10) - 1).^2 );
betaDisp.pc1        = mean( (resBeta.bv(4,1:10) + resBeta.bv(5,1:10) - 1).^2 );
betaDisp.npc1       = mean( (resBeta.bv(4,1:10) + resBeta.bv(6,1:10) - 1).^2 );

% Estimating beta dispersions for IVOL sorted portfolios
betaDisp.nday2      = mean( (resBeta.bv(4,11:20) - 1).^2 );
betaDisp.pc2        = mean( (resBeta.bv(4,11:20) + resBeta.bv(5,11:20) - 1).^2 );
betaDisp.npc2       = mean( (resBeta.bv(4,11:20) + resBeta.bv(6,11:20) - 1).^2 );

% Estimating beta dispersions for size- and book-to-market-sorted portfolios
betaDisp.nday3      = mean( (resBeta.bv(4,21:end) - 1).^2 );
betaDisp.pc3        = mean( (resBeta.bv(4,21:end) + resBeta.bv(5,21:end) - 1).^2 );
betaDisp.npc3       = mean( (resBeta.bv(4,21:end) + resBeta.bv(6,21:end) - 1).^2 );

% Estimating beta dispersions for all portfolios
betaDisp.nday4      = mean( (resBeta.bv(4,:) - 1).^2 );
betaDisp.pc4        = mean( (resBeta.bv(4,:) + resBeta.bv(5,:) - 1).^2 );
betaDisp.npc4       = mean( (resBeta.bv(4,:) + resBeta.bv(6,:) - 1).^2 );

% Plotting beta dispersion
figure;
subplot(2,2,1);
data    = diag([betaDisp.pc1 betaDisp.npc1 betaDisp.nday1]);
data(data == 0) = NaN;
hold on
b1 = bar(data(1,:));
b2 = bar(data(2,:));
b3 = bar(data(3,:));
hold off
b1.FaceColor = colorBrewer(1);
b1.EdgeColor = colorBrewer(1);
b2.FaceColor = colorBrewer(2);
b2.EdgeColor = colorBrewer(2);
b3.FaceColor = colorBrewer(3);
b3.EdgeColor = colorBrewer(3);
axis([0.5 3.5 0 0.2]);
xticks(1:3);
xticklabels({'PC Days','Non-PC days','Non-ann.'});
box on
ylabel('Dispersion','FontSize',10);
title('Beta-sorted portfolios','FontWeight','Normal','FontSize',10);
subplot(2,2,2);
data    = diag([betaDisp.pc2 betaDisp.npc2 betaDisp.nday2]);
data(data == 0) = NaN;
hold on
b1 = bar(data(1,:));
b2 = bar(data(2,:));
b3 = bar(data(3,:));
hold off
b1.FaceColor = colorBrewer(1);
b1.EdgeColor = colorBrewer(1);
b2.FaceColor = colorBrewer(2);
b2.EdgeColor = colorBrewer(2);
b3.FaceColor = colorBrewer(3);
b3.EdgeColor = colorBrewer(3);
axis([0.5 3.5 0 0.2]);
xticks(1:3);
xticklabels({'PC Days','Non-PC days','Non-ann.'});
box on
ylabel('Dispersion','FontSize',10);
title('IVOL-sorted portfolios','FontWeight','Normal','FontSize',10);
subplot(2,2,3);
data    = diag([betaDisp.pc3 betaDisp.npc3 betaDisp.nday3]);
data(data == 0) = NaN;
hold on
b1 = bar(data(1,:));
b2 = bar(data(2,:));
b3 = bar(data(3,:));
hold off
b1.FaceColor = colorBrewer(1);
b1.EdgeColor = colorBrewer(1);
b2.FaceColor = colorBrewer(2);
b2.EdgeColor = colorBrewer(2);
b3.FaceColor = colorBrewer(3);
b3.EdgeColor = colorBrewer(3);
axis([0.5 3.5 0 0.2]);
xticks(1:3);
xticklabels({'PC Days','Non-PC days','Non-ann.'});
box on
ylabel('Dispersion','FontSize',10);
title('Size- and value-sorted portfolios','FontWeight','Normal','FontSize',10);
subplot(2,2,4);
data    = diag([betaDisp.pc4 betaDisp.npc4 betaDisp.nday4]);
data(data == 0) = NaN;
hold on
b1 = bar(data(1,:));
b2 = bar(data(2,:));
b3 = bar(data(3,:));
hold off
b1.FaceColor = colorBrewer(1);
b1.EdgeColor = colorBrewer(1);
b2.FaceColor = colorBrewer(2);
b2.EdgeColor = colorBrewer(2);
b3.FaceColor = colorBrewer(3);
b3.EdgeColor = colorBrewer(3);
axis([0.5 3.5 0 0.2]);
xticks(1:3);
xticklabels({'PC Days','Non-PC days','Non-ann.'});
box on
ylabel('Dispersion','FontSize',10);
title('All portfolios','FontWeight','Normal','FontSize',10);
set(gcf, 'PaperUnits', 'Centimeters','PaperSize',[21 15],'PaperPosition',[0.5 0.5 20 14]);
print(gcf,'-depsc','output/figure2.eps');

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
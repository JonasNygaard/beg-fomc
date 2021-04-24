%% Replicating Table 2 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Table 2 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/portfolioData.mat');

% Setting strings for tables
betaString = {
    'Intercept'
    'PC'
    'Non-PC'
    'Non-ann.'
    '$\Delta$PC'
    '$\Delta$Non-PC'
    'R$^{2}\left(\%\right)$'
};

% Defining the different types of days
fomc            = fomcIdx(4345:end,:);
pcIdx           = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx          = (fomc(:,2) == 1 & fomc(:,3) == 0);
adaysIdx        = (fomc(:,2) == 1);
ndaysIdx        = (fomc(:,2) == 0);

% Setting up test assets for beta estimation
testAss         = [beta10vw ivol10vw ff.sizval25vw(:,2:end)-ff.ff3f(:,end)];
testAss         = testAss(4345:end,:);
mkt             = ff.ff3f(4345:end,2);

% Running regressions
resBeta         = linRegress(testAss,[pcIdx npcIdx mkt mkt.*pcIdx mkt.*npcIdx],1,'NW',12);

% Make LaTeX table with results
fid = fopen('output/table2.tex','w');
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','','Low','2','3','4','5','6','7','8','9','High');
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{11}{c}{Panel A: Ten beta-sorted portfolios}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{4},resBeta.bv(4,1:10));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBeta.tbv(4,1:10));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{5},resBeta.bv(5,1:10));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBeta.tbv(5,1:10));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{6},resBeta.bv(6,1:10));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\midrule\n','',resBeta.tbv(6,1:10));
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{11}{c}{Panel B: Ten IVOL-sorted portfolios}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{4},resBeta.bv(4,11:20));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBeta.tbv(4,11:20));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{5},resBeta.bv(5,11:20));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBeta.tbv(5,11:20));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{6},resBeta.bv(6,11:20));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\\midrule\n','',resBeta.tbv(6,11:20));
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','','','Growth','2','3','4','Value','','','','');
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{11}{c}{Panel C: 25 size-value portfolios}');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{4},'Small',resBeta.bv(4,21:25),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(4,21:25),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{5},'',resBeta.bv(5,21:25),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(5,21:25),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{6},'',resBeta.bv(6,21:25),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(6,21:25),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{4},'2',resBeta.bv(4,26:30),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(4,26:30),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{5},'',resBeta.bv(5,26:30),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(5,26:30),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{6},'',resBeta.bv(6,26:30),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(6,26:30),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{4},'3',resBeta.bv(4,31:35),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(4,31:35),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{5},'',resBeta.bv(5,31:35),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(5,31:35),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{6},'',resBeta.bv(6,31:35),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(6,31:35),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{4},'4',resBeta.bv(4,36:40),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(4,36:40),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{5},'',resBeta.bv(5,36:40),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(5,36:40),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{6},'',resBeta.bv(6,36:40),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(6,36:40),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{4},'Large',resBeta.bv(4,41:45),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(4,41:45),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{5},'',resBeta.bv(5,41:45),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(5,41:45),'','','','');
fprintf(fid,'%s & %s & %.2f & %.2f & %.2f & %.2f & %.2f & %s & %s & %s & %s \\\\\n',betaString{6},'',resBeta.bv(6,41:45),'','','','');
fprintf(fid,'%s & %s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & %s & %s & %s & %s \\\\\n','','',resBeta.tbv(6,41:45),'','','','');
fprintf(fid,'\\bottomrule\n');
fclose(fid);

% ########################################################################### %
%% Computing code run time
% ########################################################################### %

tEnd = toc(tStart);
fprintf('<*> Runtime: %d minutes and %f seconds\n',floor(tEnd/60),rem(tEnd,60));
disp('<*> Routine Completed');

% ########################################################################### %
% [EOS]
% ########################################################################### %
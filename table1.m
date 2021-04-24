%% Replicating Table 1 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Table 1 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/portfolioData.mat');

% Setting day-specific strings for tables
dayString = {
    'Non-announcement days'
    'Announcement days'
    'PC days'
    'Non--PC days'
    '$\Delta$ Announcement'
    '$\Delta$ PC'
    '$\Delta$ Non--PC'
};

% Estimating models across the days
fmbBet1 = fmbFOMC(beta10vw(4345:end,:),ff.ff3f(4345:end,2),fomcIdx(4345:end,2:3));
fmbSVB1 = fmbFOMC([beta10vw(4345:end,:) ivol10vw(4345:end,:) ff.sizval25vw(4345:end,2:end)-ff.ff3f(4345:end,end)],ff.ff3f(4345:end,2),fomcIdx(4345:end,2:3));

% Make LaTeX table with results
headerFile = {'Type of day','Intercept','Slope','R$^2\left(\%\right)$','MAPE','Intercept','Slope','R$^2\left(\%\right)$','MAPE'};
fid = fopen('output/table1.tex','w');
fprintf(fid,'%s & %s & %s \\\\\\cmidrule(lr){2-5}\\cmidrule(lr){6-9}','',...
    '\multicolumn{4}{c}{Full sample betas}','\multicolumn{4}{c}{Day-specific betas}');
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n',headerFile{:,:});
fprintf(fid,'%s \\\\\\cmidrule(lr){1-9}\n','\multicolumn{9}{c}{Panel A: Ten beta-sorted portfolios}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{1},fmbBet1.gammaF.ndays,fmbBet1.rsqrF.ndays,fmbBet1.mapeF.ndays,fmbBet1.gammaD.ndays,fmbBet1.rsqrD.ndays,fmbBet1.mapeD.ndays);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbBet1.tGammaF.ndays,'',fmbBet1.chiF.ndays(2),fmbBet1.tGammaD.ndays,'',fmbBet1.chiD.ndays(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{2},fmbBet1.gammaF.adays,fmbBet1.rsqrF.adays,fmbBet1.mapeF.adays,fmbBet1.gammaD.adays,fmbBet1.rsqrD.adays,fmbBet1.mapeD.adays);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbBet1.tGammaF.adays,'',fmbBet1.chiF.adays(2),fmbBet1.tGammaD.adays,'',fmbBet1.chiD.adays(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{3},fmbBet1.gammaF.pc,fmbBet1.rsqrF.pc,fmbBet1.mapeF.pc,fmbBet1.gammaD.pc,fmbBet1.rsqrD.pc,fmbBet1.mapeD.pc);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbBet1.tGammaF.pc,'',fmbBet1.chiF.pc(2),fmbBet1.tGammaD.pc,'',fmbBet1.chiD.pc(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{4},fmbBet1.gammaF.npc,fmbBet1.rsqrF.npc,fmbBet1.mapeF.npc,fmbBet1.gammaD.npc,fmbBet1.rsqrD.npc,fmbBet1.mapeD.npc);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbBet1.tGammaF.npc,'',fmbBet1.chiF.npc(2),fmbBet1.tGammaD.npc,'',fmbBet1.chiD.npc(2));
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{5},fmbBet1.gammaF.anDiff,'','',fmbBet1.gammaD.anDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\n','',fmbBet1.tGammaF.anDiff,'','',fmbBet1.tGammaD.anDiff,'','');
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{6},fmbBet1.gammaF.pcDiff,'','',fmbBet1.gammaD.pcDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\n','',fmbBet1.tGammaF.pcDiff,'','',fmbBet1.tGammaD.pcDiff,'','');
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{7},fmbBet1.gammaF.npcDiff,'','',fmbBet1.gammaD.npcDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\\cmidrule(lr){1-9}\n','',fmbBet1.tGammaF.npcDiff,'','',fmbBet1.tGammaD.npcDiff,'','');
fprintf(fid,'%s \\\\\\cmidrule(lr){1-9}\n','\multicolumn{9}{c}{Panel B: Ten beta-sorted, ten IVOL-sorted, and 25 size-value portfolios}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{1},fmbSVB1.gammaF.ndays,fmbSVB1.rsqrF.ndays,fmbSVB1.mapeF.ndays,fmbSVB1.gammaD.ndays,fmbSVB1.rsqrD.ndays,fmbSVB1.mapeD.ndays);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbSVB1.tGammaF.ndays,'',fmbSVB1.chiF.ndays(2),fmbSVB1.tGammaD.ndays,'',fmbSVB1.chiD.ndays(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{2},fmbSVB1.gammaF.adays,fmbSVB1.rsqrF.adays,fmbSVB1.mapeF.adays,fmbSVB1.gammaD.adays,fmbSVB1.rsqrD.adays,fmbSVB1.mapeD.adays);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbSVB1.tGammaF.adays,'',fmbSVB1.chiF.adays(2),fmbSVB1.tGammaD.adays,'',fmbSVB1.chiD.adays(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{3},fmbSVB1.gammaF.pc,fmbSVB1.rsqrF.pc,fmbSVB1.mapeF.pc,fmbSVB1.gammaD.pc,fmbSVB1.rsqrD.pc,fmbSVB1.mapeD.pc);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbSVB1.tGammaF.pc,'',fmbSVB1.chiF.pc(2),fmbSVB1.tGammaD.pc,'',fmbSVB1.chiD.pc(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',dayString{4},fmbSVB1.gammaF.npc,fmbSVB1.rsqrF.npc,fmbSVB1.mapeF.npc,fmbSVB1.gammaD.npc,fmbSVB1.rsqrD.npc,fmbSVB1.mapeD.npc);
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & \\{%.2f\\} & [%.2f] & [%.2f] & %s & \\{%.2f\\} \\\\\n','',fmbSVB1.tGammaF.npc,'',fmbSVB1.chiF.npc(2),fmbSVB1.tGammaD.npc,'',fmbSVB1.chiD.npc(2));
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{5},fmbSVB1.gammaF.anDiff,'','',fmbSVB1.gammaD.anDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\n','',fmbSVB1.tGammaF.anDiff,'','',fmbSVB1.tGammaD.anDiff,'','');
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{6},fmbSVB1.gammaF.pcDiff,'','',fmbSVB1.gammaD.pcDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\n','',fmbSVB1.tGammaF.pcDiff,'','',fmbSVB1.tGammaD.pcDiff,'','');
fprintf(fid,'%s & %.2f & %.2f & %s & %s & %.2f & %.2f & %s & %s \\\\\n',dayString{7},fmbSVB1.gammaF.npcDiff,'','',fmbSVB1.gammaD.npcDiff,'','');
fprintf(fid,'%s & [%.2f] & [%.2f] & %s & %s & [%.2f] & [%.2f] & %s & %s \\\\\n','',fmbSVB1.tGammaF.npcDiff,'','',fmbSVB1.tGammaD.npcDiff,'','');
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
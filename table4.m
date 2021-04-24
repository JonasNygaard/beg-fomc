%% Replicating Table 4 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Table 4 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');

% Constructing log changes to the uncertainty indices
dvix            = diff(log(vix(:,1))).*100;
dvix            = dvix(4344:end,:);
dtvix           = diff(log(tvix(:,1))).*100;
dtvix           = dtvix(4344:end,:);
depu            = diff(log(epu(:,1))).*100;
depu            = depu(4344:end,:);
ret             = ff.ff3f(4345:end,2);

% Defining the different types of days
fomc            = fomcIdx(4345:end,:);
pcIdx           = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx          = (fomc(:,2) == 1 & fomc(:,3) == 0);
adaysIdx        = (fomc(:,2) == 1);
ndaysIdx        = (fomc(:,2) == 1);

% Running VIX regressions
resVIX1         = linRegress(dvix,[ret adaysIdx ret.*adaysIdx],1,'NW',3);
resVIX2         = linRegress(dvix,[ret pcIdx ret.*pcIdx],1,'NW',3);
resVIX3         = linRegress(dvix,[ret npcIdx ret.*npcIdx],1,'NW',3);

% Running TVIX regressions
resTVIX1        = linRegress(dtvix,[ret adaysIdx ret.*adaysIdx],1,'NW',3);
resTVIX2        = linRegress(dtvix,[ret pcIdx ret.*pcIdx],1,'NW',3);
resTVIX3        = linRegress(dtvix,[ret npcIdx ret.*npcIdx],1,'NW',3);

% Running EPU regressions
resEPU1         = linRegress(depu,[ret adaysIdx ret.*adaysIdx],1,'NW',3);
resEPU2         = linRegress(depu,[ret pcIdx ret.*pcIdx],1,'NW',3);
resEPU3         = linRegress(depu,[ret npcIdx ret.*npcIdx],1,'NW',3);

% Estimating HRS changes on PC days
meetingIdx      = pcIdx(adaysIdx == 1,:);
dhrs            = diff(log(hrs)).*100;
hrsSave         = hrs;
hrs             = hrs(2:end,1);
resHRS          = linRegress(dhrs,meetingIdx,1,'NW',3);

% Setting day strings for table
dayString1 = {
    'Announcement days'
    '{Non-announce-} {ment days}'
    'PC days'
    'Non-PC days'
};

% Make LaTeX table with results
fid = fopen('output/table4.tex','w');
fprintf(fid,'%s & %s \\\\\\cmidrule(lr){2-4}\n','','\multicolumn{3}{c}{Type of day}');
fprintf(fid,'%s & %s & %s & %s \\\\\\midrule\n','',dayString1{[1 3:4]});
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{4}{c}{Panel A: VIX}');
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Constant',resVIX1.bv(1),resVIX2.bv(1),resVIX3.bv(1));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resVIX1.tbv(1),resVIX2.tbv(1),resVIX3.tbv(1));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Market return',resVIX1.bv(2),resVIX2.bv(2),resVIX3.bv(2));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resVIX1.tbv(2),resVIX2.tbv(2),resVIX3.tbv(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Type of day',resVIX1.bv(3),resVIX2.bv(3),resVIX3.bv(3));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resVIX1.tbv(3),resVIX2.tbv(3),resVIX3.tbv(3));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Interaction',resVIX1.bv(4),resVIX2.bv(4),resVIX3.bv(4));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resVIX1.tbv(4),resVIX2.tbv(4),resVIX3.tbv(4));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\\midrule\n','R$^{2}\left(\%\right)$',resVIX1.R2v,resVIX2.R2v,resVIX3.R2v);
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{4}{c}{Panel B: TYVIX}');
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Constant',resTVIX1.bv(1),resTVIX2.bv(1),resTVIX3.bv(1));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resTVIX1.tbv(1),resTVIX2.tbv(1),resTVIX3.tbv(1));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Market return',resTVIX1.bv(2),resTVIX2.bv(2),resTVIX3.bv(2));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resTVIX1.tbv(2),resTVIX2.tbv(2),resTVIX3.tbv(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Type of day',resTVIX1.bv(3),resTVIX2.bv(3),resTVIX3.bv(3));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resTVIX1.tbv(3),resTVIX2.tbv(3),resTVIX3.tbv(3));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Interaction',resTVIX1.bv(4),resTVIX2.bv(4),resTVIX3.bv(4));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resTVIX1.tbv(4),resTVIX2.tbv(4),resTVIX3.tbv(4));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\\midrule\n','R$^{2}\left(\%\right)$',resTVIX1.R2v,resTVIX2.R2v,resTVIX3.R2v);
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{4}{c}{Panel C: EPU}');
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Constant',resEPU1.bv(1),resEPU2.bv(1),resEPU3.bv(1));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resEPU1.tbv(1),resEPU2.tbv(1),resEPU3.tbv(1));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Market return',resEPU1.bv(2),resEPU2.bv(2),resEPU3.bv(2));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resEPU1.tbv(2),resEPU2.tbv(2),resEPU3.tbv(2));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Type of day',resEPU1.bv(3),resEPU2.bv(3),resEPU3.bv(3));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resEPU1.tbv(3),resEPU2.tbv(3),resEPU3.tbv(3));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\n','Interaction',resEPU1.bv(4),resEPU2.bv(4),resEPU3.bv(4));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resEPU1.tbv(4),resEPU2.tbv(4),resEPU3.tbv(4));
fprintf(fid,'%s & %.2f & %.2f & %.2f \\\\\\midrule\n','R$^{2}\left(\%\right)$',resEPU1.R2v,resEPU2.R2v,resEPU3.R2v);
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{4}{c}{Panel D: MPU}');
fprintf(fid,'%s & %s & %.2f & %.2f \\\\\n','Type of day','',resHRS.bv(2)+resHRS.bv(1),resHRS.bv(1));
fprintf(fid,'%s & %s & [%.2f] & [%.2f] \\\\\n','','',resHRS.tbv(2),resHRS.tbv(1));
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
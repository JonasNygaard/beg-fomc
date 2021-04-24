%% Replicating Table 5 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Table 5 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/factorData.mat');
load('data/treasuryData.mat');

% Setting up the data for estimation
mktRet                  = ff.ff3f;
mktRet(:,1)             = datenum(num2str(mktRet(:,1)),'yyyymmdd');
[~,tmp,tmp1]            = intersect(treasuryData(:,1),mktRet(:,1),'stable');
mktRet                  = mktRet(tmp1,:);
fomcTreasury            = fomcIdx(tmp1,:);
treasuryData            = treasuryData(tmp,:);
treasuryData(:,2:end)   = treasuryData(:,2:end) - mktRet(:,end);

% Defining the different types of days
fomc                = fomcTreasury(4306:end,:);
pcIdx               = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx              = (fomc(:,2) == 1 & fomc(:,3) == 0);
adaysIdx            = (fomc(:,2) == 1);
ndaysIdx            = (fomc(:,2) == 0);

% Computing stock-bond correlations across days
ret                 = treasuryData(4306:end,2:end);
retMKT              = mktRet(4306:end,2);
retX                = standard(ret);
retMKTX             = standard(retMKT);

% Standardising returns within the various days
retX(ndaysIdx,:)    = standard(retX(ndaysIdx,:));
retX(pcIdx,:)       = standard(retX(pcIdx,:));
retX(npcIdx,:)      = standard(retX(npcIdx,:));
retMKTX(ndaysIdx,:) = standard(retMKTX(ndaysIdx,:));
retMKTX(pcIdx,:)    = standard(retMKTX(pcIdx,:));
retMKTX(npcIdx,:)   = standard(retMKTX(npcIdx,:));

% Estimating stock-bond correlations
resBondCorr         = linRegress(retX,[pcIdx npcIdx retMKTX retMKTX.*pcIdx retMKTX.*npcIdx],1,'NW',12);

% Strings to tables
betaString = {
    'Intercept'
    'PC'
    'Non-PC'
    'Non-ann.'
    '$\Delta$PC'
    '$\Delta$Non-PC'
};

% Make LaTeX table with results
fid = fopen('output/table5.tex','w');
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Beta','1Y','2Y','5Y','7Y','10Y','20Y','30Y');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{4},resBondCorr.bv(4,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBondCorr.tbv(4,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{5},resBondCorr.bv(5,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBondCorr.tbv(5,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n',betaString{6},resBondCorr.bv(6,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',resBondCorr.tbv(6,:));
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
%% Replicating Table 6 from "Asset Pricing and FOMC Press Conferences"
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
disp('# Replicating Table 6 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/yieldPCA.mat');
load('data/factorData.mat');
load('data/treasuryData.mat');

% Setting up the data for estimation
yieldFactors    = yieldFactors(8494:14883,:);
yieldFactors    = [datenum(yieldFactors(:,1:3)) yieldFactors(:,4:end)];
mktRet          = ff.ff3f;
mktRet(:,1)     = datenum(num2str(mktRet(:,1)),'yyyymmdd');
[~,tmp,tmp1]    = intersect(mktRet(:,1),yieldFactors(:,1),'stable');
yieldFactors    = yieldFactors(tmp1,:);

% Setting up string of day types
dayString = {
    'Non-announcement days'
    'Announcement days'
    'PC days'
    'Non--PC days'
    '$\Delta$ Announcement'
    '$\Delta$ PC'
    '$\Delta$ Non--PC'
};

% Setting up the data for estimation and plotting
mktRet                  = ff.ff3f;
mktRet(:,1)             = datenum(num2str(mktRet(:,1)),'yyyymmdd');
[~,tmp,tmp1]            = intersect(treasuryData(:,1),mktRet(:,1),'stable');
mktRet                  = mktRet(tmp1,:);
fomcTreasury            = fomcIdx(tmp1,:);
epu                     = epu(tmp1,:);
vix                     = vix(tmp1,:);
tvix                    = tvix(tmp1,:);
yieldFactors            = yieldFactors(tmp1,:);
treasuryData            = treasuryData(tmp,:);
treasuryData(:,2:end)   = treasuryData(:,2:end) - mktRet(:,end);

% Defining the different types of days
fomc            = fomcTreasury(4306:end,:);
pcIdx           = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx          = (fomc(:,2) == 1 & fomc(:,3) == 0);
adaysIdx        = (fomc(:,2) == 1);
ndaysIdx        = (fomc(:,2) == 0);

% Computing time-varying stock-bond correlations
wLenght = 252;
sbCorr  = NaN(size(treasuryData(:,2:end)));

for iObs = wLenght:size(treasuryData,1)

    % Estimating stock-bond correlations
    tmp             = corr([treasuryData(iObs-wLenght+1:iObs,2:end) mktRet(iObs-wLenght+1:iObs,2)]);
    sbCorr(iObs,:)  = tmp(end,1:end-1);

end

% Setting explanatory variables
corrAnnDays     = sbCorr(4306:end,:);
corrAnnDays     = corrAnnDays(adaysIdx,:);

vixAnnDays      = log(vix(4304:end-2,:));
vixAnnDays      = standard(vixAnnDays(adaysIdx,:));

tvixAnnDays     = log(tvix(4304:end-2,:));
tvixAnnDays     = standard(tvixAnnDays(adaysIdx,:));

epuAnnDays      = log(epu(4304:end-2,:));
epuAnnDays      = standard(epuAnnDays(adaysIdx,:));

mpuAnnDays      = standard(diff((hrs(1:end,:))));

levAnnDays      = yieldFactors(4304:end-2,2);
levAnnDays      = standard(levAnnDays(adaysIdx,:));

slpAnnDays      = yieldFactors(4304:end-2,3);
slpAnnDays      = standard(slpAnnDays(adaysIdx,:));

cuvAnnDays      = yieldFactors(4304:end-2,4);
cuvAnnDays      = standard(cuvAnnDays(adaysIdx,:));

pcIdxAnnDays    = pcIdx(adaysIdx,:);

% Estimating stock-bond correlation regressions
res1            = linRegress(corrAnnDays,[vixAnnDays tvixAnnDays],1,'NW',3);
res2            = linRegress(corrAnnDays,[epuAnnDays mpuAnnDays],1,'NW',3);
res3            = linRegress(corrAnnDays,[levAnnDays slpAnnDays cuvAnnDays],1,'NW',3);

% Writing results to latex table
fid = fopen('output/table6.tex','w');
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','Bond','1Y','2Y','5Y','7Y','10Y','20Y','30Y');
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{8}{c}{Panel A: Financial market uncertainty}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','VIX',res1.bv(2,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res1.tbv(2,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','TYVIX',res1.bv(3,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res1.tbv(3,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Constant',res1.bv(1,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res1.tbv(1,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\midrule\n','R$^{2}\left(\%\right)$',res1.R2v);
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{8}{c}{Panel B: Economic and monetary policy uncertainty}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','EPU',res2.bv(2,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res2.tbv(2,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','MPU',res2.bv(3,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res2.tbv(3,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Constant',res2.bv(1,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res2.tbv(1,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\\midrule\n','R$^{2}\left(\%\right)$',res2.R2v);
fprintf(fid,'%s \\\\\\midrule\n','\multicolumn{8}{c}{Panel C: Yield curve factors}');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Level',res3.bv(2,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res3.tbv(2,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Slope',res3.bv(3,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res3.tbv(3,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Curv',res3.bv(4,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res3.tbv(4,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Constant',res3.bv(1,:));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res3.tbv(1,:));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','R$^{2}\left(\%\right)$',res3.R2v);
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
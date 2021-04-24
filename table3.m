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
disp('# Replicating Table 3 from "Asset Pricing and FOMC Press Conferences" ');
fprintf('# Code initiated: %.0f:%.0f on %.0f/%0.f-%0.f \n',c([4:5 3 2 1])    );
disp('# ****************************************************************** #');

% Reading in data from matfiles
load('data/yieldPCA.mat');
load('data/factorData.mat');
load('data/dispersionTimeSeries.mat');

% Adapting data to 2011-2018 sample
yieldFactors        = yieldFactors(8494:14883,:);
yieldFactors        = [datenum(yieldFactors(:,1:3)) yieldFactors(:,4:end)];
mktRet              = ff.ff3f;
mktRet(:,1)         = datenum(num2str(mktRet(:,1)),'yyyymmdd');
[~,tmp,tmp1]        = intersect(mktRet(:,1),yieldFactors(:,1),'stable');
yieldFactors        = yieldFactors(tmp1,:);

% Defining the different types of days
fomc                = fomcIdx(4345:end,:);
pcIdx               = (fomc(:,2) == 1 & fomc(:,3) == 1);
npcIdx              = (fomc(:,2) == 1 & fomc(:,3) == 0);
adaysIdx            = (fomc(:,2) == 1);
ndaysIdx            = (fomc(:,2) == 0);
pcIdxAnn            = pcIdx(adaysIdx,:);

% Computing drop -15 to +30 min around 
betaDispAnnouncement    = (dispersion(41+20,:)-dispersion(41-5,:));
betaDispAnnouncement    = betaDispAnnouncement';

% Setting explanatory variables to days prior to announcement day
vixAnnDays  = log(vix(4343:end-2,:));
vixAnnDays  = standard(vixAnnDays(adaysIdx,:));

tvixAnnDays = log(tvix(4343:end-2,:));
tvixAnnDays = standard(tvixAnnDays(adaysIdx,:));

epuAnnDays  = log(epu(4343:end-2,:));
epuAnnDays  = standard(epuAnnDays(adaysIdx,:));

mpuAnnDays  = standard(diff((hrs(1:end,:))));

levAnnDays  = yieldFactors(4343:end-2,2);
levAnnDays  = standard(levAnnDays(adaysIdx,:));

slpAnnDays  = yieldFactors(4343:end-2,3);
slpAnnDays  = standard(slpAnnDays(adaysIdx,:));

cuvAnnDays  = yieldFactors(4343:end-2,4);
cuvAnnDays  = standard(cuvAnnDays(adaysIdx,:));

% Running regressions for beta dispersion
res1        = linRegress(betaDispAnnouncement,vixAnnDays,1,'NW',3);
res2        = linRegress(betaDispAnnouncement,tvixAnnDays,1,'NW',3);
res3        = linRegress(betaDispAnnouncement,epuAnnDays,1,'NW',3);
res4        = linRegress(betaDispAnnouncement,mpuAnnDays,1,'NW',3);
res5        = linRegress(betaDispAnnouncement,[levAnnDays slpAnnDays cuvAnnDays],1,'NW',3);
res6        = linRegress(betaDispAnnouncement,[vixAnnDays epuAnnDays levAnnDays slpAnnDays],1,'NW',3);

% Writing output to latex table
fid = fopen('output/table3.tex','w');
fprintf(fid,'%s & %s & %s & %s & %s & %s & %s \\\\\\midrule\n','','(1)','(2)','(3)','(4)','(5)','(6)');
fprintf(fid,'%s & %.2f & %s & %s & %s & %s & %.2f \\\\\n','VIX',res1.bv(2),'','','','',res6.bv(2));
fprintf(fid,'%s & [%.2f] & %s & %s & %s & %s & [%.2f] \\\\\n','',res1.tbv(2),'','','','',res6.tbv(2));
fprintf(fid,'%s & %s & %.2f & %s & %s & %s & %s \\\\\n','TYVIX','',res2.bv(2),'','','','');
fprintf(fid,'%s & %s & [%.2f] & %s & %s & %s & %s \\\\\n','','',res2.tbv(2),'','','','');
fprintf(fid,'%s & %s & %s & %.2f & %s & %s & %.2f \\\\\n','EPU','','',res3.bv(2),'','',res6.bv(3));
fprintf(fid,'%s & %s & %s & [%.2f] & %s & %s & [%.2f] \\\\\n','','','',res3.tbv(2),'','',res6.tbv(3));
fprintf(fid,'%s & %s & %s & %s & %.2f & %s & %s \\\\\n','MPU','','','',res4.bv(2),'','');
fprintf(fid,'%s & %s & %s & %s & [%.2f] & %s & %s \\\\\n','','','','',res4.tbv(2),'','');
fprintf(fid,'%s & %s & %s & %s & %s & %.2f & %.2f \\\\\n','Level','','','','',res5.bv(2),res6.bv(4));
fprintf(fid,'%s & %s & %s & %s & %s & [%.2f] & [%.2f] \\\\\n','','','','','',res5.tbv(2),res6.tbv(4));
fprintf(fid,'%s & %s & %s & %s & %s & %.2f & %.2f \\\\\n','Slope','','','','',res5.bv(3),res6.bv(5));
fprintf(fid,'%s & %s & %s & %s & %s & [%.2f] & [%.2f] \\\\\n','','','','','',res5.tbv(3),res6.tbv(5));
fprintf(fid,'%s & %s & %s & %s & %s & %.2f & %s \\\\\n','Curv','','','','',res5.bv(4),'');
fprintf(fid,'%s & %s & %s & %s & %s & [%.2f] & %s \\\\\n','','','','','',res5.tbv(4),'');
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','Constant',res1.bv(1),res2.bv(1),res3.bv(1),res4.bv(1),res5.bv(1),res6.bv(1));
fprintf(fid,'%s & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] & [%.2f] \\\\\n','',res1.tbv(1),res2.tbv(1),res3.tbv(1),res4.tbv(1),res5.tbv(1),res6.tbv(1));
fprintf(fid,'%s & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\\n','R$^{2}\left(\%\right)$',res1.R2v,res2.R2v,res3.R2v,res4.R2v,res5.R2v,res6.R2v);
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
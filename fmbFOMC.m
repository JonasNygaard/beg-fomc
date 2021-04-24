function fmbOut = fmbFOMC(testAssets,riskFactors,fomcIdx)

%% fmbFOMC.m
% ########################################################################### %
% function  fmbOut = fmbFOMC(testAssets,riskFactors,fomcIdx)
% Purpose:  Estimate linear asset pricing models using the Fama and MacBeth
%           (1973) two-pass cross-sectional regression methodology across
%           FOMC announcement days with and without a press conference and 
%           non-announcement days. 
%
% Input:    testAssets      = A T x N matrix of asset returns
%           riskFactors     = A T x K matrix of risk factors (excluding constant)
%           fomcIdx         = A T x D matrix of indictors for various FOMC days
%
% Output:   A struct with betas, risk prices, t-statistics, and various diagnostics
%               
% Author:
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg
% Department of Economics and Business Economics
% Aarhus University and CREATES
%
% Encoding: UTF8
% Last modified: March, 2021
% ########################################################################### %

%% Error checking on input parameters
if (nargin < 3)
    error('famaMacBeth.m: Not enough input parameters');
end

if (nargin > 3)
    error('famaMacBeth.m: Too many input parameters');
end

if (size(testAssets,1) ~= size(riskFactors,1))
    error('famaMacBeth.m: Unequal number of time series observations');
end

if (size(testAssets,1) ~= size(fomcIdx,1))
    error('famaMacBeth.m: Unequal number of time series observations');
end

%% Computing time series betas: Full sample and day-specific
% ########################################################################### %
%{
    We run time series regressions for each portfolio/asset of the kind

            r_{i,t}-r_{f,t} = a_{i} + b_{i}F_{t} + e_{i,t}

    where we always include a constant in the regression. We compute betas 
    in two different ways to illustrate the impact of taking time variations 
    in betas into account: full sample betas using all available information
    and day-specific betas using information on specific days only. 
%}
% ########################################################################### %

% Getting data dimensions
[nObs,nAss]     = size(testAssets);
nFac            = size(riskFactors,2);

% Create announcement day dummies for each type of day
adaysIdx        = ( fomcIdx(:,1) == 1 );
ndaysIdx        = ( fomcIdx(:,1) == 0 );
pcIdx           = ( fomcIdx(:,1) == 1 & fomcIdx(:,2) == 1 );
npcIdx          = ( fomcIdx(:,1) == 1 & fomcIdx(:,2) == 0 );

% Estimating full sample time series betas 
betas.full      = [ones(nObs,1) riskFactors]\testAssets;

% Estimating day-specific time series betas
betas.ndays     = [ ones(sum(ndaysIdx),1) riskFactors(ndaysIdx,:) ] \ testAssets(ndaysIdx,:);
betas.adays     = [ ones(sum(adaysIdx),1) riskFactors(adaysIdx,:) ] \ testAssets(adaysIdx,:);
betas.pc        = [ ones(sum(pcIdx),1) riskFactors(pcIdx,:) ] \ testAssets(pcIdx,:);
betas.npc       = [ ones(sum(npcIdx),1) riskFactors(npcIdx,:) ] \ testAssets(npcIdx,:);

% Saving betas to struct
fmbOut.betas    = betas;

%% Second-pass cross-sectional regressions: Full sample betas
% ########################################################################### %
%{
    We run cross-sectional regressions for each time t = 1,...,T of the kind

            r_{i,t}-r_{f,t} = γ_0 + γ'β_{i} + u_{i,t}

    with an intercept as a default. We use full sample betas in this part. 
%}
% ########################################################################### %

% Preallocations of risk prices
tsGamma         = NaN(nObs,nFac+1);
tsPriceErr      = NaN(nObs,nAss);

% Estimating day-specific risk prices using full sample betas
for iObs = 1:nObs

    tsGamma(iObs,:)     = [ones(nAss,1) betas.full(2:end,:)']\testAssets(iObs,:)';
    tsPriceErr(iObs,:)   = testAssets(iObs,:) - ([ones(nAss,1) betas.full(2:end,:)']*tsGamma(iObs,:)')';

end

% Estimating risk prices across the days
gammaF.full     = mean(tsGamma);
gammaF.adays    = mean(tsGamma(adaysIdx,:));
gammaF.ndays    = mean(tsGamma(ndaysIdx,:));
gammaF.pc       = mean(tsGamma(pcIdx,:));
gammaF.npc      = mean(tsGamma(npcIdx,:));

% Estimating standard errors across the days
seGammaF.full   = sqrt(sum((tsGamma-repmat(gammaF.full,nObs,1)).^2)/nObs^2);
seGammaF.adays  = sqrt(sum((tsGamma(adaysIdx,:)-repmat(gammaF.adays,sum(adaysIdx,1),1)).^2)/sum(adaysIdx,1)^2);
seGammaF.ndays  = sqrt(sum((tsGamma(ndaysIdx,:)-repmat(gammaF.ndays,sum(ndaysIdx,1),1)).^2)/sum(ndaysIdx,1)^2);
seGammaF.pc     = sqrt(sum((tsGamma(pcIdx,:)-repmat(gammaF.pc,sum(pcIdx,1),1)).^2)/sum(pcIdx,1)^2);
seGammaF.npc    = sqrt(sum((tsGamma(npcIdx,:)-repmat(gammaF.npc,sum(npcIdx,1),1)).^2)/sum(npcIdx,1)^2);

% Constructing t-statistics across the days
tGammaF.full    = gammaF.full./seGammaF.full;
tGammaF.adays   = gammaF.adays./seGammaF.adays;
tGammaF.ndays   = gammaF.ndays./seGammaF.ndays;
tGammaF.pc      = gammaF.pc./seGammaF.pc;
tGammaF.npc     = gammaF.npc./seGammaF.npc;

% Computing mean returns across the days
means.full      = mean(testAssets)';
means.adays     = mean(testAssets(adaysIdx,:))';
means.ndays     = mean(testAssets(ndaysIdx,:))';
means.pc        = mean(testAssets(pcIdx,:))';
means.npc       = mean(testAssets(npcIdx,:))';

% Computing fitted values across the days
fitF.full       = [ones(nAss,1) betas.full(2:end,:)']*gammaF.full';
fitF.adays      = [ones(nAss,1) betas.full(2:end,:)']*gammaF.adays';
fitF.ndays      = [ones(nAss,1) betas.full(2:end,:)']*gammaF.ndays';
fitF.pc         = [ones(nAss,1) betas.full(2:end,:)']*gammaF.pc';
fitF.npc        = [ones(nAss,1) betas.full(2:end,:)']*gammaF.npc';

% Computing cross-sectional R-squared values across the days
rsqrF.full      = 100*( 1 - mean(mean(tsPriceErr)'.^2) ./ mean((means.full' - ones(1,nAss) * mean(means.full')).^2));
rsqrF.adays     = 100*( 1 - mean(mean(tsPriceErr(adaysIdx,:))'.^2) ./ mean((means.adays' - ones(1,nAss) * mean(means.adays')).^2));
rsqrF.ndays     = 100*( 1 - mean(mean(tsPriceErr(ndaysIdx,:))'.^2) ./ mean((means.ndays' - ones(1,nAss) * mean(means.ndays')).^2));
rsqrF.pc        = 100*( 1 - mean(mean(tsPriceErr(pcIdx,:))'.^2) ./ mean((means.pc' - ones(1,nAss) * mean(means.pc')).^2));
rsqrF.npc       = 100*( 1 - mean(mean(tsPriceErr(npcIdx,:))'.^2) ./ mean((means.npc' - ones(1,nAss) * mean(means.npc')).^2));

% Computing mean absolute pricing errors across the days
mapeF.full      = 100.*nanmean(abs(fitF.full - means.full));
mapeF.adays     = 100.*nanmean(abs(fitF.adays - means.adays));
mapeF.ndays     = 100.*nanmean(abs(fitF.ndays - means.ndays));
mapeF.pc        = 100.*nanmean(abs(fitF.pc - means.pc));
mapeF.npc       = 100.*nanmean(abs(fitF.npc - means.npc));

% Computing joint test on cross-sectional pricing errors across the days
chiF.full       = mean(tsPriceErr)*(pinv(hacNW(tsPriceErr,1)./nObs))*mean(tsPriceErr)';
chiF.adays      = mean(tsPriceErr(adaysIdx,:))*(pinv(hacNW(tsPriceErr(adaysIdx,:),1)./sum(adaysIdx)))*mean(tsPriceErr(adaysIdx,:))';
chiF.ndays      = mean(tsPriceErr(ndaysIdx,:))*(pinv(hacNW(tsPriceErr(ndaysIdx,:),1)./sum(ndaysIdx)))*mean(tsPriceErr(ndaysIdx,:))';
chiF.pc         = mean(tsPriceErr(pcIdx,:))*(pinv(hacNW(tsPriceErr(pcIdx,:),1)./sum(pcIdx)))*mean(tsPriceErr(pcIdx,:))';
chiF.npc        = mean(tsPriceErr(npcIdx,:))*(pinv(hacNW(tsPriceErr(npcIdx,:),1)./sum(npcIdx)))*mean(tsPriceErr(npcIdx,:))';

% Computing p-values for the joint tests across the days
chiF.full(1,2)  = 1-chi2cdf(chiF.full,nAss-1);
chiF.ndays(1,2) = 1-chi2cdf(chiF.ndays,nAss-1);
chiF.adays(1,2) = 1-chi2cdf(chiF.adays,nAss-1);
chiF.pc(1,2)    = 1-chi2cdf(chiF.pc,nAss-1);
chiF.npc(1,2)   = 1-chi2cdf(chiF.npc,nAss-1);

% Testing for differences across the different types of days
gammaF.pcDiff   = gammaF.pc - gammaF.ndays;
gammaF.npcDiff  = gammaF.npc - gammaF.ndays;
gammaF.anDiff   = gammaF.adays - gammaF.ndays;
tGammaF.pcDiff  = (gammaF.pcDiff)./sqrt((seGammaF.pc.^2) + (seGammaF.ndays.^2));
tGammaF.npcDiff = (gammaF.npcDiff)./sqrt((seGammaF.npc.^2) + (seGammaF.ndays.^2));
tGammaF.anDiff  = (gammaF.anDiff)./sqrt((seGammaF.adays.^2) + (seGammaF.ndays.^2));

% Collecting cross-sectional output in struct
fmbOut.gammaF   = gammaF;
fmbOut.seGammaF = seGammaF;
fmbOut.tGammaF  = tGammaF;
fmbOut.errors   = tsPriceErr;
fmbOut.means    = means;
fmbOut.fitF     = fitF;
fmbOut.rsqrF    = rsqrF;
fmbOut.mapeF    = mapeF;
fmbOut.chiF     = chiF;

%% Second-pass cross-sectional regressions: Day-specific betas
% ########################################################################### %
%{
    We run cross-sectional regressions for each time t = 1,...,T of the kind

            r_{i,t}-r_{f,t} = γ_0 + γ'β_{i}^{D} + u_{i,t}

    with an intercept as a default. We use day-specific betas in this part.
%}
% ########################################################################### %

% Preallocations of risk prices
tsGammaD        = NaN(nObs,nFac+1,4);
tsPriceErrD     = NaN(nObs,nAss,4);

% Estimating day-specific risk prices using day-specific betas
for iObs = 1:nObs

    % Estimating announcement day risk prices
    if ( adaysIdx(iObs,1) == 1 )
        tsGammaD(iObs,:,1)      = [ones(nAss,1) betas.adays(2:end,:)']\testAssets(iObs,:)';
        tsPriceErrD(iObs,:,1)   = testAssets(iObs,:) - ([ones(nAss,1) betas.adays(2:end,:)']*tsGammaD(iObs,:,1)')';
    end

    % Estimating non-announcement day risk prices
    if ( ndaysIdx(iObs,1) == 1 )
        [ones(nAss,1) betas.ndays(2:end,:)']\testAssets(iObs,:)';
        tsGammaD(iObs,:,2)      = [ones(nAss,1) betas.ndays(2:end,:)']\testAssets(iObs,:)';
        tsPriceErrD(iObs,:,2)   = testAssets(iObs,:) - ([ones(nAss,1) betas.ndays(2:end,:)']*tsGammaD(iObs,:,2)')';
    end

    % Estimating PC day risk prices
    if ( pcIdx(iObs,1) == 1 )
        tsGammaD(iObs,:,3)      = [ones(nAss,1) betas.pc(2:end,:)']\testAssets(iObs,:)';
        tsPriceErrD(iObs,:,3)   = testAssets(iObs,:) - ([ones(nAss,1) betas.pc(2:end,:)']*tsGammaD(iObs,:,3)')';
    end

    % Estimating non-PC day risk prices
    if ( npcIdx(iObs,1) == 1 )
        tsGammaD(iObs,:,4)      = [ones(nAss,1) betas.npc(2:end,:)']\testAssets(iObs,:)';
        tsPriceErrD(iObs,:,4)   = testAssets(iObs,:) - ([ones(nAss,1) betas.npc(2:end,:)']*tsGammaD(iObs,:,4)')';
    end

end

% Estimating risk prices across the days
gammaD.adays    = nanmean(tsGammaD(adaysIdx,:,1));
gammaD.ndays    = nanmean(tsGammaD(ndaysIdx,:,2));
gammaD.pc       = nanmean(tsGammaD(pcIdx,:,3));
gammaD.npc      = nanmean(tsGammaD(npcIdx,:,4));


% Estimating standard errors across the days
seGammaD.adays  = sqrt(sum((tsGammaD(adaysIdx,:,1)-repmat(gammaD.adays,sum(adaysIdx,1),1)).^2)/sum(adaysIdx,1)^2);
seGammaD.ndays  = sqrt(sum((tsGammaD(ndaysIdx,:,2)-repmat(gammaD.ndays,sum(ndaysIdx,1),1)).^2)/sum(ndaysIdx,1)^2);
seGammaD.pc     = sqrt(sum((tsGammaD(pcIdx,:,3)-repmat(gammaD.pc,sum(pcIdx,1),1)).^2)/sum(pcIdx,1)^2);
seGammaD.npc    = sqrt(sum((tsGammaD(npcIdx,:,4)-repmat(gammaD.npc,sum(npcIdx,1),1)).^2)/sum(npcIdx,1)^2);

% Constructing t-statistic across the days
tGammaD.adays   = gammaD.adays./seGammaD.adays;
tGammaD.ndays   = gammaD.ndays./seGammaD.ndays;
tGammaD.pc      = gammaD.pc./seGammaD.pc;
tGammaD.npc     = gammaD.npc./seGammaD.npc;

% Computing fitted values across the days
fitD.adays      = [ones(nAss,1) betas.adays(2:end,:)']*gammaD.adays';
fitD.ndays      = [ones(nAss,1) betas.ndays(2:end,:)']*gammaD.ndays';
fitD.pc         = [ones(nAss,1) betas.pc(2:end,:)']*gammaD.pc';
fitD.npc        = [ones(nAss,1) betas.npc(2:end,:)']*gammaD.npc';

% Computing cross-sectional R-squared values across the days
rsqrD.adays     = 100*( 1 - mean(mean(tsPriceErrD(adaysIdx,:,1))'.^2) ./ mean((means.adays' - ones(1,nAss) * mean(means.adays')).^2));
rsqrD.ndays     = 100*( 1 - mean(mean(tsPriceErrD(ndaysIdx,:,2))'.^2) ./ mean((means.ndays' - ones(1,nAss) * mean(means.ndays')).^2));
rsqrD.pc        = 100*( 1 - mean(mean(tsPriceErrD(pcIdx,:,3))'.^2) ./ mean((means.pc' - ones(1,nAss) * mean(means.pc')).^2));
rsqrD.npc       = 100*( 1 - mean(mean(tsPriceErrD(npcIdx,:,4))'.^2) ./ mean((means.npc' - ones(1,nAss) * mean(means.npc')).^2));

% Computing mean absolute pricing errors across the days
mapeD.adays     = 100.*nanmean(abs(fitD.adays - means.adays));
mapeD.ndays     = 100.*nanmean(abs(fitD.ndays - means.ndays));
mapeD.pc        = 100.*nanmean(abs(fitD.pc - means.pc));
mapeD.npc       = 100.*nanmean(abs(fitD.npc - means.npc));

% Computing joint test on cross-sectional pricing errors across the days
chiD.adays      = mean(tsPriceErrD(adaysIdx,:,1))*(pinv(hacNW(tsPriceErrD(adaysIdx,:,1),1)./sum(adaysIdx)))*mean(tsPriceErrD(adaysIdx,:,1))';
chiD.ndays      = mean(tsPriceErrD(ndaysIdx,:,2))*(pinv(hacNW(tsPriceErrD(ndaysIdx,:,2),1)./sum(ndaysIdx)))*mean(tsPriceErrD(ndaysIdx,:,2))';
chiD.pc         = mean(tsPriceErrD(pcIdx,:,3))*(pinv(hacNW(tsPriceErrD(pcIdx,:,3),1)./sum(pcIdx)))*mean(tsPriceErrD(pcIdx,:,3))';
chiD.npc        = mean(tsPriceErrD(npcIdx,:,4))*(pinv(hacNW(tsPriceErrD(npcIdx,:,4),1)./sum(npcIdx)))*mean(tsPriceErrD(npcIdx,:,4))';

% Computing p-values for the joint tests across the days
chiD.ndays(1,2) = 1-chi2cdf(chiD.ndays,nAss-1);
chiD.adays(1,2) = 1-chi2cdf(chiD.adays,nAss-1);
chiD.pc(1,2)    = 1-chi2cdf(chiD.pc,nAss-1);
chiD.npc(1,2)   = 1-chi2cdf(chiD.npc,nAss-1);

% Testing for differences across the different types of days
gammaD.pcDiff   = gammaD.pc - gammaD.ndays;
gammaD.npcDiff  = gammaD.npc - gammaD.ndays;
gammaD.anDiff   = gammaD.adays - gammaD.ndays;
tGammaD.pcDiff  = (gammaD.pcDiff)./sqrt((seGammaD.pc.^2) + (seGammaD.ndays.^2));
tGammaD.npcDiff = (gammaD.npcDiff)./sqrt((seGammaD.npc.^2) + (seGammaD.ndays.^2));
tGammaD.anDiff  = (gammaD.anDiff)./sqrt((seGammaD.adays.^2) + (seGammaD.ndays.^2));

% Collecting cross-sectional output in struct
fmbOut.gammaD   = gammaD;
fmbOut.seGammaD = seGammaD;
fmbOut.tGammaD  = tGammaD;
fmbOut.errorsD  = tsPriceErrD;
fmbOut.fitD     = fitD;
fmbOut.rsqrD    = rsqrD;
fmbOut.mapeD    = mapeD;
fmbOut.chiD     = chiD;

end

% ########################################################################### %
% END OF FUNCTION
% ########################################################################### %
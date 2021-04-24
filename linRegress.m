function regResults = linRegress(y,x,constant,method,nlag)

%% linRegress.m
% ########################################################################### %
% function regResults = linRegress(y,x,constant,method,nlag)
% Purpose:  Estimate a linear regression model with user-specified standard
%           errors that include OLS, White, Newey-West, and Hansen-Hodrick.
%           A constant is added by default unless otherwise specified.
%
% Input:    y = T x N matrix of dependent variables (N seperate regressions)
%           x = A T x K matrix of common explanatory variables
%           constant = 1 to add constant internatally, 0 otherwise
%           method  = Flag for chosing standard errors. Included are
%                   - 'Skip' for skipping standard errors
%                   - 'OLS' for standard iid setting standard errors
%                   - 'W' for White (1980) standard errors
%                   - 'NW' for Newey and West (1987) standard errors
%                   - 'HH' for Hansen and Hodrick (1980) standard errors
%           nlag = Scalar indicating the number of lags to include
%
% Output:   A structure including
%           bv        = A K x N matrix of parameter estimates
%           sbv       = A K x N matrix of user-selected standard errors
%           tbv       = A K x N matrix of t-statistics
%           R2v       = A N x 1 vector of r-square values
%           R2vadj    = A N x 1 vector of adjusted r-square values
%           s2        = A N x 1 vector of residual variances
%           F         = A N x 3 matrix of joint F-test on parameters
%           bic       = A N x 1 vector of Schwartz-Bayesian Information criteria
%
% Author:
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg
% Department of Economics and Business Economics
% Aarhus University and CREATES
%
% Encoding: UTF8
% Last modified: January, 2018
% ########################################################################### %

%% Error checking on input and setting preliminaries
if size(x,1) ~= size(y,1)
    error('linRegress.m: Unequal number of observations in y and x');
end

if (nargin < 2)
    error('linRegress.m: Not enough input parameters')
end

if (nargin > 5)
    error('linRegress.m: Too many input parameters');
end

if ~ismember(method,[{'Skip'},{'OLS'},{'W'},{'NW'},{'HH'}])
    error('linRegress.m: Wrong specification for standard errors');
end

if (nargin < 3)
    constant =1;
    method = 'OLS';
    nlag = 0;
end

if (nargin < 5) && ismember(method,[{'NW'},{'HH'}])
    error('linRegress.m: Lag length left unspecified');
elseif (nargin < 5) && ~ismember(method,[{'NW'},{'HH'}])
    nlag = 0;
end

if constant == 1
    x = [ones(size(x,1),1) x];
end

%% Model estimation
% ########################################################################### %
%{
    We compute parameter estimates and other common statistics that does not
    depend on the variance-covariance matrix of the residuals.
%}
% ########################################################################### %

% Setting preliminaries
[nObs,nReg] = size(y);
nVars       = size(x,2);

% Computing coefficient estimates
bv      = x\y;

% Computing input for standard errors
Exx     = x'*x/nObs;
fitted  = x*bv;
errv    = y - x*bv;

% Computing coefficient of determination
s2      = sum(errv.^2)/nObs;
vary    = mean((y - ones(nObs,1) * mean(y)).^2);
R2v     = 100.*(1 - s2./vary)';
R2vadj  = 100.*(1 - (s2./vary) * (nObs-1)/(nObs-nVars))';

% Computing information criteria
bic     = log(s2) + nVars*log(nObs)/nObs;

%% Computing standard errors according to method
% ########################################################################### %
%{
    We compute standard errors according to the user-specified input. The
    choices are
%}
% ########################################################################### %

% Preallocations
sbv     = zeros(nVars,nReg);
tbv     = zeros(nVars,nReg);
fv      = zeros(nReg,3);

% Running individual regressions for each dependent variable
for iReg = 1:nReg

    % Skipping standard errors
    if strcmp(method,'Skip')

        varb    = NaN(nVars,nVars);

    % Standard OLS standard errors
    elseif strcmp(method,'OLS')

        err     = errv(:,iReg);
        s2i     = mean(err.^2);
        varb    = s2i.*(Exx\eye(nVars))/nObs;

    % White (1980) standard errors
    elseif strcmp(method,'W')

        err     = errv(:,iReg);
        inner   = (x.*(err*ones(1,nVars)))' * (x.*(err*ones(1,nVars))) / nObs;
        varb    = Exx\inner/Exx/nObs;

    % Newey and West (1987) standard errors
    elseif strcmp(method,'NW')

        ww      = 1;
        err     = errv(:,iReg);
        inner   = (x.*(err*ones(1,nVars)))' * (x.*(err*ones(1,nVars))) / nObs;

        for iLag = 1:nlag


            innadd  = (x(1:nObs-iLag,:).*(err(1:nObs-iLag)*ones(1,nVars)))'*...
                (x(1+iLag:nObs,:).*(err(1+iLag:nObs)*ones(1,nVars)))/nObs;
            inner   = inner + (1-ww*iLag/(nlag+1))*(innadd+innadd');

        end
        varb = Exx\inner/Exx/nObs;

    % Hansen and Hodrick (1980) standard errors
    elseif strcmp(method,'HH')

        err     = errv(:,iReg);
        inner   = (x.*(err*ones(1,nVars)))' * (x.*(err*ones(1,nVars))) / nObs;

        for iLag = 1:nlag

            innadd  = (x(1:nObs-iLag,:).*(err(1:nObs-iLag)*ones(1,nVars)))'*...
                    (x(1+iLag:nObs,:).*(err(1+iLag:nObs)*ones(1,nVars)))/nObs;
            % inner   = inner + (1-ww*iLag/(nlag+1))*(innadd+innadd');
            inner   = inner + innadd+innadd';

        end
        varb = Exx\inner/Exx/nObs;

    end

    % Computing and saving standard errors and t-statistics
    if strcmp(method,'Skip')

        fv(iReg,:)  = NaN;
        sbv(:,iReg) = NaN;
        tbv(:,iReg) = NaN;

    else

        chi2val     = bv(2:end,iReg)'*((varb(2:end,2:end))\bv(2:end,iReg));
        df          = size(bv(2:end,1),1);
        pval        = 1 - cdf('chi2',chi2val,df);
        fv(iReg,:)  = [chi2val df pval];
        sbv(:,iReg) = sqrt(diag(varb));
        tbv(:,iReg) = bv(:,iReg)./sbv(:,iReg);

    end

end

% Creating structure for results
regResults.bv       = bv;
regResults.sbv      = sbv;
regResults.tbv      = tbv;
regResults.R2v      = R2v;
regResults.R2vadj   = R2vadj;
regResults.s2       = s2;
regResults.F        = fv;
regResults.bic      = bic;
regResults.fit      = fitted;
regResults.resid    = errv;

end

% ########################################################################### %
% [EOF]
% ########################################################################### %
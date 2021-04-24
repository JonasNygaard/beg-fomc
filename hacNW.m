function S = hacNW(data,bandWidth)

%% hacNW.m
% ########################################################################### %
% function  S = hacNW(data,bandWidth)
% Purpose:  Estimate covariance matrix using Newey-West (1987) estimator 
%
% Input:    data        = T x N maxtrix of input data
%           bandWidth   = Scalar indicating number of lags to include
%
% Output:   Covariance matrix estimating using Newey-West (1987) estimator 
%               
% Author:
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg
% Department of Economics and Business Economics
% Aarhus University and CREATES
%
% Encoding: UTF8
% Last modified: March, 2021
% ########################################################################### %

% Error checking on input
if (nargin > 2)
    error('hacNW.m: Too many input arguments');
end

if (nargin < 2)
    error('hacNW.m: Not enough input arguments');
end

if (nnz(isnan(data)) ~= 0)
    error('hacNW.m: Data contains NaN entries');
end

%% Estimate covariance matrix using Bartlett kernel (Newey and West, 1987)
% ########################################################################### %
%{
    We estimate the HAC covariance matrix using the Bartlett kernel following
    Newey and West (1987) using a user supplied bandwidth selection.  
%}
% ########################################################################### %

% Getting data dimensions
nObs    = size(data,1);

% Demean data
data    = data - mean(data);

% Specify Bartlett kernel weights
bartw   = ( bandWidth + 1- (0:bandWidth) ) ./ ( bandWidth+1 );

% Initialize covariance matrix
V       = data'*data/nObs;

% Estimate addition for each lag
for iLag = 1:bandWidth
    Gammai      = (data((iLag+1):nObs,:)'*data(1:nObs-iLag,:))/nObs;
    GplusGprime = Gammai+Gammai';
    V           = V + bartw(iLag+1)*GplusGprime;
end

% Final estimate
S = V;

% ########################################################################### %
% [EOF]
% ########################################################################### %
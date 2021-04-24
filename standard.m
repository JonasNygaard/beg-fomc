function x = standard(y)

%% standard.m
% ########################################################################### %
% function  x = standard(y)
% Purpose:  Standardize vector or matrix of data (handles NaN data)
%
% Input:    y = T x N matrix of data
%
% Output:   x = T x N matrix of standardized data 
%               
% Author:
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg
% Department of Economics and Business Economics
% Aarhus University and CREATES
%
% Encoding: UTF8
% Last modified: April, 2018
% ########################################################################### %

% Number of observations
T   = size(y,1);

% Creating vector of means
my  = repmat(nanmean(y),T,1);

% Creating vector of standard deviations
sy  = repmat(nanstd(y),T,1);

% Standardizing
x   = (y-my)./sy;

end

% ########################################################################### %
% [EOF]
% ########################################################################### %
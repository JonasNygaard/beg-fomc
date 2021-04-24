function brewedColors = colorBrewer(numColors)

%% colorBrewer.m
% ########################################################################### %
% function  brewedColors = colorBrewer(numColors)
% Purpose:  Create a vector of RGB colors based on a pre-defined set
%
% Input:    numColors   = Scalar indicating the number of colors needed
%
% Output:   brewedColor = Matrix of RGB codes for colors for plots
%               
% Author:
% Simon Bodilsen, Jonas N. Eriksen, and Niels S. Grønborg
% Department of Economics and Business Economics
% Aarhus University and CREATES
%
% Encoding: UTF8
% Last modified: March, 2021
% ########################################################################### %

if (nargin > 3)
    error('colorBrewer.m: Too many input arguments');
end

if (nargin < 1)
    error('colorBrewer.m: Not enough input arguments');
end

if (numColors > 6)
    error('colorBrewer.m: A most six colors are currently supported');
end

if (numColors < 0)
    error('colorBrewer.m: Negative number of colors not a valid input');
end

%% Setting RGB values for color palette
% ########################################################################### %
%{
    We consider different set of colors. The first three are based heavily 
    on colorbrewer2.org, whereas the remaining schemes are mixes of different 
    colors that simply looks nice on print. 
%}
% ########################################################################### %

% Setting RGB values
rgbValues = [
    52      109     241
    208     45      43
    239     166     9
    23      143     70
    102     51      153
    154     156     149
]./255;

% Setting output
if ismember(numColors,1:6)

    brewedColors  = rgbValues(numColors,:);

else

    brewedColors  = rgbValues;

end

end

% ########################################################################### %
% [EOF]
% ########################################################################### %
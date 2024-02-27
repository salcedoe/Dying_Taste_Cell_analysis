function fh = mmfig()
%MMFIGURE basic settings for the figure function (helps avoid the dreaded
%decoration crash on Mac Computers when trying to manually close figures by clicking on red x)
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado School of Medicine
% updated: 1/13/2024

fh = figure(Visible="on",WindowStyle="docked",Color='white');
end
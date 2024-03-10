function [vCell,vLys, szLys] = getVertsAndAlign(VL,CellID,polarity) 
%GETVERTSFROMCELLID Returns cell and lysosome vertices 
%lysosomes. Recenters cell to 0,0,0 and Reorients  so that the cell's long axis
% is parallel to the z-axis
% getVertsAndAlign
% REQUIREMENTS: MATGEOM toolbox
% OUTPUTS
%   - vCell: matrix of reoriented x,y,z coordinates for cell vertices
%   - vLys: matrix of reoriented x,y,z coordinates for lysosomes vertices
%   - szLys: vector of lysosome size labels (normalized volume measurements
%       across all cells. Used to for lysosome plot colormap)

arguments
    VL table % vertices table of all objects
    CellID {mustBeText} % cell name
    polarity (1,1) {mustBeNumeric} % -1 means to flip orientation of cell
end

idT = VL.Properties.UserData.idT;

% get vertices
object = idT.Lysosome(idT.Cell == CellID);
la = VL.Object == object;
vLys = (VL{la,["x" "y" "z"]});
szLys = VL.SizeLabel(la);

object = idT.Cell(idT.Cell == CellID);
vCell = (VL{VL.Object == object,["x" "y" "z"]});

% transform vertices
vLys = vLys - mean(vCell); % center to 0,0,0
vCell = vCell - mean(vCell);

[~,~,V]=svd(vCell,0); % Find the direction of most variance
vCell =  vCell * V;
vLys = vLys * V;

% align to z-axis
angl = 90 * polarity;
vCell = mmRotateSurfaceVertices(vCell,'y',angl);
vLys = mmRotateSurfaceVertices(vLys,'y',angl);

% rotate around z-axis
vCell = mmRotateSurfaceVertices(vCell,'z',90);
vLys = mmRotateSurfaceVertices(vLys,'z',90);
   
end
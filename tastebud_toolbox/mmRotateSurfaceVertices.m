function vertices = mmRotateSurfaceVertices(vertices, ax, angl)
%MMROTATESURFACEVERTICES Rotate the vertices of a surface around the 
%       specified axis by the specified angle (in degrees). requires
%       matgeom.
% INPUTS
%   - vertices (matrix): Nx3 vertices
%   - ax (character array): axis around which to rotate — x, y, or z
%   - angl (scalar): amount (in degrees) to rotate 
% 
% EXAMPLE
%   vertices = mmRotateSurfaceVertices(vertices, 'x',45)
% ---
% Author: Ernesto Salcedo, PhD
% Site: University of Colorado School of Medicine
% Updated: 2/25/2023

arguments
    vertices (:,3) double
    ax string
    angl (1,1) double   
end

if ~exist('createRotationOx','file')
    disp('MatGeom Required. Try running setupMatGeom')
    return
end

theta = deg2rad(angl);

switch lower(ax)
    case 'x'
        tform = createRotationOx(theta); % rotate z angle
    case 'y'
        tform = createRotationOy(theta); % rotate y angle
    case 'z'
        tform = createRotationOz(theta); % rotate y angle
    otherwise
        disp('axis not found')
        return
end

tform = affine3d(tform);
vertices = transformPointsForward(tform, vertices);

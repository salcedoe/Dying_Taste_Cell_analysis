function [volMP, volFX] = getWaterTightMesh(shp,mesh_name, paths,options)
%GETWATERTIGHTMESH Accepts a surfaceMesh object (MATLAB Lidar Toolbox) and writes to a file a
%(more) water tight mesh (less holes).
% This function actually uses a system call to the terminal (on a mac). The
% system call runs manifold plus, which reads in the mesh files, patches it up
% and then creates a new file. This file is read back in to MATLAB as a mesh file
% and returned to the calling function
%
%   REQUIREMENTS: ManifoldPlus https://github.com/hjwdzh/ManifoldPlus
%                 pyMeshFix: https://pymeshfix.pyvista.org
%                 Lidar Toolbox
%                 MatGeom Toolbox (meshVolume function)
%   INPUTS:
%           - shp: alphaShape object created by the alphaShape function
%           - temp_folder: folder to write and read files
%           - mesh_name: mesh identifier
%           - manifoldPlusPath: path to the installed manifoldPlus file
%
%   ManifoldPlus path on my computer:
%         manifoldPlusPath = "/Users/ernesto/github/ManifoldPlus/build/manifold";
%         --depth. A setting of 6 seems to be optimal. A depth of 8 not as good 
%                   (large files, too much added details), depth of 10 was terrible (and huge files)

%   ---
%   AUTHOR: Ernesto Salcedo, PhD
%   LOCATION: University of Colorado School of Medicine
%   DATE MODIFIED: Sunday, February 25, 2024


arguments
    shp alphaShape
    mesh_name {mustBeText}
    paths struct % must contain temp and manifoldPlus fields
    options.cellDir {mustBeText} % fieldname in paths structure that contains the path for the working dir
end

pymeshfix = py.importlib.import_module('pymeshfix'); % add python pymeshfix library

if ~isempty(options) && isfield(options,'path2use')
    cellDir = paths.(options.cellDir);
else
    cellDir = paths.cellMesh;
end

if exist(paths.manifoldPlus,"file")

    % file decoration for each mesh:
    fdec = ["as" "mp" "fx"]; %as=alphaShape, mp=manifoldPlus, fx=meshFix
    ext = ".obj";

    % generate full file paths (fpaths)
    for n=1:numel(fdec)
        fpaths.(fdec(n)) = fullfile(cellDir, mesh_name + "_" + fdec(n) + ext); 
    end
    shp = surfaceMesh(shp.Points,shp.boundaryFacets); % create mesh object
    
    writeSurfaceMesh(shp,fpaths.as) % write alphaShape obj file

    % write manifoldPlus obj file;
    command = sprintf('%s --input "%s" --output "%s" --depth 6', paths.manifoldPlus, fpaths.as, fpaths.mp); 
    status = system(command);

    if ~status % if manifoldPlus worked
        shp = readSurfaceMesh(fpaths.mp);
        volMP = meshVolume(shp.Vertices,shp.Faces);       

        % generate meshfx mesh
        pymeshfix.clean_from_file(fpaths.mp, fpaths.fx); % write meshfx obj file
        shp = readSurfaceMesh(fpaths.fx); % read it back in
        volFX = meshVolume(shp.Vertices,shp.Faces);
    else
       volMP=Nan;
       volFX=Nan;
       fprintf('Status Error. %s watertight manifold not calcuated\.n', mesh_name)
    end
end
end

% mesh_name = replace(mesh_name,whitespacePattern,"_"); % spaces in name make manifoldPlus crash

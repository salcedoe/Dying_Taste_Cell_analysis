function [manifoldMesh, manifoldVol] = getWaterTightMesh(mesh,mesh_name, paths)
%GETWATERTIGHTMESH Accepts a mesh object (Lidar Toolbox) and returns a
%(more) water tight mesh (less holes).
% This function actually uses a system call to the terminal (on a mac). The
% system call runs manifold plus, which reads in the mesh files, patches it up
% and then creates a new file. This file is read back in to MATLAB as a mesh file
% and returned to the calling function
%
%   REQUIREMENTS: ManifoldPlus https://github.com/hjwdzh/ManifoldPlus
%                 Lidar Toolbox
%                 MatGeom Toolbox (meshVolume function)
%   INPUTS:
%           - mesh: mesh object created by surfaceMesh function
%           - temp_folder: folder to write and read files
%           - mesh_name: mesh identifier
%           - manifoldPlusPath: path to the installed manifoldPlus file
%
%   ManifoldPlus path on my computer:
%         manifoldPlusPath = "/Users/ernesto/github/ManifoldPlus/build/manifold";

%   ---
%   AUTHOR: Ernesto Salcedo, PhD
%   LOCATION: University of Colorado School of Medicine
%   DATE MODIFIED: Sunday, February 25, 2024


arguments
    mesh surfaceMesh
    mesh_name {mustBeText}
    paths struct % must contain temp and manifoldPlus fields
end

if exist(paths.manifoldPlus,"file")
    ext = ".obj";
    obj_in = fullfile(paths.temp, mesh_name + ext); % MATLAB surface mesh file
    writeSurfaceMesh(mesh,obj_in) % write OBJ file

    input_file = obj_in;
    output_file = fullfile(paths.temp, mesh_name + "_manifold" + ext);
    command = sprintf('%s --input "%s" --output "%s" --depth 8', paths.manifoldPlus, input_file, output_file);
    % [status,cmdout] = system(command);
    status = system(command);

    if ~status
        manifoldMesh = readSurfaceMesh(output_file);
        manifoldVol = meshVolume(manifoldMesh.Vertices, manifoldMesh.Faces);
    else
        manifoldMesh = [];
        manifoldVol = nan;
        fprintf('Status Error. %s watertight manifold not calcuated', mesh_name)
    end
end
end

% mesh_name = replace(mesh_name,whitespacePattern,"_"); % spaces in name make manifoldPlus crash

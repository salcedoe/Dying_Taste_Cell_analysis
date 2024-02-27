function manifoldMesh = getWaterTightMesh(mesh,mesh_name, temp_folder,manifoldPlusPath)
%GETWATERTIGHTMESH Accepts a mesh object (Lidar Toolbox) and returns a
%(more) water tight mesh (less holes). 
% This function actually uses a system call to the terminal (on a mac). The
% system call runs manifold plus, which reads in the mesh files, patches it up
% and then creates a new file. This file is read back in to MATLAB as a mesh file 
% and returned to the calling function
%
%   REQUIREMENTS: ManifoldPlus https://github.com/hjwdzh/ManifoldPlus
%                 Lidar Toolbox
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
    temp_folder {mustBeFolder}
    manifoldPlusPath {mustBeFile}
end


ext = ".obj";
obj_in = fullfile(temp_folder, mesh_name + ext); % MATLAB surface mesh file
writeSurfaceMesh(mesh,obj_in) % write OBJ file

% manifoldPlusPath = "/Users/ernesto/github/ManifoldPlus/build/manifold"; % ManifoldPlus file (must be hard coded in)

input_file = obj_in;
output_file = fullfile(temp_folder, mesh_name + "_manifold" + ext);
command = sprintf('%s --input %s --output %s --depth 8', manifoldPlusPath, input_file, output_file);
% [status,cmdout] = system(command);
status = system(command);

if ~status
    manifoldMesh = readSurfaceMesh(output_file);

    % disp("success!")
    % disp (cmdout)
else
    manifoldMesh = [];
    % disp('uh oh')
end

% v = meshVolume(manifold_mesh.Vertices, manifold_mesh.Faces)

end
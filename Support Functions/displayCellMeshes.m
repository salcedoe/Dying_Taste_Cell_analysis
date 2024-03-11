function hvwr = displayCellMeshes(cellName,folderPath)
%DISPLAYCELLMESHES - displays cell meshes as surfaceMesh objects for
% method comparison

arguments
    cellName {mustBeText} % name of cell to be displayed
    folderPath {mustBeText} % path to folder containing cell meshes
end

contents = dir(fullfile(folderPath,cellName+"*.obj*"));

hvwr = gobjects(3,1);
for n=1:3
    % clear(app.("Panel_"+n).Children)
    fullpath = fullfile(folderPath,contents(n).name);
    mesh = readSurfaceMesh(fullpath);
    fprintf('%d. %s - %d\n',n,contents(n).name,mesh.isWatertight);
    hvwr(n) = viewer3d(BackgroundGradient="off",BackgroundColor='w');
    surfaceMeshShow(mesh,Title=sprintf('%d. %s',n,contents(n).name),Parent=hvwr(n))
end
linkprop(hvwr,{'CameraPosition','CameraZoom'})
end
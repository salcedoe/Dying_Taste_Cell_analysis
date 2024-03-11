function T = calcCellMetrics(meshT,tableOutName)
%CALCCELLMETRICS - generate table used in cell morphology analysis: either
%cellT or dyingT

arguments
    meshT table % matlab table containing info on relevant cell meshes
    tableOutName {mustBeText} % name of generated table: either cellT or dyingT
end

% generate paths
path.meshFolder = fileparts(meshT.Properties.UserData.path);
path.lysFolder = fileparts(path.meshFolder);

% preallocate table
count = height(meshT);
T = meshT(:,{'Cell','Type','Health'});
T = [T array2table(zeros(count,3),'VariableNames',["Volume","SurfaceArea","SAV"])];
T.Filename = strings(count,1);

% calculate cell metrics from cell meshes
hwb = waitbar(0,"Please Wait.");
for n=1:count

    Filename = meshT.Cell(n)+sprintf('_%s.obj',meshT.Method(n));
    fullpath = fullfile(path.meshFolder,Filename);
    mesh = readSurfaceMesh(fullpath);

    T.Volume(n) = meshVolume(mesh.Vertices, mesh.Faces);
    T.SurfaceArea(n) = meshSurfaceArea(mesh.Vertices, mesh.Faces);
    T.SAV(n) = T.Volume(n)./T.SurfaceArea(n);
    T.Filename(n) = Filename;

    waitbar(n/count, hwb,sprintf('%d. %s',n,replace(meshT.Cell(n),"_"," ")))
end
T.Properties.UserData.path = fullfile(path.lysFolder,tableOutName + ".mat");
delete(hwb)
end
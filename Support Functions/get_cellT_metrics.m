function [cellT] = get_cellT_metrics(VL, paths, alpha)
%GET_CELL_METRICS. Calculates the volume of each cell
% INPUTS:
% - VL
% - do_plot (boolean): if true, display alpha plots of cells


arguments
    VL table % vertices table
    paths struct % contains relevant directory paths
    alpha {mustBeNonnegative,mustBeScalarOrEmpty} = []
end

if exist(paths.manifoldPlus,"file")
    if ~exist(paths.temp,"dir")
        mkdir(paths.temp)
    end
else
    fprintf('Missing manifoldPlus Function. Watertight mesh volumes not calculated')
end

idT  = VL.Properties.UserData.idT;

% suppress alpha shape warnings
id = 'MATLAB:alphaShape:DupPointsBasicWarnId';
warning('off',id);

% preallocate table
count = height(idT);
z = zeros(count,1);
z3 = zeros(count,3);
s = strings(count,1);
c = categorical(NaN(count,1));

cellT = table(s, c,z, z, z, z3, ...
    VariableNames=["Object","Type","Volume","VolMan","SurfaceArea","Range"]); % VolManifold

for n=1:count
    fprintf("%d. %s\n",n,idT.Cell(n))

    la = VL.Object == idT.Cell(n); % find match cell traces
    vCell = VL{la,["x" "y" "z"]};
    vCell = vCell - mean(vCell);
    vCell = mmAlignSurface2Axes(vCell);
    vCell = mmRotateSurfaceVertices(vCell,'y',90);

    if isempty(alpha)
        shp = alphaShape(vCell); % No alpha input best approximates cell shape, but leaves holes in the surface
    else
        shp = alphaShape(vCell, alpha); %Calculate alpha shape
    end

    % allocate table
    cellT.Object(n) = idT.Cell(n);
    cellT.Health(n) = idT.Health(n);
    cellT.Type(n) = idT.Type(n);
    cellT.Volume(n) = shp.volume;
    cellT.SurfaceArea(n) = shp.surfaceArea;
    cellT.Range(n,:) = range(vCell);

    % calculate manifold mesh (watertight)
    mesh = surfaceMesh(shp.Points,shp.boundaryFacets); % create mesh object
    [~,cellT.VolMan(n)] = getWaterTightMesh(mesh, idT.Cell(n),paths);       

end
cellT.Health = categorical(cellT.Health);
cellT.SAV = cellT.SurfaceArea ./ cellT.Volume;
type = cellT.Type;
type(cellT.Health=="early") = 'ed';
type(cellT.Health=="late") = 'ld';
cellT.PlotSort = categorical(type,{'IV','III','II','I','ld','ed'},'ordinal',true);
cellT.Polarity = ones(height(cellT),1);

cellT.Properties.UserData.path = fullfile(paths.lysosome,"cellT.mat");
save(cellT.Properties.UserData.path,"cellT");
% T.Object = categorical(T.Object);
% T.Type = categorical(T.Type);

end
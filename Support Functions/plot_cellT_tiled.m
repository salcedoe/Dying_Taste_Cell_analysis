function ax = plot_cellT_tiled(VL, cellT, options)
%PLOT_CELLT_TILED Organizes cell plots by cell type (plotsort column). One
%cell type per row

arguments
    VL table % vertices table
    cellT table % cell table
    options.plotFast logical = true
    options.darkTheme char = 'off'
end

switch options.darkTheme % black or white background?
    case 'on'
        fcolor='w';
        falpha=0.2;
        figColor = 'k';
    case 'off'
        fcolor='k';
        falpha=0.1;
        figColor = 'w';
end

cellT = sortrows(cellT,["PlotSort","SurfaceArea"]);
cN=histcounts(cellT.PlotSort,categories(cellT.PlotSort)); 
total = height(cellT);
rows = numel(categories(cellT.PlotSort));
cols = max(cN);

% create tiling indexing to sort cell type by row
tile_idx = NaN(1,total);
last_idx = 0;
for ti = 1:rows
    tile_idx(last_idx+1:last_idx+cN(ti)) = (1:(cN(ti)))+cols*(ti-1);
    last_idx = last_idx+cN(ti);
end

% idT = VL.Properties.UserData.idT;

% prepare to plot
figure(Visible="on");
tiledlayout(rows,cols,TileSpacing="none",Padding="tight");
ax = gobjects(total,1);
cm = turbo(max(VL.SizeLabel));

% wb = waitbar(0,'Rendering...');
fprintf('Rendering...\n')

for n=1:total
        
    [vCell, vLys, szLys] = getVertsAndAlign(VL, cellT.Object(n),cellT.Polarity(n)); % align point clouds to axes

    % plot surfaces
    ax(n) = nexttile(tile_idx(n));

    % PC = pointCloud(vLys); % healthy lysosomes
    pcshow(vLys, szLys,AxesVisibility="off");

    hold on

    if options.plotFast
        plot_alphaShape(vCell, cellT.Object(n),fcolor, falpha);
    else
        plot_patch(vCell,cellT.Object(n),fcolor,falpha);
    end
  
    xlim([-10 10])
    ylim([-10 10])
    zlim([-50 50])

    set(gca,CameraTarget=[0,0,0])

    colormap(cm);

    fprintf('%d. %s\n',n,cellT.Object(n))
    % waitbar(n/total,wb,sprintf('%d. %s',n,cellT.Object(n)))
end
set(gcf,Color=figColor)
end
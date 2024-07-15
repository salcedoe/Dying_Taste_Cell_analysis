function hp = plot_cellT(VL, cellT,cell_render_method, new_fig)
%PLOT_CELLT 3D plots cells from the cellT table. Overlays Cell and Lysosome

arguments
    VL table % vertices table
    cellT table % cell Table - information about each cell
    cell_render_method char = 'alphaShape';
    new_fig logical = true;
end

if new_fig
    figure(Visible="on",Color="white");
    tiledlayout("flow",TileSpacing="none",Padding="tight")
end

% fcolor = 'k';
% falpha = 0.1;

hp = gobjects(height(cellT),1);
cm = turbo(max(VL.SizeLabel));


for n=1:height(cellT)

    Cell = cellT.Cell(n); % find cell name
    polarity = cellT.Polarity(n); % get cell orientation
    nexttile
    hp(n) = plot_cell_lys_overlay(VL,Cell,polarity,cell_render_method);
    % title(sprintf('%d. %s',n,object))

    fprintf('%d. %s\n',n,Cell)
    colormap(cm);

end
end
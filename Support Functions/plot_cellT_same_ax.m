function [hp,vols] = plot_cellT_same_ax(VL, cellT,options)
%PLOT_CELLT_SAME_AX Plots all rows from cellT in the same axis. Useful for
%comparing sizes of cells.
% OUTPUTS:
%   - hp: handle to plotted cells
%   - vols: vector of calculated volumes for each cell

arguments
    VL table % vertices table - x,y,z coords of cells
    cellT table % cell table - id information
    options.alpha {mustBeScalarOrEmpty} = [] % input into alphaShape
end

cm = turbo(max(VL.SizeLabel));

hp = gobjects(height(cellT),1);
vols = zeros(height(cellT),1);

for n=1:height(cellT)

    object = cellT.Object(n);
    polarity = cellT.Polarity(n);

    vCell = getVertsAndAlign(VL, object,polarity); % align point clouds to axes

    vCell = vCell - mean(vCell);
    vCell = mmAlignSurface2Axes(vCell);
    vCell = mmRotateSurfaceVertices(vCell,'y',90);
    vCell(:,1) = vCell(:,1) + n*15;

    if isempty(options.alpha)
        shp = alphaShape(vCell);
    else
        shp = alphaShape(vCell,options.alpha);
    end

    hp(n) = plot(shp, Tag=object);
    vols(n) = shp.volume;
    hold on 
    
    % title(sprintf('%d. %s',n,object))

    fprintf('%d. %s\n',n,object)
    colormap(cm);

end

end
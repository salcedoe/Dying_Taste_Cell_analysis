function hp = plot_cell_lys_overlay(VL,object,polarity,cell_render_method)
%PLOT_CELL_LYS_OVERLAY overlays cell and lysosomes in a patch plot

arguments
    VL table % vertices table
    object {mustBeText} % name of cell to plot
    polarity {mustBeScalarOrEmpty}% controls orientation of cell
    cell_render_method {mustBeText} % render method: we're using alphaShape for all plots
end

[vCell, vLys, szLys] = getVertsFromCellID(VL, object,polarity); % align point clouds to axes

% PC = pointCloud(vLys); % healthy lysosomes

% Display Lysosomes as a Point Cloud plot
pcshow(vLys, szLys,AxesVisibility="off");
hold on

% Display Cell (default = alphaShape)
fcolor = 'k';
falpha = 0.1;
switch cell_render_method
    case 'alphaShape'
        hp = plot_alphaShape(vCell, object,fcolor, falpha);
    case 'PointCloud'
        % pc = pointCloud(vCell);
        hp = pcshow(vCell);
    case 'patch'
        hp = plot_patch(vCell, object,fcolor, falpha);
        axis equal
end

    xlim([-10 10])
    ylim([-10 10])
    zlim([-50 50])

set(gca,CameraTarget=[0,0,0])

axis off

set(gcf,Color='w')
end
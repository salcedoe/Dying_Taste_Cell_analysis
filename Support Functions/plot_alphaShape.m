function hp = plot_alphaShape(verts, tag,fcolor, falpha)
%PLOT_ALPHASHAPE wrapper function to plot vertices as an alphaShape with
%indicated face color and transparency

arguments
    verts (:,3) {mustBeNumeric} % NX3 vertices matrix of x,y,z coordinates
    tag {mustBeText} % tag identifier
    fcolor % face color
    falpha {mustBeNumeric} % face alpha
end

shp = alphaShape(verts,1);
hp = plot(shp, ...
    Tag=tag,...
    FaceColor=fcolor, ...
    FaceAlpha=falpha, ...
    EdgeColor='none');
end
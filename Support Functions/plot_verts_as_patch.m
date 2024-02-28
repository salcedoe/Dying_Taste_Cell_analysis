function hp = plot_verts_as_patch(verts, tag,fcolor, falpha)
%PLOT_VERTS_AS_PATCH Wrapper function to plot input NX3 matrix as a 3D patch

arguments
    verts (:,3) {mustBeNumeric}
    tag {mustBeText} % patch identifier (e.g. cell name)
    fcolor = 'k' % patch faces color
    falpha (1,1) double = 0.1 % patch transparency
end

PC = pointCloud(verts);
% SM = pc2surfacemesh(PC,"ball-pivot",[50,50,70]);
[SM, ~] = pc2surfacemesh(PC,"ball-pivot");

removeDefects(SM,"nonmanifold-edges")
removeDefects(SM,"degenerate-faces")
removeDefects(SM,"unreferenced-vertices")
removeDefects(SM,"duplicate-vertices")
removeDefects(SM,"duplicate-faces")

hp = patch(Faces=SM.Faces, ...
    Vertices=SM.Vertices, ...
    FaceColor=fcolor, ...
    FaceAlpha=falpha, ...
    EdgeColor='none', ...
    Tag=tag);

end
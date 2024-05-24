function plotCellMesh(mesh,fcolor)
%PLOTCELLMESH plot surfaceMesh as a patch
arguments 
    mesh surfaceMesh
    fcolor 
end

simplify(mesh);
% simplify(mesh,SimplificationMethod="quadric-decimation")
% simplify(mesh,SimplificationMethod="vertex-clustering")

patch(Faces=mesh.Faces,Vertices=mesh.Vertices, ...
    FaceColor=fcolor, ...
    edgeAlpha = 0.1)
axis equal off
xlim([-15 15])
ylim([-15 15])
zlim([-50 50])

set(gca,CameraTarget=[0,0,0])
view([0 0])

% lightangle(45,30);
lighting gouraud
material dull

% camera position - adds two opposing lights for better visibility
camlight('right')
camorbit(180,0,'data',[0 0 1])
camlight('right')
end
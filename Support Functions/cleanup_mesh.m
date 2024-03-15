function mesh = cleanup_mesh(mesh)
%CLEANUP_MESH runs series of removeDefects functions on the mesh

removeDefects(mesh,"nonmanifold-edges")
removeDefects(mesh,"degenerate-faces")
removeDefects(mesh,"unreferenced-vertices")
removeDefects(mesh,"duplicate-vertices")
removeDefects(mesh,"duplicate-faces")
end
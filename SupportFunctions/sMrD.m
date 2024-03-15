function [mesh] = sMrD(mesh)
%SMRD Wrapper function that removes defects from MATLAB surfaceMesh
%objects

removeDefects(mesh,"nonmanifold-edges")
removeDefects(mesh,"degenerate-faces")
removeDefects(mesh,"unreferenced-vertices")
removeDefects(mesh,"duplicate-vertices")
removeDefects(mesh,"duplicate-faces")
end
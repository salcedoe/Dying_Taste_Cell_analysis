% create paths structure for the Dying Taste Cell Analysis project
proj = currentProject; %open Dying_Taste_Cell_analysis.prj first
paths.project = proj.RootFolder; 
paths.lysosome = fullfile(paths.project,"Lysosome Analysis");
paths.nuclei = fullfile(paths.project, "Nuclei Analysis");
paths.supportfns = fullfile(paths.project,"Support Functions");
paths.localResources = "/Users/ernesto/Documents/WORK/Research/Finger Lab/Dying Cell Project/";
% paths.objs = fullfile(paths.localResources,"Lysosome Analysis","cell OBJ");
paths.reconstruct = fullfile(paths.localResources,"reconstruct data");

paths.manifoldPlus = "/Users/ernesto/github/ManifoldPlus/build/manifold"; % unix CLI file


% setup matGeom
setupMatGeom
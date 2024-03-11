% create paths structure for the Dying Taste Cell Analysis project
proj = currentProject; %open Dying_Taste_Cell_analysis.prj first
paths.project = proj.RootFolder; 
paths.lysosome = fullfile(paths.project,"Lysosome Analysis");
paths.nuclei = fullfile(paths.project, "Nuclei Analysis");
paths.supportfns = fullfile(paths.project,"Support Functions");
paths.cellMesh = fullfile(paths.lysosome,"cellMeshes");
paths.dyingCellMesh = fullfile(paths.lysosome,"dyingMeshes");



% setup matGeom
setupMatGeom
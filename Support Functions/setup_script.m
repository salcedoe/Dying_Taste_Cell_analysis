proj = currentProject; %open Dying_Taste_Cell_analysis.prj first
paths.project = proj.RootFolder; 
paths.analysis = fullfile(paths.project,"Lysosome Analysis");
paths.supportfns = fullfile(paths.project,"Support Functions");
paths.objs = "/Users/ernesto/Documents/WORK/Research/Finger Lab/Dying Cell Project/Lysosome Analysis/cell OBJ reorientated";

paths.manifoldPlus = "/Users/ernesto/github/ManifoldPlus/build/manifold"; % exe file
paths.temp = "/Users/ernesto/Desktop/temp"; % writable location to stash obj files
if ~exist(paths.temp,"dir")
    mkdir(paths.temp)
end

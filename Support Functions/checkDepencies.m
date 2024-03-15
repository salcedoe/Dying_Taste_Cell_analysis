function checkDepencies
%CHECKDEPENCIES Summary of this function goes here
%   Detailed explanation goes here

proj = currentProject;
paths.project = proj.RootFolder; 
paths.analysis = fullfile(paths.project,"Lysosome Analysis");

paths.manifoldPlus = "/Users/ernesto/github/ManifoldPlus/build/manifold"; % exe file
paths.temp = "/Users/ernesto/Desktop/temp"; % writable location to stash obj files

assignin('base',"paths", paths)
end
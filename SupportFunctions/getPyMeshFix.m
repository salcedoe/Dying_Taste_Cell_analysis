function getPyMeshFix(objects, workDirPath)
%getPyMeshFix Python Wrapper to Marco Attene's MeshFIX - Version 2.1                                                          
%   Dependencies: pymeshfix  https://pymeshfix.pyvista.org

% Import the pymeshfix module
pymeshfix = py.importlib.import_module('pymeshfix');

for n=1:numel(objects)
    input_file = fullfile(workDirPath,objects(n) + "_manifold.obj");
    output_file = fullfile(workDirPath,objects(n) + "_pyfix.obj");
    pymeshfix.clean_from_file(input_file, output_file);
    fprintf('%d. %s saved as: %s\n',n,objects(n),output_file)
end

end
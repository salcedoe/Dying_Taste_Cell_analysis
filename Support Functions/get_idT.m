function idT = get_idT(project_folder)
%GET_IDT load cell_lys_list table
%
% INPUT: project_folder - contains path to folder that contains the
%                       cell_LYS_list.xlsx file
% OUTPUT: idT - id table that contains identifying info on cell and
%               lysosomes
%         idT Columns: Cell, Type, Lysosome, Health, Tastebud, Source,
%                       Dataset, Folder

numVars = 8;
opts = spreadsheetImportOptions("NumVariables", numVars);
opts.DataRange = "A2";
opts.VariableNames = ["Cell", "Type", "Lysosome", "Health", "TasteBud", "Source","Dataset","Folder"];
opts.VariableTypes = repmat("string", 1,numVars);

idT = readtable(fullfile(project_folder,"cell_LYS_list.xlsx"),opts);

save(fullfile(project_folder,"idT.mat"),"idT","-mat")

end
function mt = generateCellMeshTable(tableName,cellInfoTable,paths)
%GENERATECELLMESHTABLE loads or generates meshT or dcmT. If reloading,
%resets the volume columns to nan. This ensures new data is calculated, but
%previous data, such as method is maintained. 

arguments
    tableName {mustBeText} % meshT or dcmT
    cellInfoTable table % idT or dcT
    paths {struct}
end

%   Detailed explanation goes here
if exist(fullfile(paths.cellMesh, tableName + ".mat"),'file') % start with meshT
    fprintf('%s file found and loaded. Using this table for the analysis.',tableName)
    load(fullfile(paths.cellMesh, tableName + ".mat"),"-mat",tableName)
    meshT{:,{'VolAS','VolMP','VolFX'}} = nan(height(meshT),3);
    count=height(meshT);
else
    idT = sortrows(idT,["Type","Health"]);
    meshT = idT(:,{'Cell','Type','Health'});
    count=height(meshT);
    meshT.Method = repmat("mp",count,1);
    meshT.Polarity = ones(count,1);
    % meshT = movevars(meshT,{'Method','Polarity'},'After','Mesh');
    meshT = [meshT array2table(nan(count,4),'VariableNames',["AlphaRadius","VolAS","VolMP","VolFX"])];
end
end
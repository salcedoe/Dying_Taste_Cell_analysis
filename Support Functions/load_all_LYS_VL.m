function VL = load_all_LYS_VL(paths, idT, loadT)
%LOAD_ALL_LYS_VL wrapper function that loads all cell data identified in idT
%   Analysis: Lysosome Analysis
% OUTPUT
%   - VL: vertices list table contains the x,y,z coordinates of the cells
%       and lysosome tracings

arguments
    paths struct % structure containing paths to the relevant folders
    idT table
    loadT table % table containing load last selections
end

VL = [];

for n = 1:height(loadT)
    load_last = loadT.Load_Last(n);
    series_path = fullfile(paths.reconstruct,loadT.Folder(n));
    fprintf('%d. %s.\n',n,loadT.Folder(n));

    [seriesT, traceT] = get_series_contents(series_path,load_last); % true input means load mat files instead

    % filter_str = idT.Object(idT.Folder==loadT.Folder(n));

    la = idT.Folder == loadT.Folder(n);
    filter_str = [idT.Cell(la); idT.Lysosome(la)];

    fTL = filter_trace_list(seriesT,traceT, filter_str,true); % true means exact match
    fTL.Properties.Description = 'lys'; % modifies file name to keep projects separate

    % Load vl
    vl = get_verTCs(seriesT,fTL,load_last);
    vl = get_seg_labels(vl);
    vl.Dataset = repmat(loadT.Dataset(n),height(vl),1);

    switch loadT.Dataset(n) % scale to um
        case 'TF21'
            vl(:,["x","y","z"]) = varfun(@(x) x * 8/1000,vl,InputVariables=["x","y","z"]); % convert to microns
        case 'DS2'
            vl(:,["x","y","z"]) = varfun(@(x) x * 7.49/1000,vl,InputVariables=["x","y","z"]); % convert to microns
    end

    fprintf('vl height: %d\n',height(vl))
    %     height(VL), height(vl),height(VL) + height(vl))

    %Concatenate
    VL = [VL; vl];
end

fprintf('\nGetting VL segmentation labels...\n')
% VL = get_seg_labels(VL); % find individual lysosomes
% VL(:,["x","y","z"]) = varfun(@(x) x * 8/1000,VL,InputVariables=["x","y","z"]); % convert to microns
VL.Properties.VariableUnits(3:5) = repmat({'µm'},1,3);
VL.Properties.UserData.idT = idT;
VL.Properties.UserData.file = fullfile(paths.analysis,"lysosomesVL.mat"); % same folder as live script
save(VL.Properties.UserData.file,"VL")
fprintf('VL saved as %s\n',VL.Properties.UserData.file)

end
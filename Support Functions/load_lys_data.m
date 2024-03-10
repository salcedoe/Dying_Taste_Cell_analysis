function [VL, idT, cellT, lysT] = load_lys_data(paths)

        if exist(fullfile(paths.lysosome,"lysosomesVL.mat"),"file")
            load(fullfile(paths.lysosome,"lysosomesVL.mat"),"-mat","VL")  % load VL
            idT = VL.Properties.UserData.idT;
        end

        if nargout > 2
            load(fullfile(paths.lysosome,'cellT.mat'),"-mat","cellT") %cellT
            load(fullfile(paths.lysosome,'lysT.mat'),"-mat","lysT") %cellT
        end
end

